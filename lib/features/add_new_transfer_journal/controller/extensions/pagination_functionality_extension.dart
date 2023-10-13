import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/add_new_Transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/medicine_receipt_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/search_table_functionality_extension.dart';
import 'package:get/get.dart';

extension PaginationFunctionalityExtension on AddNewTransferJournalController{

  void bottomTablePagination() {
    if ((bottomListScrollController.position.pixels ==
        bottomListScrollController.position.maxScrollExtent)) {
      print("end of the table");
      if (totalNumberOfRecordBottom.value > offsetCountBottom.value && !(loadMoreBottom.value)) {
        loadMoreBottom.value = true;
        offsetCountBottom.value += paginationLengthBottom;
        print("offsetCount.value<<<<${offsetCountBottom.value}");
        searchApiIntegration();

      }
    }
  }


  void topTablePagination() {
    if ((topListScrollController.position.pixels ==
        topListScrollController.position.maxScrollExtent)) {
      print("isPaginationEndTop : ${isPaginationEndTop}");
      if (isPaginationEndTop.isFalse && !(loadMoreTop.value)) {
        loadMoreTop.value = true;
        offsetCountTop.value += paginationLengthTop;
        print("offsetCount.value<<<<${offsetCountTop.value}");
        getTopTableData(isClearList: false,isShowLoader: false);
      }
    }
  }



  void senderPagination() async{
    if ((senderAutoCompleteData.value.scrollController.position.pixels ==
        senderAutoCompleteData.value.scrollController.position.maxScrollExtent)) {
      if (senderAutoCompleteData.value.isPaginationEnd == false && !(senderAutoCompleteData.value.loadMore)) {
        senderAutoCompleteData.value.loadMore = true;
        senderAutoCompleteData.value.offsetCount += senderAutoCompleteData.value.paginationLength;
         var list = await getOrganisationList(
             isFromPagination: true,
             offset: senderAutoCompleteData.value.offsetCount,
           searchText: senderAutoCompleteData.value.textField.text
         );
          if(list.isEmpty) senderAutoCompleteData.value.isPaginationEnd = true;
        senderAutoCompleteData.value.autoCompleteList.addAll(list);
        senderAutoCompleteData.value.loadMore = false;
        senderAutoCompleteData.refresh();
      }
    }
  }


  void receiverPagination() async{
    if ((receiverAutoCompleteData.value.scrollController.position.pixels ==
        receiverAutoCompleteData.value.scrollController.position.maxScrollExtent)) {
      if (receiverAutoCompleteData.value.isPaginationEnd == false && !(receiverAutoCompleteData.value.loadMore)) {
        receiverAutoCompleteData.value.loadMore = true;
        receiverAutoCompleteData.value.offsetCount += receiverAutoCompleteData.value.paginationLength;
        var list = await getOrganisationList(
            isFromPagination: true,
            offset: receiverAutoCompleteData.value.offsetCount,
            searchText: receiverAutoCompleteData.value.textField.text
        );
        if(list.isEmpty) receiverAutoCompleteData.value.isPaginationEnd = true;
        receiverAutoCompleteData.value.autoCompleteList.addAll(list);
        receiverAutoCompleteData.value.loadMore = false;
        receiverAutoCompleteData.refresh();
      }
    }
  }
}