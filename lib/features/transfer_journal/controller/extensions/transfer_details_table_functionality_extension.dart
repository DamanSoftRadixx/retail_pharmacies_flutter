import 'dart:developer';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/models/common/quantity_model.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/top_table_response_model.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/transfer_journal_controller.dart';
import 'package:get/get.dart';

extension TransferDetailsTableFunctionalityExtension on TransferJournalController{
  unselectBottomTableRow() {
    bottomTableFocusBool = false;
    selectedIndexBottom.value = -1;
    bottomTableList.refresh();
  }


  getBottomCheckTableData(
      {bool isShowLoader = true, required String docId,bool isClearListFirst = true}) async {
    if (isShowLoader) showBottomTableLoader(true);
    TopTableResponseModel? response =
    await feathersTransferService.fetchTransferDetails(docId,offset: offsetCountBottom.value);
    showBottomTableLoader(false);
    if(isClearListFirst) bottomTableList.clear();
    if(response != null){

      var topTableListModel = response!;

      log("getBottomCheckTableData ${topTableListModel.data}");

      if(isClearListFirst) clearReceiptData();
      if (topTableListModel.data != null && topTableListModel.data!.isNotEmpty) {
        topTableListModel.data?.forEach((element) {
          /*
        Calculate the amount and total payable amount after adding discount.
        If item status == deleted, then its price will not be considered into the total
         */

          transferCreatedDate.value = topTableTableList[selectedIndexTop.value].createdAt ?? "";
          transferSender.value = topTableTableList[selectedIndexTop.value].sender?.organisationAddress ?? "";
          transferReceiver.value = topTableTableList[selectedIndexTop.value].receiver?.organisationAddress ?? "";

          if (element.status?.toLowerCase().toString() !=
              CheckStatus.deleted.name) {
            totalAmount.value = totalAmount.value + (element.cost?.number ?? 0);
            bottomTableList.add(element);

          }
        });

      }

      if(topTableListModel.data != null && topTableListModel.data!.isEmpty){
        isEndOfThePagination.value=true;
      }

    }

    loadMoreBottom.value=false;
    bottomTableList.refresh();
  }

  clearReceiptData(){
    totalAmount.value = 0;
  }


  changeBottomTableItemStatusToSelected({required int index}) {
    // unselectTopTableRow();
    selectedIndexBottom.value=index;
    bottomTableFocusBool = true;
    bottomTableList.refresh();
  }


  onTapBottomTableItem({required int index}) {
    changeBottomTableItemStatusToSelected(index: index);
  }



  getQuantity({required List<Qty> qtyList}) {
    var quantity = qtyList
        .firstWhereOrNull((element) => element.uom?.id == QuantityTypes.pkg.name);
    var partial = qtyList.firstWhereOrNull(
            (element) => element.uom?.id == QuantityTypes.tablets.name);

    var totalQuantity = "0";

    if (quantity != null && partial != null && partial.of != null && (partial?.number ?? 0) != 0) {
      totalQuantity =
      "${quantity.number == 0 ? "" : quantity.number} ${partial.number ?? 0}/${partial.of}";
    } else if (quantity != null) {
      totalQuantity = "${quantity.number ?? 0}";
    } else if (partial != null) {
      totalQuantity = "${partial.number ?? 0}";
    }

    return totalQuantity;
  }


}