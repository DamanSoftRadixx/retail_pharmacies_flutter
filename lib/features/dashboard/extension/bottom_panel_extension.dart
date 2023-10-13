import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/table_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/wrap_scroll_widget/common_auto_scrool_wrap_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_loader/common_loader.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/bottom_table_functionality.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/screen/dashboard_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';

/*
This class extends the DashboardScreen class.
All the properties of DashboardScreen are accessible to this extension.
Extension is the way to add functionalities to existing class.
*/

extension BottomPanel on DashboardScreen {
  //Bottom panel widget carry all the ui part of bottom view

  bottomPanelWidget() {
    return Column(
      children: [
        // row header is used for title of all the entry which we are showing in the list
        rowHeader(),
        Expanded(
          child: Obx(() => ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: controller.bottomListScrollController,
                itemCount: controller.bottomTableList.length,
                itemBuilder: (context, index) {
                  // it is used for relaod a more data in a list
                  //bottom row grid is used for show items of list

                  return bottomGridRow(index: index);
                },
              )),
        ),
        Visibility(
            visible: controller.loadMoreBottom.value == true,
            child: commonRefreshLoader(color: lightColorPalette.addNewChecksColor.bottomTableLoaderColor.withOpacity(0.6)))
      ],
    );
  }

  //This function returns ui part of table header
  Widget rowHeader() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Flexible(
            flex: 18,
            child: rowHeaderItem(title: AppStrings.fullnaming.tr),
          ),
          Flexible(
            flex: 2,
            child: rowHeaderItem(title: AppStrings.up.tr),
          ),
          Flexible(
            flex: 6,
            child: rowHeaderItem(title: AppStrings.price.tr),
          ),
          Flexible(
            flex: 6,
            child: rowHeaderItem(title: AppStrings.remainder.tr),
          ),
          Flexible(
            flex: 5,
            child: rowHeaderItem(title: AppStrings.series.tr),
          ),
          Flexible(
            flex: 5,
            child: rowHeaderItem(title: AppStrings.termYear.tr),
          ),
          Flexible(
            flex: 2,
            child: rowHeaderItem(title: AppStrings.mx.tr),
          ),
          Flexible(
            flex: 5,
            child: rowHeaderItem(title: AppStrings.ikpu.tr),
          ),
          Flexible(
            flex: 5,
            child: rowHeaderItem(title: AppStrings.promotion.tr),
          ),
        ],
      ),
    );
  }


  rowHeaderItem({required String title}){

    var backgroundColor = lightColorPalette.addNewChecksColor.bottomTableHeadingBgColor;
    var foregroundColor = lightColorPalette.addNewChecksColor.bottomTableHeadingTextColor;

    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        child: Text(
          title,
          style: lightTextTheme.titleSmall?.copyWith(
              color: foregroundColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              fontFamily: AppConstants.retailPharmaciesFontFamily),
        ));
  }

  //This function returns ui part of table rows
  Widget bottomGridRow({required int index}) {

    var backgroundColor = controller.selectedIndexBottom.value == index
        ? lightColorPalette.addNewChecksColor.bottomTableRowBgColorSelected
        : Colors.transparent;


    return wrapScrollTag(
        autoScrollController: controller.bottomListScrollController,
        index: index,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            controller.onTapBottomTableItem(index: index);
          },
          onDoubleTap: () {
            controller.onDoubleTapBottomTableItem(index: index);
          },
          child: ColoredBox(
            color: backgroundColor,
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  commonBottomRowText(
                      flex: 18,
                      name: controller.bottomTableList[index].name ?? ""),
                  commonBottomRowText(
                      flex: 2,
                      name:
                          controller.bottomTableList[index].manufacturer ?? ""),
                  commonBottomRowText(flex: 6, name: ""),
                  commonBottomRowText(flex: 6, name: ""),
                  commonBottomRowText(flex: 5, name: ""),
                  commonBottomRowText(flex: 5, name: ""),
                  commonBottomRowText(flex: 2, name: ""),
                  commonBottomRowText(flex: 5, name: ""),
                  commonBottomRowText(flex: 5, name: ""),
                ],
              ),
            ),
          ),
        ));
  }

  commonBottomRowText({required int flex, required String name}) {
    var foregroundColor = lightColorPalette.addNewChecksColor.bottomTableRowTextColorNormal;


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
        child: tableRowTextWidget(name: name,textColor: foregroundColor),
      ),
    );
  }
}
