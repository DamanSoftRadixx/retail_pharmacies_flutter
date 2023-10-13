import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_loader/common_loader.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/table_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/autocomplete_textfield.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/common_textfield.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/wrap_scroll_widget/common_auto_scrool_wrap_widget.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/add_update_quantity_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/medicine_receipt_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/screens/add_new_transfer_journal_screen.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_loader.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/no_data_found_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

extension MedicineReceiptTableUiExtension on AddNewTransferJournalScreen{
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

      ],
    );
  }

  //ViewPager item ui
  Widget topTable() {
    return Obx(() => Column(children: [
      rowHeader(),
      Expanded(
        child: controller.showTopTableLoader.value
            ? commonLoader(color: lightColorPalette.addNewTransferJournalColor.topTableLoaderColor)
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
          child: commonRefreshLoader(color: lightColorPalette.addNewTransferJournalColor.topTableLoaderColor))
    ]));
  }

  //This function returns ui part of table header
  Widget rowHeader() {
    var headingBgColor = lightColorPalette.addNewTransferJournalColor.topTableHeadingBgColor;
    var headingTextColor = lightColorPalette.addNewTransferJournalColor.topTableHeadingTextColor;

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
                style: lightTextTheme.titleSmall?.copyWith(
                    color: headingTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.retailPharmaciesFontFamily),
              ),
            ),
          ),
          /* Flexible(
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
                AppStrings.action.tr,
                style: lightTextTheme.titleSmall?.copyWith(
                    color: headingTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.retailPharmaciesFontFamily
                ),
              ),
            ),
          )*/
        ],
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
      return lightColorPalette.addNewTransferJournalColor.topTableRowBgColorSelected;
    } else if (status == CheckStatus.deleted.name) {
      return lightColorPalette.addNewTransferJournalColor.topTableRowBgColorDeleted;
    } else {
      return lightColorPalette.addNewTransferJournalColor.topTableRowBgColorNormal;
    }
  }

  Color getTextColorOfRow({required int index}) {
    var selectedTopItem = controller.topTableList[index];
    var status = selectedTopItem.status ?? "";

    if (status == CheckStatus.deleted.name) {
      return lightColorPalette.addNewTransferJournalColor.topTableRowTextColorDeleted;
    } else {
      return lightColorPalette.addNewTransferJournalColor.topTableRowTextColorNormal;
    }
  }

  Widget grandTotalReceiptInfo() {
    var receiptBgColor = lightColorPalette.addNewTransferJournalColor.topTableReceiptBgColor;
    var receiptTextColor = lightColorPalette.addNewTransferJournalColor.topTableReceiptTextColor;
    var subSectionBgColor = receiptBgColor.withOpacity(0.2);
    var subDetailTextColor = receiptBgColor;

    return Obx(() => ColoredBox(
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
                      "${extractDateFromDateTimeString(date: controller.createdDateForMedicineReceipt.value)}",
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
                      "${extractTimeFromDateTimeString(date: controller.createdDateForMedicineReceipt.value)}",
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
                          value: '${controller.totalAmount.value}',
                          receiptTextColor: receiptTextColor),
                      senderSearchField(receiptTextColor: receiptTextColor),
                      SizedBox(height: 15,),
                      receiverSearchField(receiptTextColor: receiptTextColor)
                      /*medicineCardDesign(
                          title: AppStrings.receiver.tr,
                          isShowEditButton: !(controller.isEditReceiverAddress.value),
                          transferType: TransferPartyEnum.receiver,
                          value: controller.selectedReceiverData.value.value.isEmpty ? "-" : controller.selectedReceiverData.value.value,
                          receiptTextColor: receiptTextColor),
                      if(controller.isEditReceiverAddress.value) textFiledRowWidget(
                          title: AppStrings.receiver.tr,
                          controller: controller.selectedReceiverData.value.value,
                          textColor: subDetailTextColor,
                          focusNode: controller.receiverFocusNode,
                          onTapPlusIcon: (){},
                          onTapSearchIcon: (){},
                          onChanged: (){}
                      ),*/
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
    ));
  }


  senderSearchField({
    required Color receiptTextColor
}){
    return Column(
      children: [
       /* Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      AppStrings.sender.tr,
                      style: lightTextTheme.bodySmall?.copyWith(
                          color: receiptTextColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppConstants.retailPharmaciesFontFamily),
                    ),
                    GestureDetector(
                      onTap: (){
                        controller.onTapEditTransferDetailsIcon(transferParty: TransferPartyEnum.sender);
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 5),
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: lightColorPalette.whiteColor.shade900
                          ),
                          child: Icon(Icons.edit,color: lightColorPalette.addNewTransferJournalColor.topTableLoaderColor,size: 10,)),
                    ),
                  ],
                ),
                SizedBox(
                  width: 5.w,
                ),
                Flexible(
                  child: Text(
                    controller.selectedSenderData.value.value.isEmpty ? "-" : controller.selectedSenderData.value.value,
                    textAlign: TextAlign.right,
                    style: lightTextTheme.bodySmall?.copyWith(
                        color: receiptTextColor,
                        fontSize: 14.sp,
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
        ),*/
      AutoCompleteDropDownTextField(
        autoCompleteTextFieldModel: controller.senderAutoCompleteData,
        textFieldHint: AppStrings.sender.tr,
        textFieldLabel: AppStrings.sender.tr,
        onTap: (){
          print("onTap");
          controller.onChangedSenderTextField(value: controller.senderAutoCompleteData.value.textField.text);
        },
        onTapCloseIcon: () async {
          return await controller.onPressSenderTextFieldCloseButton();
        },
        onTapTrailingIcon: (){
          controller.onTapPlusIcon(transferType: TransferPartyEnum.sender);
        },
        onDoubleTapListItem: (index){
          controller.onDoubleTapSenderListItem(index: index);
        },
        onTapListItem: (index){
          controller.onTapSenderListItem(index: index);
        },
        onChanged: (value){
          print("onChanged");

          return controller.onChangedSenderTextField(value: value);
        },
      )
      /*  medicineCardDesign(
            title: AppStrings.sender.tr,
            isShowEditButton: !(controller.isEditSenderAddress.value),
            transferType: TransferPartyEnum.sender,
            value: controller.senderController.value.text.isEmpty ? "-" : controller.senderController.value.text,
            receiptTextColor: receiptTextColor),
        if(controller.isEditSenderAddress.value) textFiledRowWidget(
            title: AppStrings.sender.tr,
            controller: controller.senderController.value,
            focusNode: controller.senderFocusNode,
            textColor: subDetailTextColor,
            onTapPlusIcon: (){
              controller.onTapPlusIcon(transferType : TransferPartyEnum.sender);
            },
            onTapSearchIcon: (){},
            onChanged: (){}
        ),*/
      ],
    );

  }

  receiverSearchField({
    required Color receiptTextColor
  }){
    return Column(
      children: [
       /* Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15.h,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      AppStrings.receiver.tr,
                      style: lightTextTheme.bodySmall?.copyWith(
                          color: receiptTextColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppConstants.retailPharmaciesFontFamily),
                    ),
                    GestureDetector(
                      onTap: (){
                        controller.onTapEditTransferDetailsIcon(transferParty: TransferPartyEnum.receiver);
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 5),
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: lightColorPalette.whiteColor.shade900
                          ),
                          child: Icon(Icons.edit,color: lightColorPalette.addNewTransferJournalColor.topTableLoaderColor,size: 10,)),
                    ),
                  ],
                ),
                SizedBox(
                  width: 5.w,
                ),
                Flexible(
                  child: Text(
                    controller.selectedReceiverData.value.value.isEmpty ? "-" : controller.selectedReceiverData.value.value,
                    textAlign: TextAlign.right,
                    style: lightTextTheme.bodySmall?.copyWith(
                        color: receiptTextColor,
                        fontSize: 14.sp,
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
        ),*/
        AutoCompleteDropDownTextField(
          autoCompleteTextFieldModel: controller.receiverAutoCompleteData,
          textFieldHint: AppStrings.receiver.tr,
          textFieldLabel: AppStrings.receiver.tr,
        onTap: (){
         return controller.onChangedReceiverTextField(value: controller.receiverAutoCompleteData.value.textField.text);
        },
        onTapTrailingIcon: (){
            controller.onTapPlusIcon(transferType: TransferPartyEnum.receiver);
          },
          onTapCloseIcon: () async{
            return await controller.onPressReceiverTextFieldCloseButton();
          },
          onDoubleTapListItem: (index){
            controller.onDoubleTapReceiverListItem(index: index);
          },
          onTapListItem: (index){
            controller.onTapReceiverListItem(index: index);
          },
          onChanged: (value){
            return controller.onChangedReceiverTextField(value: value);
          },
        )
        /*  medicineCardDesign(
            title: AppStrings.sender.tr,
            isShowEditButton: !(controller.isEditSenderAddress.value),
            transferType: TransferPartyEnum.sender,
            value: controller.senderController.value.text.isEmpty ? "-" : controller.senderController.value.text,
            receiptTextColor: receiptTextColor),
        if(controller.isEditSenderAddress.value) textFiledRowWidget(
            title: AppStrings.sender.tr,
            controller: controller.senderController.value,
            focusNode: controller.senderFocusNode,
            textColor: subDetailTextColor,
            onTapPlusIcon: (){
              controller.onTapPlusIcon(transferType : TransferPartyEnum.sender);
            },
            onTapSearchIcon: (){},
            onChanged: (){}
        ),*/
      ],
    );

  }



  textFiledRowWidget(
      {required String title,
        required TextEditingController controller,
        required FocusNode focusNode,
        Color? textColor,
        required Function() onTapPlusIcon,
        required Function() onTapSearchIcon,
        required Function() onChanged,}) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: commonSearchAutoCompleteTextFieldWidget(
              controller: controller,
              textColor: textColor,
              onTapPlusIcon: (){
                onTapPlusIcon();
              },
              onTapSeachIcon: (){
                onTapSearchIcon();
              },
              keyboardType: TextInputType.name,
              focusNode: focusNode,
              onChanged: (value) {
                onChanged();
              },

            )),
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


  // This function returns some ui part of grand receipt.
  Widget medicineCardDesign({required String title,
    required String value,
    TransferPartyEnum? transferType,
    required Color receiptTextColor,bool isShowEditButton = false}) {
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
            Row(
              children: [
                Text(
                  title,
                  style: lightTextTheme.bodySmall?.copyWith(
                      color: receiptTextColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppConstants.retailPharmaciesFontFamily),
                ),
              ],
            ),
            SizedBox(
              width: 5.w,
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: lightTextTheme.bodySmall?.copyWith(
                    color: receiptTextColor,
                    fontSize: 14.sp,
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


}