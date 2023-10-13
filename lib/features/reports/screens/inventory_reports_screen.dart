import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/date_picker/date_picker_util.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/app_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/table_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/common_textfield.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/wrap_scroll_widget/common_auto_scrool_wrap_widget.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';
import 'package:flutter_retail_pharmacies/features/reports/controller/inventory_reports_controller.dart';
import 'package:flutter_retail_pharmacies/features/reports/model/local/tabbar_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class InventoryReportsScreen extends StatelessWidget {
  var controller = Get.put(InventoryReportsController());

  InventoryReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          body: SafeArea(
            child: Obx(() => Column(children: <Widget>[
              TabBar(
                labelStyle: CustomTextTheme.normalText2(
                    color: lightColorPalette.themeColor.shade900),
                unselectedLabelColor:
                lightColorPalette.themeColor.shade900,
                labelColor: lightColorPalette.themeColor.shade900,
                indicatorColor: lightColorPalette.themeColor.shade900,
                controller: controller.tabBarController,
                isScrollable: true,
                onTap: (int index){
                  controller.setSelectedTabIndex(index : index);
                },
                tabs: [
                  ...controller.tabBarList
                      .map((e) => Tab(text: "${e.name}"))
                      .toList()
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: controller.tabBarController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: buildChildren(),
                ),
              ),
            ])),
          ),
        );
  }

  List<Widget> buildChildren() {
    final List<Widget> widgets = [];
    for (int i=0; i<=controller.tabBarList.length - 1;  i++) {
      var tabBarSection = controller.tabBarList[i];

      widgets.add(groupListWidget(stockTabBarModel: tabBarSection,tabIndex: i));
    }

    return widgets;
  }

  Widget groupListWidget({required StockTabBarModel stockTabBarModel, required int tabIndex}) {
    return Container(
      margin: EdgeInsets.only(left: 50,right: 50,bottom: 50),
      padding: EdgeInsets.only(left: 50,right: 50),
      decoration: BoxDecoration(
        // border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: ClipRRect(
        borderRadius:  BorderRadius.all(Radius.circular(5)),
        child: ListView.builder(
            itemCount: stockTabBarModel.sectionRowList.length,
            controller: stockTabBarModel.scrollController,
            physics: const RangeMaintainingScrollPhysics(),
            key: PageStorageKey<int>(tabIndex),
            itemBuilder: (context, sectionRowIndex) {
              var sectionRowItem = stockTabBarModel.sectionRowList[sectionRowIndex];
              var selectedTab = controller.tabBarList[controller.selectedTabIndex.value];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(sectionRowItem.isTableHeaderRow && selectedTab.isAvailableFilters) datePickerWidget(
                      isShowDatePicker: selectedTab.isShowDatePicker,
                      sectionRowIndex: sectionRowIndex, stockRowModel: sectionRowItem),
                  if(sectionRowItem.isTableHeaderRow) SizedBox(height: 20),
                  if(sectionRowItem.isTableHeaderRow) groupHeaderWidget(headerName: sectionRowItem.groupName ?? ""),
                  if(sectionRowItem.isTableHeaderRow) rowTableTitleWidget(stockRowModel: sectionRowItem,sectionRowIndex: sectionRowIndex),
                  if(!sectionRowItem.isTableHeaderRow) wrapScrollTag(
                    index: sectionRowItem.key,
                    child: topCheckGridRow(stockRowModel: sectionRowItem,sectionRowIndex: sectionRowIndex),
                    autoScrollController: stockTabBarModel.scrollController,
                  )
                ],
              );
            }),
      ),
    );
  }


  groupHeaderWidget({required String headerName}){
    return Container(
      width: 1.sw,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
        child: AppTextWidget(
          text: headerName.capitalizeFirst ?? "",
          style: CustomTextTheme.heading2(color: lightColorPalette.blackColor.shade900),
        ));
  }


  Widget rowTableTitleWidget({required StockRowModel stockRowModel,required int sectionRowIndex}) {

    if(stockRowModel.isTurnOverTab){

      return Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Flexible(
                  flex: 10,
                  child: topTableHeadingTextWidget(text: AppStrings.document.tr),
                ),

                Flexible(
                  flex: 10,
                  child: topTableHeadingTextWidget(text: AppStrings.operation.tr),
                ),
                Flexible(
                  flex: 10,
                  child: topTableHeadingTextWidget(text: AppStrings.balance.tr),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 50,
            child: Row(
              children: [
                Flexible(
                  flex: 5,
                  child: topTableHeadingTextWidget(text: AppStrings.date.tr),
                ),
                Flexible(
                  flex: 5,
                  child: topTableHeadingTextWidget(text: AppStrings.status.tr),
                ),
                Flexible(
                  flex: 5,
                  child: topTableHeadingTextWidget(text: AppStrings.quantity.tr),
                ),
                Flexible(
                  flex: 5,
                  child: topTableHeadingTextWidget(text: AppStrings.cost.tr),
                ),
                Flexible(
                  flex: 5,
                  child: topTableHeadingTextWidget(text: AppStrings.quantity.tr),
                ),
                Flexible(
                  flex: 5,
                  child: topTableHeadingTextWidget(text: AppStrings.cost.tr),
                ),
              ],
            ),
          ),
        ],
      );
  }

    return SizedBox(
      height: 50,
      child: Row(
        children: [
          //Date time
          if(stockRowModel.isShowNameColumn) Flexible(
            flex: 10,
            child: topTableHeadingTextWidget(text: AppStrings.reportName.tr),
          ),
          //Status
          if(stockRowModel.isShowDateColumn) Flexible(
            flex: 5,
            child: topTableHeadingTextWidget(text: AppStrings.date.tr),
          ),

          if(stockRowModel.isShowQtyColumn) Flexible(
            flex: 5,
            child: topTableHeadingTextWidget(text: AppStrings.quantity.tr),
          ),

          //Income/Outcome
          Flexible(
            flex: 5,
            child: topTableHeadingTextWidget(text: AppStrings.cost.tr),
          ),

        ],
      ),
    );
  }

  topTableHeadingTextWidget({required String text}) {
    var backgroundColor = lightColorPalette.inventoryReportsColor.tableHeaderBgColor;
    var textColor = lightColorPalette.inventoryReportsColor.tableHeaderTextColor;

    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: lightTextTheme.titleSmall?.copyWith(
              color: textColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              fontFamily: AppConstants.retailPharmaciesFontFamily),
        ));
  }

  Widget topCheckGridRow({required StockRowModel stockRowModel,required int sectionRowIndex}) {
    var selectedTab = controller.tabBarList[controller.selectedTabIndex.value];

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        controller.onTapRowItemOfGroup(sectionRowIndex: sectionRowIndex);
      },
      onDoubleTap: () {
        controller.onDoubleTapRowItemOfGroup(sectionRowIndex: sectionRowIndex);
      },
      child:  ColoredBox(
        color: selectedTab.selectedRowIndex == sectionRowIndex ? lightColorPalette.inventoryReportsColor.tableRowSelectedBgColor
            : lightColorPalette.inventoryReportsColor.tableRowUnSelectedBgColor,
        child: getTableRowsBasedOnReportTypes(stockRowModel: stockRowModel,sectionRowIndex: sectionRowIndex),
      ),
    );
  }


  getTableRowsBasedOnReportTypes({required StockRowModel stockRowModel,required int sectionRowIndex}){

    if(stockRowModel.isTurnOverTab){

      var turnOverStatus = stockRowModel.turnOverData?.type ?? "";
      var cost = "";
      var qty =  "";

      if(turnOverStatus == TurnOverReportStatus.closeBalance.value ||
          turnOverStatus == TurnOverReportStatus.openBalance.value){
        cost = stockRowModel.turnOverData?.cost ?? "";
        qty = stockRowModel.turnOverData?.qty ?? "";
      }else{
        turnOverStatus = stockRowModel.turnOverData?.op?.type ?? "";
        cost = stockRowModel.turnOverData?.op?.cost ?? "";
        qty = stockRowModel.turnOverData?.op?.qty ?? "";
      }


      return SizedBox(
        height: 40.h,
        child: Row(
          children: [
            checkPaymentTableRowText(
                flex: 5,
                name: stockRowModel.turnOverData?.date ?? ""),

            checkPaymentTableRowText(
              flex: 5,
              name: getTurnOverReportStatus(type: turnOverStatus),
            ),

            checkPaymentTableRowText(
              flex: 5,
              name: qty,
            ),
            checkPaymentTableRowText(flex: 5, name: cost),

            checkPaymentTableRowText(
              flex: 5,
              name: qty,
            ),
            checkPaymentTableRowText(flex: 5, name: cost),
          ],
        ),
      );
    }else{
      String batchDate = stockRowModel.batchDate ?? "";
      return SizedBox(
        height: 40.h,
        child: Row(
          children: [
            if(stockRowModel.isShowNameColumn) checkPaymentTableRowText(
                flex: 10,
                name: stockRowModel.name ?? ""),

            if(stockRowModel.isShowDateColumn) checkPaymentTableRowText(
                flex: 5,
                name: batchDate == "1970-01-01" ? AppStrings.unknown.tr : stockRowModel.batchDate ?? ""),

            if(stockRowModel.isShowQtyColumn) checkPaymentTableRowText(
              flex: 5,
              name: stockRowModel.quantity ?? "",
            ),
            checkPaymentTableRowText(flex: 5, name: (stockRowModel.cost).toStringConversionWithoutZero() ?? ""),
          ],
        ),
      );

    }
  }

  String getTurnOverReportStatus({required String type}){
    if(type == TurnOverReportStatus.openBalance.value){
      return AppStrings.openBalance.tr;
    }else if(type == TurnOverReportStatus.closeBalance.value){
      return AppStrings.closeBalance.tr;
    }else if(type == TurnOverReportStatus.receive.value){
      return AppStrings.received.tr;
    }else{
      return AppStrings.issued.tr;
    }
  }



  checkPaymentTableRowText({required int flex, required String name, Color? textColor}) {
    return Flexible(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        child: tableRowTextWidget(name: name,textColor: textColor),
      ),
    );
  }

  Widget datePickerWidget({required bool isShowDatePicker,
    required StockRowModel stockRowModel,
    required int sectionRowIndex }){

    var selectedTab = controller.tabBarList[controller.selectedTabIndex.value];

    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: Container(
        width: 300,
        color: lightColorPalette.whiteColor.shade900,
        child: commonTextFieldWidgetAuth(
            controller: selectedTab.selectedDateFilterEndDate != "" ?
            TextEditingController(text: "${convertToLocalFormat(dateTime: selectedTab.selectedDateFilterStartDate ?? "")} - ${convertToLocalFormat(dateTime: selectedTab.selectedDateFilterEndDate ?? "")}") : TextEditingController(text: convertToLocalFormat(dateTime: selectedTab.selectedDateFilterStartDate ?? "")),
            onTap: (){
              rangeSelectionDatePickerDialog(onSelectionChanged: (args){
                controller.onRangeDateSelectionChanged(args);
              },onTap: (){
                controller.onRangeDateSelectionDone();
              },selectedEndDate: selectedTab.selectedDateFilterStartDate ?? "",selectedStartDate: selectedTab.selectedDateFilterEndDate ?? "");
            },
            readOnly: true,
            leadingIcon: Icons.calendar_month),
      ),
    );
  }


}
