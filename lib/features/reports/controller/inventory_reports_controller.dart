import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/local_library/scroll_to_index.dart';
import 'package:flutter_retail_pharmacies/core/service/feathers_services/feathers_reports_service.dart';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/dashboard_contoller.dart';
import 'package:flutter_retail_pharmacies/features/reports/model/local/tabbar_model.dart';
import 'package:flutter_retail_pharmacies/features/reports/model/network/stocks_response_model.dart';
import 'package:flutter_retail_pharmacies/features/reports/model/network/turnover_reports_response.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class InventoryReportsController extends GetxController
    with GetTickerProviderStateMixin {
  //feathers is a service class which we have use for api integration
  FeathersReportsService feathersReportsService = FeathersReportsService();
  var dashboardController = Get.find<DashboardController>();
  var isShowLoader = false.obs;

  TabController? tabBarController;
  var tabBarList = <StockTabBarModel>[].obs;
  var selectedTabIndex = 0.obs;

  //isEnabledUpDownKey variable used to create the delay, between the up,down and left, right arrow keys.
  bool isEnabledUpDownKey = true;

  RxString startDate = ''.obs;
  RxString endDate = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initTabController();
    getInitialInventoryReports();
    log("ReportsController onInit");
  }

  getInitialInventoryReports() async {
    StocksResponseModel? response = await getInventoryReportsListApi();
    if (response != null) {
      var stockList = response.data ?? [];

      // Making groups based on different categories
      var groupList = createGroupsBasedOnCategory(stockList: stockList);

      // Creating only one list, so that we can scroll between different table rows.
      var rowSingleList = createTabList(groupList: groupList);
      tabBarList[0].sectionRowList = rowSingleList;
      tabBarList.refresh();
      return response;
    }
  }

  initTabController() {
    var tabBarItem = StockTabBarModel(
        id: "",
        name: AppStrings.reports.tr,
        sectionRowList: [],
        scrollController: initNewAutoScrollController());
    tabBarList.add(tabBarItem);
    tabBarController = TabController(
      vsync: this, length: tabBarList.length,
      initialIndex: 0, // widget.isFilter ? 0 : state.WHDispatchUIState.tabIndex
    );
  }

  AutoScrollController initNewAutoScrollController() {
    return AutoScrollController();
  }

  updateTabBarController() {
    tabBarController?.dispose();
    tabBarController = null;
    selectedTabIndex.value = tabBarList.length - 1;
    tabBarController = TabController(
      length: tabBarList.length,
      initialIndex: tabBarList.length - 1,
      vsync: this,
    );
    // tabBarController?.animateTo(tabBarList.length - 1);
    tabBarList.refresh();
  }

  showLoader({required bool value}) {
    isShowLoader.value = value;
    isShowLoader.refresh();
  }

  Future<StocksResponseModel?> getInventoryReportsListApi(
      {int offset = 0,
      Map<String, dynamic>? filters,
      String? search,
      bool isFromPagination = false}) async {
    try {
      showLoader(value: true);
      StocksResponseModel? response = await feathersReportsService
          .getInventoryReportsList(filters: filters);
      return response;
    } catch (e) {
      showLoader(value: false);
    }
  }

  Future<TurnoverReportsResponse?> getTurnOverReportsListApi(
      {int offset = 0,
      Map<String, dynamic>? filters,
      String? search,
      bool isFromPagination = false}) async {
    try {
      showLoader(value: true);
      TurnoverReportsResponse? response =
          await feathersReportsService.getTurnOverReportsList(filters: filters);
      showLoader(value: false);
      return response;
    } catch (e) {
      showLoader(value: false);
    }
  }

  void setSelectedTabIndex({required int index}) {
    selectedTabIndex.value = index;
    selectedTabIndex.refresh();
  }

  void onTapRowItemOfGroup({required int sectionRowIndex}) {
    var rowData =
        tabBarList[selectedTabIndex.value].sectionRowList[sectionRowIndex];
    setSelectedGroupRowIndex(rowIndex: sectionRowIndex);
  }

  void onDoubleTapRowItemOfGroup({required int sectionRowIndex}) async {
    var rowData =
        tabBarList[selectedTabIndex.value].sectionRowList[sectionRowIndex];

    print("groupName : ${rowData.groupName}");

    if (rowData.groupName != "") {
      setSelectedGroupRowIndex(rowIndex: sectionRowIndex);
      await addNewTab(sectionRowIndex: sectionRowIndex);
    }
  }

  addNewTab({required int sectionRowIndex}) async {
    var selectedTabData = tabBarList[selectedTabIndex.value];
    var selectedRow =
        selectedTabData.sectionRowList[selectedTabData.selectedRowIndex];
    var selectedRowName = selectedRow.name;
    var currentDate = DateTime.now();
    var tillDate = convertToAPIFormat(dateTime: currentDate);
    var from =
    convertToAPIFormat(dateTime: DateTime(currentDate.year, 1, 1));


    // Add all selected hierarchical filters upto current selection tab in the request
    Map<String, dynamic>? filters = {};

    for (int i = 0; i <= selectedTabIndex.value; i++) {
      var selectedTabData = tabBarList[i];
      var selectedRow =
          selectedTabData.sectionRowList[selectedTabData.selectedRowIndex];
      var categoryName = selectedRow.groupName;
      var selectedRowUid = selectedRow.uuid;
      if (categoryName == ReportsCategories.batch.name) {

        filters.addAll({
          "batch_id": selectedRow.batchId ?? "",
          "batch_date": selectedRow.batchDate ?? "",
          "dates": {"from": from, "till": tillDate}
        });
      } else {
        filters.addAll({categoryName?.toLowerCase() ?? "": "$selectedRowUid"});
      }
    }

    if (selectedRow.groupName == ReportsCategories.batch.name) {
      TurnoverReportsResponse? response =
          await getTurnOverReportsListApi(filters: filters);
      if (response != null) {
        var turnOverList = response.data ?? [];
        if (tabBarList.length > selectedTabIndex.value) {
          var totalTabListLength = tabBarList.length - 1;
          // Remove all the forward tabs before adding new one.
          for (int i = totalTabListLength; i > selectedTabIndex.value; i--) {
            tabBarList.removeLast();
          }
        }



        // As we have date filters in case of turnover category,
        // so we are initialising the default values for start and end date here
        // start date is the first date of the current year
        // end date is the current date

        //createGroupList
        List<StockRowModel> rowList = [
          StockRowModel(
            isTurnOverTab: true,
            isTableHeaderRow: true,
            groupName: ReportsCategories.turnOver.name,
          ),
        ];

        for (var turnOverData in turnOverList) {
          rowList.add(
            StockRowModel(isTurnOverTab: true, turnOverData: turnOverData),
          );
        }

        tabBarList.add(StockTabBarModel(
            id: "",
            name: AppStrings.turnOverReports.tr,
            sectionRowList: rowList,
            scrollController: initNewAutoScrollController(),
          isAvailableFilters: true,
          selectedDateFilterStartDate: from.toString(),
            selectedDateFilterEndDate: tillDate.toString()
        ));
        updateTabBarController();

        return response;
      }
    }
    else {
      StocksResponseModel? response =
          await getInventoryReportsListApi(filters: filters);
      if (response != null) {
        var stockList = response.data ?? [];
        // Remove all the forward tabs before adding new one.
        if (tabBarList.length > selectedTabIndex.value) {
          var totalTabListLength = tabBarList.length;
          for (int i = tabBarList.length - 1; i > selectedTabIndex.value; i--) {
            tabBarList.removeLast();
          }
        }

        // Making groups based on different categories
        var groupList = createGroupsBasedOnCategory(stockList: stockList);

        // Creating only one list, so that we can scroll between different table rows.
        var rowSingleList = createTabList(groupList: groupList);

        tabBarList.add(StockTabBarModel(
            id: "",
            name: selectedRowName ?? "",
            sectionRowList: rowSingleList,
            scrollController: initNewAutoScrollController()));
        updateTabBarController();

        return response;
      }
    }
  }

  List<StockRowModel> createTabList(
      {required List<StockTabGroupModel> groupList}) {
    var rowCount = 0;
    var rowSingleList = <StockRowModel>[];
    for (var group in groupList) {

      var newGroupHeader = StockRowModel(
          isTableHeaderRow: true,
          groupName: group.groupName,
          isShowNameColumn:
          (group.groupName == ReportsCategories.storage.name ||
              group.groupName == ReportsCategories.category.name ||
              group.groupName == ReportsCategories.goods.name),
          isShowDateColumn: (group.groupName == ReportsCategories.batch.name),
          isShowQtyColumn: (group.groupName == ReportsCategories.goods.name ||
              group.groupName == ReportsCategories.batch.name));

      rowSingleList.add(newGroupHeader);
      for (var row in group.rowList) {
        row.key = rowCount;
        row.isShowNameColumn =
            (group.groupName == ReportsCategories.storage.name ||
                group.groupName == ReportsCategories.category.name ||
                group.groupName == ReportsCategories.goods.name);
        row.isShowDateColumn =
            (group.groupName == ReportsCategories.batch.name);
        row.isShowQtyColumn =
            (group.groupName == ReportsCategories.goods.name ||
                group.groupName == ReportsCategories.batch.name);
        rowCount += 1;
        rowSingleList.add(row);
      }
    }

    return rowSingleList;
  }

  List<StockTabGroupModel> createGroupsBasedOnCategory(
      {required List<StockData> stockList}) {
    List<StockTabGroupModel> groupList = [];

    for (var stockData in stockList) {
      StockTabGroupModel? groupModel = groupList.firstWhereOrNull(
          (element) => element.groupName == (stockData.category ?? ""));
      if (groupModel != null) {
        groupModel.rowList.add(
          StockRowModel(
            uuid: stockData.uuid ?? "",
            id: stockData.id ?? "",
            name: stockData.name ?? "",
            groupName: stockData.category ?? "",
            cost: stockData.balance?.cost ?? "0",
            quantity: (stockData.balance?.qty ?? 0)
                .toString()
                .toStringConversionWithoutZero(),
            batchId: stockData.batch?.id ?? "",
            batchDate: stockData.batch?.date ?? "",
          ),
        );
      } else {
        StockTabGroupModel groupModelNew = StockTabGroupModel(
            key: groupList.length,
            groupName: stockData.category ?? "",
            rowList: [
              StockRowModel(
                uuid: stockData.uuid ?? "",
                id: stockData.id ?? "",
                name: stockData.name ?? "",
                groupName: stockData.category ?? "",
                cost: stockData.balance?.cost ?? "0",
                quantity: (stockData.balance?.qty ?? 0)
                    .toString()
                    .toStringConversionWithoutZero(),
                batchId: stockData.batch?.id ?? "",
                batchDate: stockData.batch?.date ?? "",
              )
            ]);
        groupList.add(groupModelNew);
      }
    }

    return groupList;
  }

  void setSelectedGroupRowIndex({required int rowIndex}) {
    var tab = tabBarList[selectedTabIndex.value];
    tab.selectedRowIndex = rowIndex;
    tabBarList.refresh();
  }

  void onRangeDateSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      if (args.value is PickerDateRange) {
        startDate.value = convertToAPIFormat(dateTime: args.value.startDate);
        endDate.value =  convertToAPIFormat(dateTime: args.value.endDate ?? args.value.startDate);
      }
  }

  void onRangeDateSelectionDone() async{
    Get.back();

    var tab = tabBarList[selectedTabIndex.value];

    tab.selectedDateFilterStartDate = startDate.value;
    tab.selectedDateFilterEndDate = endDate.value;
    showLoader(value: true);

    // Add all selected hierarchical filters upto current selection tab in the request
    Map<String, dynamic>? filters = {};

    for (int i = 0; i <= selectedTabIndex.value - 1; i++) {
      var selectedTabData = tabBarList[i];
      var selectedRow =
      selectedTabData.sectionRowList[selectedTabData.selectedRowIndex];
      var categoryName = selectedRow.groupName;
      var selectedRowUid = selectedRow.uuid;
      if (categoryName == ReportsCategories.batch.name) {

        filters.addAll({
          "batch_id": selectedRow.batchId ?? "",
          "batch_date": selectedRow.batchDate ?? "",
          "dates": {"from": startDate.value, "till": endDate.value}
        });
      } else {
        filters.addAll({categoryName?.toLowerCase() ?? "": "$selectedRowUid"});
      }
    }

    TurnoverReportsResponse? response =
        await getTurnOverReportsListApi(filters: filters);

    if(response != null){
      var responseList = response?.data ?? [];

      //createGroupList
      //add table header
      List<StockRowModel> rowList = [
        StockRowModel(
            isTurnOverTab: true,
            isTableHeaderRow: true,
            groupName: ReportsCategories.turnOver.name,
        ),
      ];

      // add table rows
      for (var turnOverData in responseList) {
        rowList.add(
          StockRowModel(isTurnOverTab: true, turnOverData: turnOverData),
        );
      }

      tabBarList[selectedTabIndex.value].sectionRowList = rowList;
      tabBarList[selectedTabIndex.value].selectedRowIndex = -1;
      tabBarList.refresh();

    }

  }

  void releaseResources() {
    log("ReportsController onInit");
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

  void onTapDateFilterArrowButton({required int sectionRowIndex}) {
    tabBarList[selectedTabIndex.value].isShowDatePicker = !(tabBarList[selectedTabIndex.value].isShowDatePicker);
    tabBarList.refresh();
  }
}
