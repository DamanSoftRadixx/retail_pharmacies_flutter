import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/models/local/dropdown_model.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/add_new_Transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/medicine_receipt_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/model/transfer_check_creation_model.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/model/transfer_list_response_model.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:flutter_retail_pharmacies/features/organisation/model/network/common/organisation_data.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/transfer_details_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/transfer_journal_controller.dart';
import 'package:get/get.dart';

extension TransferListFunctionalityExtension on TransferJournalController{
  onTapTopTableItem({required int index, required String docId}) async {
    changeTopTableItemStatusToSelected(index: index);
    await getBottomCheckTableData(docId: docId);
  }

  onDoubleTapTopTableItem({required int index, required String docId}) async {
    var selectedData = topTableTableList[index];
    var status = selectedData.status ?? "";

    if(status == TransferCheckStatus.draft.name){
      var addTransferController = Get.put(AddNewTransferJournalController());
      addTransferController.docId.value = selectedData.uuid ?? "";
      addTransferController.id.value = selectedData.id ?? "";
     addTransferController.senderAutoCompleteData.value.textField.text = selectedData.sender?.organisationAddress ?? "";
     addTransferController.senderAutoCompleteData.value.selectedValue = selectedData.sender ?? OrganisationData();
     addTransferController.receiverAutoCompleteData.value.textField.text = selectedData.receiver?.organisationAddress ?? "";
     addTransferController.receiverAutoCompleteData.value.selectedValue = selectedData.receiver ?? OrganisationData();

      addTransferController.getTopTableData();
      dashboardController.setCurrentRightPanelTab(currentTab: RightPanelTabs.addNewTransferJournal);
    }else{
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          isHideCancel: true,
          message: AppStrings.transferIsAlreadySendYouCantEditThis.tr
      );
    }

  }

  changeTopTableItemStatusToSelected({required int index}) {
    unselectBottomTableRow();
    selectedIndexTop.value = index;
    topTableFocusBool = true;
    topTableTableList.refresh();
    docsId.value = topTableTableList[index].uuid ?? "";
    getBottomCheckTableData(docId: docsId.value);
  }


  Future getTransferList({bool isClearListFirst = true,bool isShowLoader = true}) async {

    if(isShowLoader) showTopTableLoaderCheck(true);
    TransferListResponseModel? data = await feathersTransferService.getTransferList(offset: offsetCountTop.value);

    if(isClearListFirst) {
      topTableTableList.clear();
    }
    showTopTableLoaderCheck(false);


    if (data != null && data.data != null && data.data!.isNotEmpty) {
      data.data?.forEach((element) {
        topTableTableList.add(element);
      });


      if(topTableTableList.isNotEmpty){
        if(isClearListFirst){
          docsId.value = topTableTableList[0].uuid ?? "";
          topTableFocusBool = true;
          selectedIndexTop.value = 0;
          scrollToIndex(index: selectedIndexTop.value, controller: topCheckListScrollController);
        }

      }

      totalNumberOfRecordTop.value=data.total??0;
      topTableTableList.refresh();
    } else if(isClearListFirst){
      topTableTableList.value = [];
      topTableTableList.refresh();
    }
    loadMoreTop.value=false;

    topTableTableList.refresh();

  }



  unselectTopTableRow() {
    topTableFocusBool = false;
    selectedIndexTop.value = -1;
    topTableTableList.refresh();
  }



  void onSelectedDate({required DateTime selectedDate}) {
    this.selectedDate.value = selectedDate;
    this.selectedDate.refresh();
  }


  onPressNextDateButton(){

    var currentDate = DateTime.now();
    var sDate = DateTime(selectedDate.value.year,selectedDate.value.month,selectedDate.value.day);
    var cDate = DateTime(currentDate.year,currentDate.month,currentDate.day);

    if(sDate.isBefore(cDate)){
      selectedDate.value =  selectedDate.value.add(Duration(days: 1));
      this.selectedDate.refresh();
      hitTransferListApi();
    }

  }

  onPressBackDateButton(){
    selectedDate.value = selectedDate.value.subtract(Duration(days: 1));
    selectedDate.refresh();
    hitTransferListApi();
  }

}