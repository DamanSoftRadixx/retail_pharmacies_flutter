import 'package:flutter_retail_pharmacies/core/models/response/search_list_response_model.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/dashboard_contoller.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/bottom_table_functionality.dart';

// This extension contains the logical part related to search field.
extension SearchFieldFunctionality on DashboardController{
  // searchOnChange  function is used for onchange functionality of search textfield
  searchOnChange(String value){
    if(value.isNotEmpty){
      offsetCountBottom.value=0;
      loadMoreBottom.value = false;
      unselectBottomTableRow();
      searchApiIntegration(isClearListFirst: true);
    }else{
      bottomTableList.clear();
      bottomTableList.refresh();
    }
  }


  // searchApiIntegration function is used for searching api integration
  searchApiIntegration({bool isClearListFirst = false}) async{


    print("Searh Request : ${searchTextEditingController.text}, offset : ${offsetCountBottom.value}");
    SearchListResponseModel? searchData = await feathersMedicinesService.getSearchData(searchTextEditingController.text, offsetCountBottom.value);
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

}