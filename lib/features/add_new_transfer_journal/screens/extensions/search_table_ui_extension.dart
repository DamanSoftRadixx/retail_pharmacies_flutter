import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_asset/common_image.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_loader/common_loader.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/table_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/wrap_scroll_widget/common_auto_scrool_wrap_widget.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/constants/image_resources.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/keyboard_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/medicine_receipt_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/search_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/screens/add_new_transfer_journal_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

extension SearchTableUiExtension on AddNewTransferJournalScreen{

  //This widget returns the search ui, and used for search purpose.
  searchPanelWidget() {
    var backgroundColor = lightColorPalette.addNewTransferJournalColor.searchFieldBgColor;
    var foregroundColor = lightColorPalette.addNewTransferJournalColor.searchFieldTextColor;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 3, top: 3, bottom: 3),
      decoration: BoxDecoration(
          color: backgroundColor),
      child: Row(
        children: [
          AssetWidget(
            asset: Asset(
              type: AssetType.svg,
              path: ImageResource.searchIcon,
            ),
            height: 23,
            color: lightColorPalette.whiteColor.shade900,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: lightColorPalette.whiteColor.shade900,
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              child: TextField(
                controller: controller.searchTextEditingController,
                focusNode: controller.searchFocusNode,
                onChanged: controller.searchOnChange,
                onTap: () {
                  controller.unselectTopTableRow();
                },
                style: TextStyle(
                    color: foregroundColor,
                  fontWeight: FontWeight.w500
                ),
                decoration: InputDecoration(
                    hintText: AppStrings.search.tr,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    border: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Bottom panel widget carry all the ui part of bottom view

  bottomPanelWidget() {
    return Column(
      children: [
        // row header is used for title of all the entry which we are showing in the list
        rowHeaderBottomTable(),
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
            child: commonRefreshLoader(color: lightColorPalette.addNewTransferJournalColor.bottomTableLoaderColor))
      ],
    );
  }


  //This function returns ui part of table rows
  Widget bottomGridRow({required int index}) {
    // print("index : ${index}, focus : ${controller.searchList.value[index].focusNode.hasFocus}, name : ${controller.searchList.value[index].name}");

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
            color: controller.selectedIndexBottom.value == index
                ? lightColorPalette.addNewTransferJournalColor.bottomTableRowBgColorSelected
                :  lightColorPalette.addNewTransferJournalColor.bottomTableRowBgColorNormal,
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
        child: tableRowTextWidget(name: name,textColor: lightColorPalette.addNewTransferJournalColor.bottomTableRowTextColorNormal),
      ),
    );
  }

  //This function returns ui part of table header
  Widget rowHeaderBottomTable() {

    var headingBgColor = lightColorPalette.addNewTransferJournalColor.bottomTableHeadingBgColor;
    var headingTextColor = lightColorPalette.addNewTransferJournalColor.bottomTableHeadingTextColor;

    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Flexible(
            flex: 18,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: headingBgColor,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  AppStrings.fullnaming.tr,
                  style: lightTextTheme.titleSmall?.copyWith(
                      color: headingTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.retailPharmaciesFontFamily),
                )),
          ),
          Flexible(
            flex: 2,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: headingBgColor,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  AppStrings.up.tr,
                  style: lightTextTheme.titleSmall?.copyWith(
                      color: headingTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.retailPharmaciesFontFamily),
                )),
          ),
          Flexible(
            flex: 6,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: headingBgColor,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  AppStrings.price.tr,
                  style: lightTextTheme.titleSmall?.copyWith(
                      color: headingTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.retailPharmaciesFontFamily),
                )),
          ),
          Flexible(
            flex: 6,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: headingBgColor,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  AppStrings.remainder.tr,
                  style: lightTextTheme.titleSmall?.copyWith(
                      color: headingTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.retailPharmaciesFontFamily),
                )),
          ),
          Flexible(
            flex: 5,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: headingBgColor,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  AppStrings.series.tr,
                  style: lightTextTheme.titleSmall?.copyWith(
                      color: headingTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.retailPharmaciesFontFamily),
                )),
          ),
          Flexible(
            flex: 5,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: headingBgColor,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  AppStrings.termYear.tr,
                  style: lightTextTheme.titleSmall?.copyWith(
                      color: headingTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.retailPharmaciesFontFamily),
                )),
          ),
          Flexible(
            flex: 2,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: headingBgColor,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  AppStrings.mx.tr,
                  style: lightTextTheme.titleSmall?.copyWith(
                      color: headingTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.retailPharmaciesFontFamily),
                )),
          ),
          Flexible(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: headingBgColor,
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              child: Text(
                AppStrings.ikpu.tr,
                style: lightTextTheme.titleSmall?.copyWith(
                    color: headingTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.retailPharmaciesFontFamily),
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: headingBgColor,
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              child: Text(
                AppStrings.promotion.tr,
                style: lightTextTheme.titleSmall?.copyWith(
                    color: headingTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.retailPharmaciesFontFamily),
              ),
            ),
          ),
        ],
      ),
    );
  }
}