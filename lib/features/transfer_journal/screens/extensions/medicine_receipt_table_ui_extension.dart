import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_loader/common_loader.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/date_picker/date_picker_util.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/table_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/wrap_scroll_widget/common_auto_scrool_wrap_widget.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_loader.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/no_data_found_widget.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/transfer_details_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/transfer_list_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/screens/transfer_journal_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

extension MedicineReceiptTableUiExtension on TransferJournalScreen{

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
                if(controller.topTableTableList.length > 0) grandTotalReceiptInfo(),
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
            ? commonLoader(color: lightColorPalette.transferJournalColor.bottomTableLoaderColor)
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
          child: commonRefreshLoader(color: lightColorPalette.themeColor.shade900))
    ]);
  }

  //This function returns ui part of table header
  Widget medicineTableHeader() {
    return SizedBox(
      height: 50.h,
      child: Row(
        children: [
          Flexible(
            flex: 18,
            child: medicineTableHeaderItem(title: AppStrings.fullnaming.tr),
          ),
          Flexible(
            flex: 4,
            child: medicineTableHeaderItem(title: AppStrings.qty.tr),
          ),
          Flexible(
            flex: 6,
            child: medicineTableHeaderItem(title: AppStrings.price.tr),
          ),
          Flexible(
            flex: 6,
            child: medicineTableHeaderItem(title: AppStrings.sum.tr),
          ),
          Flexible(
            flex: 5,
            child: medicineTableHeaderItem(title: AppStrings.termYear.tr),
          ),
          Flexible(
            flex: 5,
            child: medicineTableHeaderItem(title: AppStrings.series.tr),
          ),
          Flexible(
            flex: 2,
            child: medicineTableHeaderItem(title: AppStrings.mx.tr),
          ),
          Flexible(
            flex: 5,
            child: medicineTableHeaderItem(title: AppStrings.ikpu.tr),
          ),
          Flexible(
            flex: 5,
            child: medicineTableHeaderItem(title: AppStrings.mark.tr),
          ),
        ],
      ),
    );
  }


  Widget medicineTableHeaderItem({required String title}){
    var backgroundColor = lightColorPalette.transferJournalColor.bottomTableHeadingBgColor;
    var foregroundColor = lightColorPalette.transferJournalColor.bottomTableHeadingTextColor;

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
        textAlign: TextAlign.center,
        style: lightTextTheme.titleSmall?.copyWith(
            color: foregroundColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.retailPharmaciesFontFamily),
      ),
    );
  }

  // This function returns ui part of grand receipt.
  Widget grandTotalReceiptInfo() {
    var receiptBgColor = lightColorPalette.transferJournalColor.bottomTableReceiptBgColor;
    var receiptTextColor = lightColorPalette.transferJournalColor.bottomTableReceiptTextColor;
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
                      "${extractDateFromDateTimeString(date:controller.transferCreatedDate.value)}",
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
                      "${extractTimeFromDateTimeString(date: controller.transferCreatedDate.value)}",
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
                          title: AppStrings.amount.tr,
                          price: '${controller.totalAmount.value}',
                          receiptTextColor: receiptTextColor),
                      medicineCardDesign(
                          title: AppStrings.sender.tr,
                          price: '${controller.transferSender.value.isEmpty ? "-" : controller.transferSender.value}',
                          receiptTextColor: receiptTextColor),
                      medicineCardDesign(
                          title: AppStrings.receiver.tr,
                          price: '${controller.transferReceiver.value.isEmpty ? "-" : controller.transferReceiver.value}',
                          receiptTextColor: receiptTextColor),
                      /* if (timeTableData.status != null && timeTableData.status == CheckStatus.payed.name)
                        Container(
                          decoration: BoxDecoration(
                              color: lightColorPalette.whiteColor.shade900, borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: lightColorPalette.themeColor.shade900.withOpacity(0.2),
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
                        )*/
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
                  flex: 6, name: (controller.bottomTableList.value[index].price?.number ?? "").toString(), index: index),
              commonMedicineRowText(
                  flex: 6, name: (controller.bottomTableList.value[index].cost?.number ?? "").toString(), index: index),
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
            Flexible(
              child: Text(
                price,
                textAlign: TextAlign.end,
                style: lightTextTheme.bodySmall?.copyWith(
                    color: receiptTextColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.retailPharmaciesFontFamily),
              ),
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


    if (controller.selectedIndexBottom.value == index) {
      return lightColorPalette.transferJournalColor.bottomTableRowBgColorSelected;
    } else if (status == CheckStatus.deleted.name) {
      return lightColorPalette.transferJournalColor.bottomTableRowBgColorDeleted;
    } else {
      return lightColorPalette.transferJournalColor.bottomTableRowBgColorNormal;
    }
  }

  Color getTextColorOfRow({required int index}) {
    var selectedTopItem = controller.bottomTableList[index];
    var status = selectedTopItem.status ?? "";

    if (status == CheckStatus.deleted.name) {
      return lightColorPalette.transferJournalColor.bottomTableRowTextColorDeleted;
    } else {
      return lightColorPalette.transferJournalColor.bottomTableRowTextColorNormal;
    }
  }

}