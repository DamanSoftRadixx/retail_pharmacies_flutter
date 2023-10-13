import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/table_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/wrap_scroll_widget/common_auto_scrool_wrap_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_asset/common_image.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_loader/common_loader.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/constants/image_resources.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/top_table_functionality.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/screen/dashboard_screen.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_loader.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/no_data_found_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/*
This class extends the DashboardScreen class.
All the properties of DashboardScreen are accessible to this extension.
Extension is the way to add functionalities to existing class.
*/

extension TopPanelExtension on DashboardScreen {
  //Top panel widget carry all the ui part of top view
  Widget topPanelWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //ViewPager is used for handling a list of records in the help of pager. Also we can able to scroll and see multiple records.
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.black,
              width: 1,
            )),
            child: Row(
              children: [
                Expanded(
                  child: topTable(),
                ),
                grandTotalReceiptInfo(),
              ],
            ),
          ),
        ),

        SizedBox(
          height: 40,
          child: Obx(() => Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.black,
                  width: 1,
                ))),
                child: Row(
                  children: [
                    newEntryButton(),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: controller.timeListScrollController,
                        scrollDirection: Axis.horizontal,
                        addAutomaticKeepAlives: true,
                        itemCount: controller.timeTableList.length,
                        itemBuilder: (context, index) {
                          // custom time button helps to move another record on click action
                          return wrapScrollTag(
                              index: index,
                              child: customTimeButton(index: index),
                              autoScrollController: controller.timeListScrollController);
                        },
                      ),
                    ),
                    Visibility(
                        visible: controller.loadMoreTime.value == true,
                        child: commonRefreshLoader(color: lightColorPalette.greenColor.shade900))
                  ],
                ),
              )),
        )
      ],
    );
  }

  //ViewPager item ui
  Widget topTable() {
    return Obx(() => Column(children: [
          rowHeader(),
          Expanded(
            child: controller.showTopTableLoader.value
                ? commonLoader(color: lightColorPalette.addNewChecksColor.topTableLoaderColor)
                : (controller.topTableList.isEmpty
                    ? noDataFound()
                    : ListView.builder(
                        shrinkWrap: true,
                        controller: controller.topListScrollController,
                        physics: const BouncingScrollPhysics(),
                        addAutomaticKeepAlives: true,
                        scrollDirection: Axis.vertical,
                        itemCount: controller.topTableList.length,
                        itemBuilder: (context, index) {
                          print("controller.dataList.length  :${controller.topTableList.length}");

                          return wrapScrollTag(
                              index: index,
                              child: filledItemListingRow(
                                index: index,
                              ),
                              autoScrollController: controller.topListScrollController);
                        },
                      )),
          ),
          Visibility(
              visible: controller.loadMoreTop.value == true,
              child: commonRefreshLoader(color: lightColorPalette.themeColor.shade900))
        ]));
  }

  //This function returns ui part of table header
  Widget rowHeader() {
    return SizedBox(
      height: 50.h,
      child: Row(
        children: [
          Flexible(
            flex: 18,
            child: rowHeaderItem(title: AppStrings.fullnaming.tr),
          ),
          Flexible(
            flex: 4,
            child: rowHeaderItem(title: AppStrings.qty.tr),
          ),
          Flexible(
            flex: 6,
            child: rowHeaderItem(title: AppStrings.price.tr),
          ),
          Flexible(
            flex: 6,
            child: rowHeaderItem(title: AppStrings.sum.tr),
          ),
          Flexible(
            flex: 5,
            child: rowHeaderItem(title: AppStrings.termYear.tr),
          ),
          Flexible(
            flex: 5,
            child: rowHeaderItem(title: AppStrings.series.tr),
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
            child: rowHeaderItem(title: AppStrings.mark.tr),
          ),
        ],
      ),
    );
  }


  Widget rowHeaderItem({required String title}){

    var backgroundColor = lightColorPalette.addNewChecksColor.topTableHeadingBgColor;
    var foregroundColor = lightColorPalette.addNewChecksColor.topTableHeadingTextColor;


    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: lightColorPalette.blackColor.shade900,
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
      ),
    );
  }

  //This function returns ui part of table rows
  Widget filledItemListingRow({required int index}) {
    var selectedTopItem = controller.topTableList[index];
    var status = selectedTopItem.status ?? "";
    print("status : $status");

    return GestureDetector(
      onTap: () {
        controller.onTapTopTableItem(index: index);
      },
      onDoubleTap: () {
        controller.onDoubleTapTopTableRow(index: index);
      },
      child: ColoredBox(
        color: getTheBackgroundColorOfRow(index: index),
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              commonTopRowText(flex: 18, name: controller.topTableList.value[index].goods?.name ?? "", index: index),
              commonTopRowText(
                  flex: 4,
                  name: controller.getQuantity(qtyList: controller.topTableList.value[index].qty ?? []),
                  index: index),
              commonTopRowText(
                  flex: 6, name: (controller.topTableList.value[index].price?.number).toString(), index: index),
              commonTopRowText(
                  flex: 6, name: (controller.topTableList.value[index].cost?.number).toString(), index: index),
              commonTopRowText(flex: 5, name: '', index: index),
              commonTopRowText(flex: 5, name: '', index: index),
              commonTopRowText(flex: 2, name: '', index: index),
              commonTopRowText(flex: 5, name: '', index: index),
              commonTopRowText(flex: 5, name: '', index: index),
              /* commonTopRowAction(flex: 5,onTapAction: (){
                controller.deleteTopTableSelectedItem(index: index);
              })*/
            ],
          ),
        ),
      ),
    );
  }

  Color getTheBackgroundColorOfRow({required int index}) {
    var selectedTopItem = controller.topTableList[index];
    var status = selectedTopItem.status ?? "";

    if (controller.selectedIndexTop.value == index) {
      return lightColorPalette.addNewChecksColor.topTableRowBgColorSelected;
    } else if (status == CheckStatus.deleted.name) {
      return lightColorPalette.addNewChecksColor.topTableRowBgColorDeleted;
    } else {
      return lightColorPalette.addNewChecksColor.topTableRowBgColorNormal;
    }
  }

  Color getTextColorOfRow({required int index}) {
    var selectedTopItem = controller.topTableList[index];
    var status = selectedTopItem.status ?? "";

    if (status == CheckStatus.deleted.name) {
      return lightColorPalette.addNewChecksColor.topTableRowTextColorDeleted;
    } else {
      return lightColorPalette.addNewChecksColor.topTableRowTextColorNormal;
    }
  }

  /* This function returns ui part of new time entry button. When user click on the button,
  it will add one entry in the time selection list. */
  Widget newEntryButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: InkWell(
        onTap: () async {
          controller.onTapNewEntryButtonInTimeList();
        },
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            alignment: Alignment.center,
            color: lightColorPalette.greenColor.shade900,
            child: Text(
              AppStrings.newCheck.tr,
              style: lightTextTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppConstants.retailPharmaciesFontFamily),
            )),
      ),
    );
  }

  /* This function returns ui part of time selection list. */
  Widget customTimeButton({required int index}) {
    return GestureDetector(
      onTap: () {
        controller.onTapTimeListItem(index: index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: getBackgroundColorForCheckTab(index: index),
            border: Border(
                left: BorderSide(color: Colors.black, width: index == 0 ? 1 : 0.5),
                right:
                    BorderSide(color: Colors.black, width: (index == controller.timeTableList.length - 1) ? 1 : 0.5)),
          ),
          child: Text(
            controller.timeTableList.value[index].createdAt.toString().split(" ")[1].split(".")[0],
            style: lightTextTheme.bodySmall?.copyWith(
                color: getForegroundColorForCheckTab(index: index),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppConstants.retailPharmaciesFontFamily),
          ),
        ),
      ),
    );
  }

  getBackgroundColorForCheckTab({
    required int index,
  }) {
    var status = controller.timeTableList[index].status ?? "";
    if (controller.selectedTimeTable.value == index) {
      return lightColorPalette.greenColor.shade900.withOpacity(0.2);
    } else {
      return lightColorPalette.whiteColor.shade900;
    }
  }

  getForegroundColorForCheckTab({
    required int index,
  }) {
    var status = controller.timeTableList[index].status ?? "";
    if (status == CheckStatus.payed.name) {
      return lightColorPalette.greenColor.shade900;
    } else {
      return lightColorPalette.blackColor.shade900;
    }
  }

  // This function returns ui part of grand receipt.
  Widget grandTotalReceiptInfo() {
    var receiptBgColor = lightColorPalette.addNewChecksColor.topTableReceiptBgColor;
    var receiptTextColor = lightColorPalette.addNewChecksColor.topTableReceiptTextColor;

    return Obx(() => ColoredBox(
          color: receiptBgColor,
          child: SizedBox(
            width: 250,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          extractDateFromDateTimeString(date: controller.checkCreatedDate.value),
                          style: lightTextTheme.bodySmall?.copyWith(
                              color: receiptTextColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppConstants.retailPharmaciesFontFamily),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          extractTimeFromDateTimeString(date: controller.checkCreatedDate.value),
                          style: lightTextTheme.bodySmall?.copyWith(
                              color: receiptTextColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppConstants.retailPharmaciesFontFamily),
                        ),
                      ],
                    ).paddingOnly(top: 5.h, bottom: 5.h),
                  ),
                  commonCardDesign(
                      title: AppStrings.sum.tr,
                      price: "${controller.totalAmount.value}",
                      receiptTextColor: receiptTextColor),
                  commonCardDesign(
                      title: AppStrings.discount.tr,
                      price: '${controller.discount.value}',
                      receiptTextColor: receiptTextColor),
                  commonCardDesign(
                      title: AppStrings.forPayment.tr,
                      price: '${controller.totalPayableAmountWithDiscount.value}',
                      receiptTextColor: receiptTextColor),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(80, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: const Icon(Icons.print_sharp),
                      ),
                      if (controller.totalPayableAmountWithDiscount.value == 0)
                        InkWell(
                          onTap: () {
                            controller.onPressCancelReceipt();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: lightColorPalette.pitchColor.shade900,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                AssetWidget(
                                  asset: Asset(type: AssetType.png, path: ImageResource.cancelRed),
                                  height: 20.h,
                                ).paddingOnly(right: 2.w),
                                Text(
                                  AppStrings.close.tr,
                                  style: lightTextTheme.bodySmall?.copyWith(
                                      color: lightColorPalette.blackColor.shade900,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: AppConstants.retailPharmaciesFontFamily),
                                ),
                              ],
                            ).paddingOnly(left: 4.w, right: 4.w, top: 3.h, bottom: 3.h),
                          ).paddingOnly(left: 5.w),
                        ),
                    ],
                  ).paddingOnly(bottom: 20.h),
                ],
              ),
            ),
          ),
        ));
  }

  // This function returns some ui part of grand receipt.
  Widget commonCardDesign({required String title, required String price, required Color receiptTextColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: lightTextTheme.bodySmall?.copyWith(
                  color: receiptTextColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppConstants.retailPharmaciesFontFamily),
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              price,
              style: lightTextTheme.bodySmall?.copyWith(
                  color: receiptTextColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.retailPharmaciesFontFamily),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        const Divider(
          color: Colors.black26,
          thickness: 1,
          height: 0,
        ),
      ],
    );
  }

  commonTopRowText({required int flex, required String name, required int index}) {
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
        child: tableRowTextWidget(name: name,textColor: getTextColorOfRow(index: index)),
      ),
    );
  }

  commonTopRowAction({required int flex, required Function() onTapAction}) {
    return Flexible(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        child: GestureDetector(
            onTap: () {
              onTapAction();
            },
            child: const Icon(
              Icons.cancel_outlined,
            )),
      ),
    );
  }
}

class IncrementIntent extends Intent {
  const IncrementIntent();
}
