import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/local_library/scroll_to_index.dart';
import 'package:flutter_retail_pharmacies/core/models/common/quantity_model.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/time_table_response_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/top_table_response_model.dart';
import 'package:flutter_retail_pharmacies/core/routes/routes.dart';
import 'package:flutter_retail_pharmacies/core/service/feathers_services/feathers_check_service.dart';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';
import 'package:flutter_retail_pharmacies/features/check_details/models/local/check_summary_for_selected_date_model.dart';
import 'package:get/get.dart';

class CheckDetailsController extends GetxController {

  //feathers is a service class which we have use for api integration
  FeathersCheckService feathersCheckService = FeathersCheckService();

  //AutoScrollController - used to scroll the table at particular index
  AutoScrollController topCheckListScrollController = AutoScrollController();
  AutoScrollController bottomListScrollController = AutoScrollController();



  //Below variables are used tp hold the selected index of listviews
  RxInt selectedIndexBottom = (-1).obs;
  RxInt selectedIndexTop = (-1).obs;

  //Below list variables holds the data from the feather apis
  RxList<TimeTableData> topTableTableList = <TimeTableData>[].obs;
  RxList<TopTableData> bottomTableList = <TopTableData>[].obs;

  //Below variables are used to track the currently focused table
  bool topTableFocusBool = false;
  bool bottomTableFocusBool = false;

  //docsId is used for api integration of top table
  RxString docsId = "".obs;

  //Below variables are used to show data on the receipt
  RxInt totalAmount = 0.obs; //Used for showing amount of receipt
  RxInt discount = 0.obs; //Used for showing discount amount of card receipt
  RxInt totalPayableAmountWithDiscount =
      0.obs; //Used for showing grandTotal amount of card receipt

  //isEnabledUpDownKey variable used to create the delay, between the up,down and left, right arrow keys.
  bool isEnabledUpDownKey = true;

  //loaders to wait the socket data
  var showBottomTableLoader = false.obs;
  var showTopTableLoaderCheck = false.obs;


  //Below variables are used to implement the pagination functionality
  RxBool loadMoreTop = false.obs;
  RxInt totalNumberOfRecordTop = 0.obs;
  RxInt offsetCountTop = 0.obs;
  final paginationLengthTop = 10;

  //Below variables are used to implement the pagination functionality
  RxBool loadMoreBottom = false.obs;
  RxBool isEndOfThePagination = false.obs;
  RxInt offsetCountBottom = 0.obs;
  final paginationLengthBottom = 10;
  var selectedDate = DateTime.now().obs;
  var checkSummaryForSelectedDateModel = CheckSummaryForSelectedDateModel().obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("CheckDetailsController onInit");

    initAutoScrollControllers();

    //getTimeListingApiIntegration function is used for api integration of time table
    hitTimeListApi();
  }


  hitTimeListApi(){
    getTimeListingApiIntegrationCheck().then((value) {
      if(topTableTableList.isNotEmpty){
        getBottomCheckTableData(docId: docsId.value);
      }else{
        selectedIndexTop.value = -1;
        selectedIndexBottom.value = -1;
        bottomTableList.clear();
        clearReceiptData();
        topTableTableList.refresh();
      }
    });
  }


  initAutoScrollControllers() {
    bottomListScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, Get.mediaQuery.padding.bottom),
        axis: Axis.vertical);
    topCheckListScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, Get.mediaQuery.padding.bottom),
        axis: Axis.vertical);

    topCheckListScrollController.addListener(() {
      topTablePagination();
    });

    bottomListScrollController.addListener(() {
      bottomTablePagination();
    });


  }

  void topTablePagination() {
    if ((topCheckListScrollController.position.pixels ==
        topCheckListScrollController.position.maxScrollExtent)) {
      print("end of the table");
      if (totalNumberOfRecordTop.value > offsetCountTop.value && !(loadMoreTop.value)) {
        loadMoreTop.value = true;
        offsetCountTop.value += paginationLengthTop;
        print("offsetCount.value<<<<${offsetCountTop.value}");
        getTimeListingApiIntegrationCheck(isClearListFirst: false,isShowLoader: false);
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



  Future scrollToIndex(
      {required int index, required AutoScrollController controller}) async {
    isEnabledUpDownKey = false;
    await controller.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);
    isEnabledUpDownKey = true;
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


  bool onCheckJournalKeyPressed(KeyEvent keyEvent) {
    if (keyEvent is KeyDownEvent || keyEvent is KeyRepeatEvent) {
      var isDialogOpen = Get.isDialogOpen ?? false;
      if (!isDialogOpen) {
        if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp &&
            isEnabledUpDownKey) {
          arrowUPFunctionality();
        } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown &&
            isEnabledUpDownKey) {
          arrowDownFunctionality();
        }
      }
    }

    return false;
  }


    // This function includes the functionality of keyboard up button.
  arrowDownFunctionality() {
    if (topTableFocusBool == true && bottomTableFocusBool == true) {
        bottomTableFocusBool = true;
        bottomIncreaseSelected();
    } else {
      bottomTableFocusBool = false;
      topIncreaseSelected();
    }
  }

  // This function includes the functionality of keyboard down button.
  arrowUPFunctionality() {
    print("bottomTableFocusBool : ${bottomTableFocusBool}");
    print("topTableFocusBool : ${topTableFocusBool}");
    if (bottomTableFocusBool == false) {
      topTableFocusBool = true;
      if (selectedIndexTop.value == (-1)) {
        topIncreaseSelected();
      } else {
        topDecreaseSelected();
      }
    } else {
      bottomDecreaseSelected();
    }
  }

  // This function is used to decrement the focused index of search table.
  bottomDecreaseSelected() {
    if (selectedIndexBottom.value > 0) {
      selectedIndexBottom.value = selectedIndexBottom.value - 1;
      scrollToIndex(
          index: selectedIndexBottom.value,
          controller: bottomListScrollController);
      selectedIndexBottom.refresh();
      bottomTableList.refresh();
    } else {
      bottomTableFocusBool = false;
      selectedIndexBottom.value = -1;
      bottomTableList.refresh();
      arrowUPFunctionality();
    }
  }

  // This function is used to increment the focused index of search table.
  bottomIncreaseSelected() {
    if (selectedIndexBottom.value < (bottomTableList.value.length - 1)) {
      selectedIndexBottom.value = selectedIndexBottom.value + 1;
      scrollToIndex(
          index: selectedIndexBottom.value,
          controller: bottomListScrollController);
      selectedIndexBottom.refresh();
      bottomTableList.refresh();
    }
  }

  // This function is used to decrement the focused index of top data table.
  topDecreaseSelected() {
    if (selectedIndexTop.value > 0) {
      selectedIndexTop.value = selectedIndexTop.value - 1;
      scrollToIndex(
          index: selectedIndexTop.value, controller: topCheckListScrollController);
      selectedIndexTop.refresh();
      topTableTableList.refresh();
      docsId.value = topTableTableList[selectedIndexTop.value].uuid ?? "";
      getBottomCheckTableData(docId: docsId.value);
    }
  }

  // This function is used to increment the focused index of top data table.
  topIncreaseSelected() {
    if (selectedIndexTop.value < (topTableTableList.value.length - 1)) {
      selectedIndexTop.value = selectedIndexTop.value + 1;
      scrollToIndex(
          index: selectedIndexTop.value, controller: topCheckListScrollController);
      topTableTableList();
      docsId.value = topTableTableList[selectedIndexTop.value].uuid ?? "";
      getBottomCheckTableData(docId: docsId.value);

    } else {
      if(bottomTableFocusBool == true)
        arrowDownFunctionality();
        topTableTableList.refresh();
    }
  }

  onTapTopTableItem({required int index, required String docId}) async {
    changeTopTableItemStatusToSelected(index: index);
    await getBottomCheckTableData(docId: docId);
  }

  changeTopTableItemStatusToSelected({required int index}) {
    unselectBottomTableRow();
    selectedIndexTop.value = index;
    topTableFocusBool = true;
    topTableTableList.refresh();
    docsId.value = topTableTableList[index].uuid ?? "";
    getBottomCheckTableData(docId: docsId.value);
  }

  unselectBottomTableRow() {
    bottomTableFocusBool = false;
    selectedIndexBottom.value = -1;
    bottomTableList.refresh();
  }

  Future getTimeListingApiIntegrationCheck({bool isClearListFirst = true,bool isShowLoader = true}) async {

    if(isShowLoader) showTopTableLoaderCheck(true);
    TimeTableResponseModel? data = await feathersCheckService.getTimeDataList(offset: offsetCountTop.value,filters: {
      "date" : getDateForApi(date: selectedDate.value.toString())
    });

    if(isClearListFirst) {
      topTableTableList.clear();
      checkSummaryForSelectedDateModel.value = CheckSummaryForSelectedDateModel();
    }
    showTopTableLoaderCheck(false);


    if (data != null && data.data != null && data.data!.isNotEmpty) {

      var totalHumo = 0.0;
      var totalCash = 0.0;
      var totalUzCard = 0.0;
      var totalOthers = 0.0;

      data.data?.forEach((element) {
        topTableTableList.add(element);
        totalHumo += element.humo.toDoubleConversionWithoutRoundOff();
        totalCash += element.cash.toDoubleConversionWithoutRoundOff();
        totalUzCard += element.uzcard.toDoubleConversionWithoutRoundOff();
        totalOthers += element.other.toDoubleConversionWithoutRoundOff();
      });

      checkSummaryForSelectedDateModel.value.totalCash = totalCash;
      checkSummaryForSelectedDateModel.value.totalHumo = totalHumo;
      checkSummaryForSelectedDateModel.value.totalUzcard = totalUzCard;
      checkSummaryForSelectedDateModel.value.totalOther = totalOthers;

      checkSummaryForSelectedDateModel.refresh();

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

  getBottomCheckTableData(
      {bool isShowLoader = true, required String docId,bool isClearListFirst = true}) async {
    if (isShowLoader) showBottomTableLoader(true);
    TopTableResponseModel? response =
    await feathersCheckService.findCheckLine(docId,offset: offsetCountBottom.value);
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

          if (element.status?.toLowerCase().toString() !=
              CheckStatus.deleted.name) {
            totalAmount.value = totalAmount.value + (element.cost?.number ?? 0);
            totalPayableAmountWithDiscount.value =
                totalPayableAmountWithDiscount.value +
                    (element.cost?.number ?? 0);
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
    totalPayableAmountWithDiscount.value = 0;
  }

  onTapBottomTableItem({required int index}) {
    changeBottomTableItemStatusToSelected(index: index);
  }

  changeBottomTableItemStatusToSelected({required int index}) {
    // unselectTopTableRow();
    selectedIndexBottom.value=index;
    bottomTableFocusBool = true;
    bottomTableList.refresh();
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
      hitTimeListApi();
    }

  }

  onPressBackDateButton(){
    selectedDate.value = selectedDate.value.subtract(Duration(days: 1));
    selectedDate.refresh();
    hitTimeListApi();
  }

  void releaseResources() {
    print("CheckDetailsController dispose");
  }

@override
  void onClose() {
  releaseResources();
  super.onClose();
  }

  @override
  void dispose() {
    releaseResources();
    super.dispose();
  }


}
