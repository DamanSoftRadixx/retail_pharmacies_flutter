import 'package:flutter_retail_pharmacies/core/models/response/search_list_response_model.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/add_new_Transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/add_update_quantity_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/medicine_receipt_table_functionality_extension.dart';
import 'package:get/get.dart';

extension SearchTableFunctionalityExtension on AddNewTransferJournalController{
  // searchApiIntegration function is used for searching api integration
  searchApiIntegration({bool isClearListFirst = false}) async{


    print("Searh Request : ${searchTextEditingController.text}, offset : ${offsetCountBottom.value}");
    SearchListResponseModel? searchData = await feathersMedicineService.getSearchData(searchTextEditingController.text, offsetCountBottom.value);
    if(isClearListFirst){
      bottomTableList.clear();
    }
    if(searchData != null && searchData.data!=null && searchTextEditingController.text.isNotEmpty){
      searchData.data?.forEach((element) {
        bottomTableList.value.add(SearchData(name: element.name??"",
            manufacturer: element.manufacturer??"", id: element.id??"", uuid: element.uuid??""));
      });
    }
    totalNumberOfRecordBottom.value=searchData?.total??0;
    loadMoreBottom.value=false;
    bottomTableList.refresh();

    // unselectBottomTableRow();
  }

  onTapBottomTableItem({required int index}){
    changeItemStatusToSelectedForSearchTable(index: index);
  }

  changeItemStatusToSelectedForSearchTable({required int index}){
    unselectTopTableRow();
    selectedIndexBottom.value=index;
    bottomTableFocusBool = true;
    bottomTableList.refresh();
  }

  onDoubleTapBottomTableItem({required int index}){
    changeItemStatusToSelectedForSearchTable(index: index);
    openQuantityPopUp();
  }


  unselectBottomTableRow(){
    bottomTableFocusBool = false;
    selectedIndexBottom.value = -1;
    bottomTableList.refresh();
  }

}