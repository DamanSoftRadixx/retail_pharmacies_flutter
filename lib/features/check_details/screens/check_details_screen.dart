import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/date_picker/date_picker_util.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/table_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/common_textfield.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/wrap_scroll_widget/common_auto_scrool_wrap_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_asset/common_image.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_loader/common_loader.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/constants/image_resources.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/time_table_response_model.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/check_details/controller/check_details_controller.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_loader.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/no_data_found_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheckDetailsScreen extends StatelessWidget {
  var controller = Get.put(CheckDetailsController());

  CheckDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Flexible(
          flex: 4,
          child: checkPaymentPanelWidget(),
        ),
        Flexible(
          flex: 5,
          child: medicinePanelWidget(),
        ),
      ],
    ));
  }

  checkPaymentPanelWidget() {
    return Row(
      children: [
        dateFilterSummaryReceiptWidget(),
        Expanded(
          child: Column(
                children: [
                  // row header is used for title of all the entry which we are showing in the list
                  checkPaymentPaneHeader(),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Builder(builder: (context) {
                          return controller.topTableTableList.isEmpty && controller.showTopTableLoaderCheck.isFalse
                              ? noDataFound()
                              : ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  controller: controller.topCheckListScrollController,
                                  itemCount: controller.topTableTableList.length,
                                  itemBuilder: (context, index) {
                                    // it is used for relaod a more data in a list
                                    //bottom row grid is used for show items of list

                                    return topCheckGridRow(index: index);
                                  },
                                );
                        }),
                        Visibility(visible: controller.showTopTableLoaderCheck.value == true, child: commonLoader(color: lightColorPalette.blueColor.shade800))
                      ],
                    ),
                  ),
                  Visibility(
                      visible: controller.loadMoreTop.value == true,
                      child: commonRefreshLoader(color: lightColorPalette.checkJournalColor.topTableLoaderColor))
                ],
              ),
        ),
      ],
    );
  }

  //This function returns ui part of table header
  Widget checkPaymentPaneHeader() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          //Date time
          Flexible(
            flex: 10,
            child: topTableHeadingTextWidget(text: AppStrings.dateTime.tr),
          ),
          //Status
          Flexible(
            flex: 3,
            child: topTableHeadingTextWidget(text: AppStrings.status.tr),
          ),

          //cash
          Flexible(
            flex: 5,
            child: topTableHeadingTextWidget(text: AppStrings.cash.tr),
          ),

          //humo
          Flexible(
            flex: 5,
            child: topTableHeadingTextWidget(text: AppStrings.humo.tr),
          ),
          //uzcard
          Flexible(
            flex: 5,
            child: topTableHeadingTextWidget(text: AppStrings.uzCard.tr),
          ),

          //other
          Flexible(
            flex: 5,
            child: topTableHeadingTextWidget(text: AppStrings.other.tr),
          ),
        ],
      ),
    );
  }

  topTableHeadingTextWidget({required String text}) {
    var backgroundColor = lightColorPalette.checkJournalColor.topTableHeadingBgColor;
    var foregroundColor = lightColorPalette.checkJournalColor.topTableHeadingTextColor;


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
              color: foregroundColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              fontFamily: AppConstants.retailPharmaciesFontFamily),
        ));
  }

  //This function returns ui part of table rows
  Widget topCheckGridRow({required int index}) {
    // print("index : ${index}, focus : ${controller.searchList.value[index].focusNode.hasFocus}, name : ${controller.searchList.value[index].name}");

    var selectionColor = lightColorPalette.blueColor.shade800;


    return wrapScrollTag(
        autoScrollController: controller.topCheckListScrollController,
        index: index,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            controller.onTapTopTableItem(index: index, docId: controller.topTableTableList[index].uuid ?? "");
          },
          onDoubleTap: () {
            // controller.onDoubleTapBottomTableItem(index: index);
          },
          child:  ColoredBox(
                color: controller.selectedIndexTop.value == index
                    ? lightColorPalette.checkJournalColor.topTableRowBgColorSelected
                    : Colors.transparent,
                child: SizedBox(
                  height: 40.h,
                  child: Row(
                    children: [
                      checkPaymentTableRowText(
                          flex: 10,
                          name: getFormattedStringDate(date: controller.topTableTableList[index].createdAt ?? "")),
                      checkPaymentTableRowText(
                          flex: 3,
                          name: (controller.topTableTableList[index].status ?? "").capitalizeFirst ?? "",
                          textColor: getTextColorFoStatus(
                            paymentStatus: controller.topTableTableList[index].status ?? "",
                          )),
                      checkPaymentTableRowText(flex: 5, name: controller.topTableTableList[index].cash ?? ""),
                      checkPaymentTableRowText(flex: 5, name: controller.topTableTableList[index].humo ?? ""),
                      checkPaymentTableRowText(flex: 5, name: controller.topTableTableList[index].uzcard ?? ""),
                      checkPaymentTableRowText(flex: 5, name: controller.topTableTableList[index].other ?? ""),
                    ],
                  ),
                ),
              ),
        ));
  }

  getTextColorFoStatus({required String paymentStatus}) {
    if (paymentStatus == CheckStatus.payed.name) {
      return lightColorPalette.greenColor.shade900;
    } else if (paymentStatus == CheckStatus.closed.name) {
      return lightColorPalette.redColor.shade900;
    } else {
      return lightColorPalette.blueColor.shade900;
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
        child: tableRowTextWidget(name: name,textColor: textColor ?? lightColorPalette.checkJournalColor.topTableRowTextColorNormal),
      ),
    );
  }

  //Top panel widget carry all the ui part of top view
  Widget medicinePanelWidget() {
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
                            child: medicalTable(),
                          ),
                          if(controller.topTableTableList.length > 0) grandTotalReceiptInfo(
                              timeTableData: controller.topTableTableList[controller.selectedIndexTop.value]),
                        ],
                      ),
                    ),
                  )

          ],
        );
  }

  //ViewPager item ui
  Widget medicalTable() {
    return Column(children: [
      medicineTableHeader(),
      Expanded(
        child: controller.showBottomTableLoader.value
            ? commonLoader(color: lightColorPalette.checkJournalColor.bottomTableLoaderColor)
            : (controller.bottomTableList.isEmpty
                ? noDataFound()
                : ListView.builder(
                    shrinkWrap: true,
                    controller: controller.bottomListScrollController,
                    physics: const BouncingScrollPhysics(),
                    addAutomaticKeepAlives: true,
                    scrollDirection: Axis.vertical,
                    itemCount: controller.bottomTableList.length,
                    itemBuilder: (context, index) {
                      print("controller.dataList.length  :${controller.bottomTableList.length}");

                      return wrapScrollTag(
                          index: index,
                          child: filledItemListingRow(
                            index: index,
                          ),
                          autoScrollController: controller.bottomListScrollController);
                    },
                  )),
      ),
      Visibility(
          visible: controller.loadMoreBottom.value == true,
          child: commonRefreshLoader(color: lightColorPalette.checkJournalColor.bottomTableLoaderColor))
    ]);
  }

  //This function returns ui part of table header
  Widget medicineTableHeader() {
    var headingBgColor = lightColorPalette.checkJournalColor.bottomTableHeadingBgColor;
    var headingTextColor = lightColorPalette.checkJournalColor.bottomTableHeadingTextColor;

    return SizedBox(
      height: 50.h,
      child: Row(
        children: [
          Flexible(
            flex: 18,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: headingBgColor,
                border: Border.all(
                  color: lightColorPalette.blackColor.shade900,
                  width: 0.5,
                ),
              ),
              child: Text(
                AppStrings.fullnaming.tr,
                textAlign: TextAlign.center,
                style: lightTextTheme.titleSmall?.copyWith(
                    color: headingTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.retailPharmaciesFontFamily),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: headingBgColor,
                border: Border.all(
                  color: lightColorPalette.blackColor.shade900,
                  width: 0.5,
                ),
              ),
              child: Text(
                AppStrings.qty.tr,
                textAlign: TextAlign.center,
                style: lightTextTheme.titleSmall?.copyWith(
                    color: headingTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.retailPharmaciesFontFamily),
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: headingBgColor,
                border: Border.all(
                  color: lightColorPalette.blackColor.shade900,
                  width: 0.5,
                ),
              ),
              child: Text(
                AppStrings.price.tr,
                textAlign: TextAlign.center,
                style: lightTextTheme.titleSmall?.copyWith(
                    color: headingTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.retailPharmaciesFontFamily),
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: headingBgColor,
                border: Border.all(
                  color: lightColorPalette.blackColor.shade900,
                  width: 0.5,
                ),
              ),
              child: Text(
                AppStrings.sum.tr,
                textAlign: TextAlign.center,
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
                  color: lightColorPalette.blackColor.shade900,
                  width: 0.5,
                ),
              ),
              child: Text(
                AppStrings.termYear.tr,
                textAlign: TextAlign.center,
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
                  color: lightColorPalette.blackColor.shade900,
                  width: 0.5,
                ),
              ),
              child: Text(
                AppStrings.series.tr,
                textAlign: TextAlign.center,
                style: lightTextTheme.titleSmall?.copyWith(
                    color: headingTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.retailPharmaciesFontFamily),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: headingBgColor,
                border: Border.all(
                  color: lightColorPalette.blackColor.shade900,
                  width: 0.5,
                ),
              ),
              child: Text(
                AppStrings.mx.tr,
                textAlign: TextAlign.center,
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
                  color: lightColorPalette.blackColor.shade900,
                  width: 0.5,
                ),
              ),
              child: Text(
                AppStrings.ikpu.tr,
                textAlign: TextAlign.center,
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
                  color: lightColorPalette.blackColor.shade900,
                  width: 0.5,
                ),
              ),
              child: Text(
                AppStrings.mark.tr,
                textAlign: TextAlign.center,
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

  // This function returns ui part of grand receipt.
  Widget grandTotalReceiptInfo({required TimeTableData timeTableData}) {
    var receiptBgColor = lightColorPalette.checkJournalColor.bottomTableReceiptBgColor;
    var receiptTextColor = lightColorPalette.checkJournalColor.bottomTableReceiptTextColor;
    var paymentSectionBgColor = receiptBgColor.withOpacity(0.2);
    var paymentDetailTextColor = receiptBgColor;

    return ColoredBox(
      color: receiptBgColor,
      child: SizedBox(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "${extractDateFromDateTimeString(date: timeTableData.createdAt ?? "")}",
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
                      "${extractTimeFromDateTimeString(date: timeTableData.createdAt ?? "")}",
                      style: lightTextTheme.bodySmall?.copyWith(
                          color: receiptTextColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppConstants.retailPharmaciesFontFamily),
                    ),
                  ],
                ).paddingOnly(top: 5.h, bottom: 5.h),
              ),
              Expanded(
                  child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  medicineCardDesign(
                      title: AppStrings.forPayment.tr,
                      price: '${controller.totalPayableAmountWithDiscount.value}',
                      receiptTextColor: receiptTextColor),
                  if (timeTableData.status != null && timeTableData.status == CheckStatus.payed.name)
                    Container(
                      decoration: BoxDecoration(
                          color: lightColorPalette.whiteColor.shade900, borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: paymentSectionBgColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            if (timeTableData.cash != null && timeTableData.cash != "")
                              medicineCardDesign(
                                  title: AppStrings.cash.tr,
                                  price: '${timeTableData.cash}',
                                  receiptTextColor: paymentDetailTextColor),
                            if (timeTableData.humo != null && timeTableData.humo != "")
                              medicineCardDesign(
                                  title: AppStrings.humo.tr,
                                  price: '${timeTableData.humo}',
                                  receiptTextColor: paymentDetailTextColor),
                            if (timeTableData.uzcard != null && timeTableData.uzcard != "")
                              medicineCardDesign(
                                  title: AppStrings.uzCard.tr,
                                  price: '${timeTableData.uzcard}',
                                  receiptTextColor: paymentDetailTextColor),
                            if (timeTableData.other != null && timeTableData.other != "")
                              medicineCardDesign(
                                  title: AppStrings.other.tr,
                                  price: '${timeTableData.other}',
                                  receiptTextColor: paymentDetailTextColor),
                          ],
                        ),
                      ),
                    )
                ],
              )),
              SizedBox(
                height: 10.h,
              ),
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
                ],
              ).paddingOnly(bottom: 20.h),
            ],
          ),
        ),
      ),
    );
  }


  // This function returns ui part of grand receipt.
  Widget dateFilterSummaryReceiptWidget() {
    var receiptBgColor = lightColorPalette.checkJournalColor.topTableReceiptBgColor;
    var paymentSectionBgColor = receiptBgColor.withOpacity(0.2);
    var paymentDetailTextColor = receiptBgColor;

    var summaryDataModel = controller.checkSummaryForSelectedDateModel.value;

    return ColoredBox(
      color: receiptBgColor,
      child: SizedBox(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    dateFilterWidget(),

                  ],
                ).paddingOnly(top: 5.h, bottom: 5.h),
              ),

              SizedBox(
                height: 10.h,
              ),

              Container(
                decoration: BoxDecoration(
                    color: lightColorPalette.whiteColor.shade900, borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: paymentSectionBgColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      if (summaryDataModel.totalCash != null && summaryDataModel.totalCash != 0.0)
                        medicineCardDesign(
                            title: AppStrings.cash.tr,
                            price: '${summaryDataModel.totalCash}',
                            receiptTextColor: paymentDetailTextColor),
                      if (summaryDataModel.totalCash != null && summaryDataModel.totalCash != 0.0)
                        medicineCardDesign(
                            title: AppStrings.humo.tr,
                            price: '${summaryDataModel.totalHumo}',
                            receiptTextColor: paymentDetailTextColor),
                      if (summaryDataModel.totalHumo != null && summaryDataModel.totalHumo != 0.0)
                        medicineCardDesign(
                            title: AppStrings.uzCard.tr,
                            price: '${summaryDataModel.totalUzcard}',
                            receiptTextColor: paymentDetailTextColor),
                      if (summaryDataModel.totalUzcard != null && summaryDataModel.totalUzcard != 0.0)
                        medicineCardDesign(
                            title: AppStrings.other.tr,
                            price: '${summaryDataModel.totalOther}',
                            receiptTextColor: paymentDetailTextColor),
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }


  Widget dateFilterWidget(){
    return Container(
      width: 1.sw,
      height: 44.h,
      padding: EdgeInsets.only(top: 0.h),
      decoration: decoration(isSelected: false),
      child: Center(
        child: Row(
          children: [
            SizedBox(width: 10,),
            GestureDetector(
              onTap: (){
                controller.onPressBackDateButton();
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: lightColorPalette.iconColor,
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  showDatePickerDialog(onPicked: (DateTime selectedDate){
                    controller.onSelectedDate(selectedDate : selectedDate);
                  });
                },
                child: Text(
                 extractDateFromDateTimeString(date: controller.selectedDate.value.toString()),
                  textAlign: TextAlign.center,
                  style: CustomTextTheme.normalText1(color: lightColorPalette.blackColor.shade900),
                ),
              ),
            ),
            SizedBox(width: 10,),
            GestureDetector(
              onTap: (){
                controller.onPressNextDateButton();
              },
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: lightColorPalette.iconColor,
              ),
            ),
            SizedBox(width: 10,),
          ],
        ),
      ),
    );
  }

  //This function returns ui part of table rows
  Widget filledItemListingRow({required int index}) {
    var selectedTopItem = controller.bottomTableList[index];
    var status = selectedTopItem.status ?? "";
    print("status : $status");

    return GestureDetector(
      onTap: () {
        controller.onTapBottomTableItem(index: index);
      },
      child: ColoredBox(
        color: getTheBackgroundColorOfRow(index: index),
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              commonMedicineRowText(
                  flex: 18, name: controller.bottomTableList.value[index].goods?.name ?? "", index: index),
              commonMedicineRowText(
                  flex: 4,
                  name: controller.getQuantity(qtyList: controller.bottomTableList.value[index].qty ?? []),
                  index: index),
              commonMedicineRowText(
                  flex: 6, name: (controller.bottomTableList.value[index].price?.number).toString(), index: index),
              commonMedicineRowText(
                  flex: 6, name: (controller.bottomTableList.value[index].cost?.number).toString(), index: index),
              commonMedicineRowText(flex: 5, name: '', index: index),
              commonMedicineRowText(flex: 5, name: '', index: index),
              commonMedicineRowText(flex: 2, name: '', index: index),
              commonMedicineRowText(flex: 5, name: '', index: index),
              commonMedicineRowText(flex: 5, name: '', index: index),
              /* commonTopRowAction(flex: 5,onTapAction: (){
                controller.deleteTopTableSelectedItem(index: index);
              })*/
            ],
          ),
        ),
      ),
    );
  }

  commonMedicineRowText({required int flex, required String name, required int index}) {

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

  // This function returns some ui part of grand receipt.
  Widget medicineCardDesign({required String title, required String price, required Color receiptTextColor}) {
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

  Color getTheBackgroundColorOfRow({required int index}) {
    var selectedTopItem = controller.bottomTableList[index];
    var status = selectedTopItem.status ?? "";
    var selectionColor = lightColorPalette.checkJournalColor.bottomTableRowBgColorSelected;


    if (controller.selectedIndexBottom.value == index) {
      return selectionColor.withOpacity(0.2);
    } else if (status == CheckStatus.deleted.name) {
      return lightColorPalette.checkJournalColor.bottomTableRowBgColorDeleted;
    } else {
      return lightColorPalette.checkJournalColor.bottomTableRowBgColorNormal;
    }
  }

  Color getTextColorOfRow({required int index}) {
    var selectedTopItem = controller.bottomTableList[index];
    var status = selectedTopItem.status ?? "";

    if (status == CheckStatus.deleted.name) {
      return lightColorPalette.checkJournalColor.bottomTableRowTextColorDeleted;
    } else {
      return lightColorPalette.checkJournalColor.bottomTableRowTextColorNormal;
    }
  }
}
