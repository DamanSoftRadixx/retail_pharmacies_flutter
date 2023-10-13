import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_loader/common_loader.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/table_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/wrap_scroll_widget/common_auto_scrool_wrap_widget.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_loader.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/no_data_found_widget.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/transfer_list_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/screens/transfer_journal_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

extension TransferListTableUiExtension on TransferJournalScreen{
  checkPaymentPanelWidget() {
    return Row(
      children: [
        // dateFilterSummaryReceiptWidget(),
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
                    Visibility(visible: controller.showTopTableLoaderCheck.value == true, child: commonLoader(color: lightColorPalette.transferJournalColor.topTableLoaderColor))
                  ],
                ),
              ),
              Visibility(
                  visible: controller.loadMoreTop.value == true,
                  child: commonRefreshLoader(color: lightColorPalette.greenColor.shade900))
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

          //Income/Outcome
          Flexible(
            flex: 5,
            child: topTableHeadingTextWidget(text: AppStrings.sender.tr),
          ),

          //Counter Party
          Flexible(
            flex: 5,
            child: topTableHeadingTextWidget(text: AppStrings.receiver.tr),
          ),

          //Amount
          Flexible(
            flex: 5,
            child: topTableHeadingTextWidget(text: AppStrings.amount.tr),
          ),

        ],
      ),
    );
  }

  topTableHeadingTextWidget({required String text}) {
    var backgroundColor = lightColorPalette.transferJournalColor.topTableHeadingBgColor;
    var textColor = lightColorPalette.transferJournalColor.topTableHeadingTextColor;


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

  //This function returns ui part of table rows
  Widget topCheckGridRow({required int index}) {
    // print("index : ${index}, focus : ${controller.searchList.value[index].focusNode.hasFocus}, name : ${controller.searchList.value[index].name}");

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
            controller.onDoubleTapTopTableItem(index: index,docId: controller.topTableTableList[index].uuid ?? "");
          },
          child:  ColoredBox(
            color: controller.selectedIndexTop.value == index
                ? lightColorPalette.transferJournalColor.topTableRowBgColorSelected
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
                  checkPaymentTableRowText(flex: 5, name: controller.topTableTableList[index].sender?.organisationAddress ?? ""),
                  checkPaymentTableRowText(flex: 5, name: controller.topTableTableList[index].receiver?.organisationAddress ?? ""),
                  checkPaymentTableRowText(flex: 5, name: controller.topTableTableList[index].amount ?? ""),
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
        child: tableRowTextWidget(name: name,textColor: textColor),
      ),
    );
  }


}