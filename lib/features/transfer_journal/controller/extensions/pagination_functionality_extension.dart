import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/transfer_details_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/transfer_list_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/transfer_journal_controller.dart';
import 'package:get/get.dart';

extension PaginationFunctionalityExtension on TransferJournalController{
  void topTablePagination() {
    if ((topCheckListScrollController.position.pixels ==
        topCheckListScrollController.position.maxScrollExtent)) {
      print("end of the table");
      if (totalNumberOfRecordTop.value > offsetCountTop.value && !(loadMoreTop.value)) {
        loadMoreTop.value = true;
        offsetCountTop.value += paginationLengthTop;
        print("offsetCount.value<<<<${offsetCountTop.value}");
        getTransferList(isClearListFirst: false,isShowLoader: false);
      }
    }
  }

  void bottomTablePagination() {
    if ((bottomListScrollController.position.pixels ==
        bottomListScrollController.position.maxScrollExtent)) {
      print("end of the table");
      if (isEndOfThePagination.isFalse && !(loadMoreBottom.value)) {
        loadMoreBottom.value = true;
        offsetCountBottom.value += paginationLengthBottom;
        print("offsetCount.value<<<<${offsetCountBottom.value}");
        if(docsId.value != "") getBottomCheckTableData(docId: docsId.value,isShowLoader: false,isClearListFirst: false);
      }
    }
  }



}