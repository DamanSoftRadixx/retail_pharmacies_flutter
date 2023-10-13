import 'dart:convert';
import 'dart:developer';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/time_table_response_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/top_table_response_model.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/dashboard_contoller.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/add_quantity_popup_functionality.dart';
import 'package:get/get.dart';


// This extension contains the logical part related to top table.
extension TopTableFunctionality on DashboardController {
  //getTimeListingApiIntegration function is used for api integration of time table
  Future getTimeListingApiIntegration({bool isShowLoader = true, bool isClearList = true,bool isStopLoader = true}) async {
    if(isShowLoader) showTopTableLoader(true);

    if(isClearList){
      offsetCountTime.value = 0;
      isPaginationEndTime.value = false;
    }

    TimeTableResponseModel? data = await feathersCheckService.getTimeDataList(offset: offsetCountTime.value,filters: {
      "status" : "draft"
    });
    if(isStopLoader) showTopTableLoader(false);


    log("TimeTableResponseModel ${jsonEncode(data)}");
    if(isClearList){
      timeTableList.clear();
      topTableList.clear();
      selectedIndexTop.value = -1;
    }

    if (data != null && data.data!.isNotEmpty) {
      data.data?.forEach((element) {
        var status = element.status ?? "";
        if (status != CheckStatus.payed.name) {
          timeTableList.add(element);
        }
      });
      if(timeTableList.isNotEmpty && isClearList){
        docsId.value = timeTableList[0].uuid ?? "";
        selectedTimeTable.value = 0;
        selectedTimeTable.refresh();
        scrollToIndex(index: 0, controller: timeListScrollController);
      }


      loadMoreTime.value=false;
      timeTableList.refresh();
    } else {
      if(!isClearList){
        isPaginationEndTime.value = true;
      }else{
        topTableList.value = [];
        topTableList.refresh();
      }
    }
    loadMoreTime.value = false;
    loadMoreTime.refresh();
    //pagination stopping condition

  }

  onTapTimeListItem({required int index}) {
    selectedTimeTable.value = index;
    docsId.value = timeTableList[selectedTimeTable.value].uuid ?? "";
    if (docsId.value == "temp") {
      topTableList.clear();
      topTableList.refresh();
    } else {
      getTopTableData();
    }
    unselectTopTableRow();

    selectedTimeTable.refresh();
    timeTableList.refresh();
  }

  //getTopTableData function is used for api integration of top time table
  getTopTableData({bool isShowLoader = true,bool isClearList = true}) async {
    if (isShowLoader) showTopTableLoader(true);

    if(isClearList){
      offsetCountTop.value = 0;
      isPaginationEndTop.value = false;
    }
    TopTableResponseModel? topTableListModel = await feathersCheckService.findCheckLine(docsId.value,offset: offsetCountTop.value);
    showTopTableLoader(false);
   if(isClearList){
     topTableList.clear();
     totalAmount.value = 0;
     checkCreatedDate.value = DateTime.now().toString();
     discount.value = 0;
     loadMoreTop.value = false;
     offsetCountTop.value = 0;
     isPaginationEndTop.value = false;
     totalPayableAmountWithDiscount.value = 0;
   }

      if (topTableListModel != null && topTableListModel.data!.isNotEmpty) {
        checkCreatedDate.value =
            timeTableList[selectedTimeTable.value].createdAt ?? "";

        topTableListModel.data?.forEach((element) {
          /*
        Calculate the amount and total payable amount after adding discount.
        If item status == deleted, then its price will not be considered into the total
         */
          if (element.status?.toLowerCase().toString() !=
              CheckStatus.deleted.name) {
            totalAmount.value = totalAmount.value + (element.cost?.number ?? 0);
            totalPayableAmountWithDiscount.value =
                totalPayableAmountWithDiscount.value +
                    (element.cost?.number ?? 0);
          }
          topTableList.add(element);
        });
      }

      if(topTableListModel != null && topTableListModel.data != null && topTableListModel.data!.isEmpty){
        isPaginationEndTop.value = true;
      }

    topTableList.refresh();
    selectedTimeTable.refresh();
    totalAmount.refresh();
    loadMoreTop.value = false;
    checkCreatedDate.refresh();
    totalPayableAmountWithDiscount.refresh();
  }

  onTapTopTableItem({required int index}) {
    changeItemStatusToSelected(index: index);
  }

  changeItemStatusToSelected({required int index}) {
    selectedIndexTop.value = index;
    topTableFocusBool = true;
    bottomTableFocusBool = false;
    selectedIndexBottom.value = -1;
    topTableList.refresh();
    bottomTableList.refresh();
  }

  void onDoubleTapTopTableRow({required int index}) {
    changeItemStatusToSelected(index: index);
    openQuantityPopUp();
  }

  //add new time entry in the time list
  onTapNewEntryButtonInTimeList() {
    timeTableList.insert(
        0,
        TimeTableData(
            createdAt: DateTime.now().toString(),
            status: "draft",
            id: "temp",
            uuid: "temp"));

    docsId.value = "temp";
    selectedTimeTable.value = 0;
    topTableList.clear();
    topTableList.refresh();
    scrollToIndex(
      index: 0,
      controller: timeListScrollController,
    );
    selectedTimeTable.refresh();
    totalPayableAmountWithDiscount.value = 0;
    totalAmount.value = 0;
    discount.value = 0;
    checkCreatedDate.value = DateTime.now().toString();
    totalAmount.refresh();
    discount.refresh();
    totalPayableAmountWithDiscount.refresh();
    checkCreatedDate.refresh();
    timeTableList.refresh();
  }

  unselectTopTableRow() {
    topTableFocusBool = false;
    selectedIndexTop.value = -1;
    topTableList.refresh();
  }

  updateThePaymentStatusToClosed() async {
    showTopTableLoader(true);
    var timeTableData = timeTableList[selectedTimeTable.value];
    Map<String, dynamic> map = {
      "status": CheckStatus.closed.name,
      "date": getDateForApi(date: DateTime.now().toString()),
    };

    // String jsonUser = jsonEncode(tabLine);
    print(
        "********************** updateThePaymentStatus Request start **********************");
    print("updateThePaymentStatus : $map");
    print(
        "********************** updateThePaymentStatus Request start **********************");
    print(
        "********************** Object id ********************** : ${timeTableData.uuid ?? ""}");

    await feathersCheckService
        .patchMethodForCheckTabs(map, timeTableData.id ?? "");
    await getTimeListingApiIntegration(isClearList: true,isShowLoader: true);
    if (timeTableList.isEmpty) {
      topTableList.value = [];
      totalAmount.value = 0;
      checkCreatedDate.value = DateTime.now().toString();
      discount.value = 0;
      totalPayableAmountWithDiscount.value = 0;
      topTableList.refresh();
    } else {
      await getTopTableData(isShowLoader: true);
    }
    showTopTableLoader(false);
  }


  onPressCancelReceipt(){
    if(docsId.value == "temp"){
      getTimeListingApiIntegration().then((value) {
        getTopTableData();
      });
    }else{
      updateThePaymentStatusToClosed();
    }
  }
}
