import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/common_textfield.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/routes/routes.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/add_new_Transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/screens/add_new_transfer_journal_screen.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_loader.dart';
import 'package:flutter_retail_pharmacies/features/organisation/controller/create_organisation_controller.dart';
import 'package:get/get.dart';


class CreateOrganizationDialog{
  var controller = Get.find<CreateOrganisationController>();

  createOrganizationDialog() {
    controller.clearAllFields();
    return Get.dialog(
        AlertDialog(
          content: Obx(() => Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: [
              Container(
                width: 500,
                decoration: BoxDecoration(
                    color: lightColorPalette.whiteColor.shade700.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    heading(),
                    Container(
                      height: 0.4,
                      decoration: BoxDecoration(
                        color: lightColorPalette.blackColor.shade700,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            textFiledRowWidget(
                              title: AppStrings.name.tr,
                              controller: controller.organisationNameTextField.value,
                              focusNode:
                              controller.organisationNameFocusNode.value,
                              onChanged: () {
                                controller.onPressNameTextFieldChangedButton();
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            textFiledRowWidget(
                              title: AppStrings.address.tr,
                              controller: controller.organisationAddressTextField.value,
                              focusNode: controller.organisationAddressFocusNode.value,
                              onChanged: () {
                                controller.onPressAddressTextFieldChangedButton();
                              },
                            ),

                            controller.errorString.value.isNotEmpty
                                ? errorText(error: controller.errorString.value.toString())
                                : SizedBox(
                              height: 40,
                            ),
                            doneButton(onPressDone: () {
                              controller.onPressAddOrganisationDoneButton();
                            })
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if(controller.isShowLoader.isTrue) Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  commonLoader(),
                ],
              )
            ],
          )),
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          backgroundColor: lightColorPalette.whiteColor.shade900,
        ),
        barrierDismissible: false);
  }

  errorText({required String error}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Text(
        "${error}",
        style: TextStyle(
            color: lightColorPalette.redColor.shade900,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            fontFamily: AppConstants.retailPharmaciesFontFamily),
        textAlign: TextAlign.center,
      ),
    );
  }

  doneButton({required Function() onPressDone}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            onPressDone();
          },
          child: Container(
            alignment: Alignment.center,
            width: 150,
            height: 45,
            decoration: BoxDecoration(
                color: lightColorPalette.themeColor.shade900,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              AppStrings.doneButton.tr,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: lightColorPalette.whiteColor.shade900,
                  letterSpacing: -0.12,
                  fontFamily: AppConstants.retailPharmaciesFontFamily),
            ),
          ),
        ),
      ],
    );
  }

  heading() {
    var controller = Get.find<AddNewTransferJournalController>();

    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                AppStrings.createCounterParty.tr,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: lightColorPalette.blackColor.shade900,
                    letterSpacing: -0.12,
                    fontFamily: AppConstants.retailPharmaciesFontFamily),
                textAlign: TextAlign.center,
                // TextStyle(fontSize: 16.sp),
              ),

            ],
          ),
          GestureDetector(
              onTap: () {
                controller.isOpenOrganisationDetailsDialog.value = false;
                controller.errorString.value = "";
                Get.back();
              },
              child: Icon(Icons.close))
        ],
      ),
    );
  }

  textFiledRowWidget(
      {required String title,
        required TextEditingController controller,
        required FocusNode focusNode,
        required Function() onChanged,}) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: commonTextFieldWidget(
              controller: controller,
              title: title,
              keyboardType: TextInputType.name,
              focusNode: focusNode,
              onChanged: (value) {
                onChanged();
              },

            )),
      ],
    );
  }

}