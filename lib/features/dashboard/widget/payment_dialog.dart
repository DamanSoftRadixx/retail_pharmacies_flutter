import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/common_textfield.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/dashboard_contoller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

paymentDialog({
  required Function() onPressDone,
  required Function() onChangedTextField,
  required Function(PaymentMethod method) onPressRefreshIcon,
}) {
  var controller = Get.find<DashboardController>();

  return Get.dialog(
      AlertDialog(
        content: Container(
          width: 500,
          decoration: BoxDecoration(
              color: lightColorPalette.whiteColor.shade700.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              paymentHeaderDialog(
                  totalPayableAmount:
                      controller.paymentDialogModel.value.totalPaybleAmount),
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
                      paymentRowWidget(
                          title: AppStrings.cash.tr,
                          controller: controller.paymentDialogModel.value
                              .cashTextEditingController,
                          focusNode:
                              controller.paymentDialogModel.value.cashFocusNode,
                          // isSelected: controller.paymentDialogModel.value.paymentMethod == PaymentMethod.cash,
                          onChanged: () {
                            if (controller
                                    .paymentDialogModel.value.paymentMethod !=
                                PaymentMethod.cash) onChangedTextField();
                          },
                          onPressRefreshIcon: () {
                            onPressRefreshIcon(PaymentMethod.cash);
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      paymentRowWidget(
                          title: AppStrings.humo.tr,
                          controller: controller.paymentDialogModel.value
                              .humoTextEditingController,
                          focusNode:
                              controller.paymentDialogModel.value.humoFocusNode,
                          // isSelected: controller.paymentDialogModel.value.paymentMethod == PaymentMethod.humo,
                          onChanged: () {
                            if (controller
                                    .paymentDialogModel.value.paymentMethod !=
                                PaymentMethod.humo) onChangedTextField();
                          },
                          onPressRefreshIcon: () {
                            onPressRefreshIcon(PaymentMethod.humo);
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      paymentRowWidget(
                          title: AppStrings.uzCard.tr,
                          controller: controller.paymentDialogModel.value
                              .uzCardTextEditingController,
                          focusNode: controller
                              .paymentDialogModel.value.uzCardFocusNode,
                          // isSelected: controller.paymentDialogModel.value.paymentMethod == PaymentMethod.uzCard,
                          onChanged: () {
                            if (controller
                                    .paymentDialogModel.value.paymentMethod !=
                                PaymentMethod.uzCard) onChangedTextField();
                          },
                          onPressRefreshIcon: () {
                            onPressRefreshIcon(PaymentMethod.uzCard);
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      paymentRowWidget(
                          title: AppStrings.other.tr,
                          controller: controller.paymentDialogModel.value
                              .otherTextEditingController,
                          focusNode: controller
                              .paymentDialogModel.value.otherFocusNode,
                          // isSelected: controller.paymentDialogModel.value.paymentMethod == PaymentMethod.other,
                          onChanged: () {
                            if (controller
                                    .paymentDialogModel.value.paymentMethod !=
                                PaymentMethod.other) onChangedTextField();
                          },
                          onPressRefreshIcon: () {
                            onPressRefreshIcon(PaymentMethod.other);
                          }),
                      Obx(() =>
                          controller.paymentDialogModel.value.isValidData ==
                                  false
                              ? errorText(
                                  totalPayableAmount: controller
                                      .paymentDialogModel
                                      .value
                                      .totalPaybleAmount)
                              : SizedBox(
                                  height: 40,
                                )),
                      paymentDialogOkayButton(onPressDone: () {
                        onPressDone();
                      })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        contentPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        backgroundColor: lightColorPalette.whiteColor.shade900,
      ),
      barrierDismissible: false);
}

errorText({required String totalPayableAmount}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: Text(
      "${AppStrings.totalAmountCantBeGreaterThan.tr} ${totalPayableAmount}.",
      style: TextStyle(
          color: lightColorPalette.redColor.shade900,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          fontFamily: AppConstants.retailPharmaciesFontFamily),
      textAlign: TextAlign.center,
    ),
  );
}

paymentDialogOkayButton({required Function() onPressDone}) {
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
                fontSize: 15.sp,
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

paymentHeaderDialog({required String totalPayableAmount}) {
  var controller = Get.find<DashboardController>();

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
              AppStrings.payment.tr,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: lightColorPalette.blackColor.shade900,
                  letterSpacing: -0.12,
                  fontFamily: AppConstants.retailPharmaciesFontFamily),
              textAlign: TextAlign.center,
              // TextStyle(fontSize: 16.sp),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "${AppStrings.totalPayableAmountIs.tr} ${totalPayableAmount}.",
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: lightColorPalette.blackColor.shade700.withOpacity(0.6),
                  letterSpacing: -0.12,
                  fontFamily: AppConstants.retailPharmaciesFontFamily),
              textAlign: TextAlign.center,
              // TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
        GestureDetector(
            onTap: () {
              controller.isPaymentDialogOpen.value = false;
              Get.back();
            },
            child: Icon(Icons.close))
      ],
    ),
  );
}

paymentRowWidget(
    {required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
    required Function() onChanged,
    required Function() onPressRefreshIcon}) {
  var homeController = Get.find<DashboardController>();

  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
          child: commonTextFieldWidget(
        controller: controller,
        title: title,
        keyboardType: TextInputType.number,
        focusNode: focusNode,
        onChanged: (value) {
          onChanged();
        },
        inputFormatter: [
          FilteringTextInputFormatter.allow(RegExp(r'(^\d{0,10}\.?\d{0,2})'))
        ],
      )),
      GestureDetector(
        onTap: () {
          onPressRefreshIcon();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.center,
            child: Obx(() => getCheckBoxState(
                    paymentMethod:
                        homeController.paymentDialogModel.value.paymentMethod,
                    title: title)
                ? Icon(Icons.check_box_rounded,color: lightColorPalette.greenColor.shade900,)
                : Icon(getCheckBoxState(
                        paymentMethod: homeController
                            .paymentDialogModel.value.paymentMethod,
                        title: title)
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded)),
          ),
        ),
      ),
    ],
  );
}

bool getCheckBoxState(
    {required PaymentMethod paymentMethod, required String title}) {
  if (title == AppStrings.cash.tr && paymentMethod == PaymentMethod.cash) {
    return true;
  } else if (title == AppStrings.humo.tr &&
      paymentMethod == PaymentMethod.humo) {
    return true;
  } else if (title == AppStrings.uzCard.tr &&
      paymentMethod == PaymentMethod.uzCard) {
    return true;
  } else if (title == AppStrings.other.tr &&
      paymentMethod == PaymentMethod.other) {
    return true;
  }
  return false;
}

class PaymentDialogModel {
  PaymentMethod paymentMethod = PaymentMethod.cash;
  TextEditingController cashTextEditingController = TextEditingController();
  TextEditingController humoTextEditingController = TextEditingController();
  TextEditingController uzCardTextEditingController = TextEditingController();
  TextEditingController otherTextEditingController = TextEditingController();
  String totalPaybleAmount;
  bool isValidData = false;
  FocusNode cashFocusNode = FocusNode();
  FocusNode humoFocusNode = FocusNode();
  FocusNode uzCardFocusNode = FocusNode();
  FocusNode otherFocusNode = FocusNode();

  PaymentDialogModel({required this.totalPaybleAmount});
}
