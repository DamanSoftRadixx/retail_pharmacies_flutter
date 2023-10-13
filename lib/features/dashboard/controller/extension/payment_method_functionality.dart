import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/dashboard_contoller.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/top_table_functionality.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/payment_dialog.dart';
import 'package:get/get.dart';

extension PaymentMethodFuctionality on DashboardController {
  void onPressPaymentMethods({required PaymentMethod paymentMethod}) {
    isPaymentDialogOpen.value = true;
    if (timeTableList.isEmpty || totalPayableAmountWithDiscount.value == 0) {
      return;
    }

    if (paymentMethod == PaymentMethod.cash) {
      paymentDialogModel.value.cashTextEditingController.text =
          totalPayableAmountWithDiscount.value.toString();
      paymentDialogModel.value.humoTextEditingController.clear();
      paymentDialogModel.value.otherTextEditingController.clear();
      paymentDialogModel.value.uzCardTextEditingController.clear();
    } else if (paymentMethod == PaymentMethod.humo) {
      paymentDialogModel.value.humoTextEditingController.text =
          totalPayableAmountWithDiscount.value.toString();
      paymentDialogModel.value.cashTextEditingController.clear();
      paymentDialogModel.value.otherTextEditingController.clear();
      paymentDialogModel.value.uzCardTextEditingController.clear();
    } else if (paymentMethod == PaymentMethod.uzCard) {
      paymentDialogModel.value.uzCardTextEditingController.text =
          totalPayableAmountWithDiscount.value.toString();
      paymentDialogModel.value.cashTextEditingController.clear();
      paymentDialogModel.value.otherTextEditingController.clear();
      paymentDialogModel.value.humoTextEditingController.clear();
    } else if (paymentMethod == PaymentMethod.other) {
      paymentDialogModel.value.otherTextEditingController.text =
          totalPayableAmountWithDiscount.value.toString();
      paymentDialogModel.value.cashTextEditingController.clear();
      paymentDialogModel.value.uzCardTextEditingController.clear();
      paymentDialogModel.value.humoTextEditingController.clear();
    }

    paymentDialogModel.value.totalPaybleAmount =
        totalPayableAmountWithDiscount.value.toString();
    paymentDialogModel.value.paymentMethod = paymentMethod;
    paymentDialogModel.value.isValidData = true;

    paymentDialog(onPressDone: () {
      onPressPaymentDoneButton();
    }, onChangedTextField: () {
      onChangeTextField();
    }, onPressRefreshIcon: (method) {
      paymentDialogModel.value.paymentMethod = method;
      paymentDialogModel.value.isValidData = true;
      paymentDialogModel.refresh();
      onPressRefreshIcon();
    });
  }


  onPressPaymentDoneButton(){
    if (isValidTotalPayment()) {
      if (getTotalCalculatedAmount() ==
          paymentDialogModel.value.totalPaybleAmount
              .toDoubleConversionWithRoundOff()) {
        updateThePaymentStatus();
        isPaymentDialogOpen.value = false;
        Get.back();
      } else {
        isPaymentDialogOpen.value = false;
        Get.back();
        try {
          commonDialogWidget(
              onPressOkayButton: () {
                Get.back();
              },
              isHideCancel: true,
              message: AppStrings.paymentIsPartial.tr);
        } catch (e, s) {
          print(s);
        }
      }
    } else {
      paymentDialogModel.value.isValidData = false;
      paymentDialogModel.refresh();
    }
  }

  double getTotalCalculatedAmount() {
    return paymentDialogModel.value.cashTextEditingController.text
            .toDoubleConversionWithRoundOff() +
        paymentDialogModel.value.humoTextEditingController.text
            .toDoubleConversionWithRoundOff() +
        paymentDialogModel.value.uzCardTextEditingController.text
            .toDoubleConversionWithRoundOff() +
        paymentDialogModel.value.otherTextEditingController.text
            .toDoubleConversionWithRoundOff();
  }

  isValidTotalPayment() {
    var totalCalculatedAmount = getTotalCalculatedAmount();

    var totalPayableAmount = totalPayableAmountWithDiscount.value
        .toString()
        .toDoubleConversionWithRoundOff();

    if (totalCalculatedAmount <= totalPayableAmount) {
      return true;
    }
    return false;
  }

  onChangeTextField() {
    print("on chnged : ${paymentDialogModel.value.paymentMethod}");

    var totalPayableAmount = totalPayableAmountWithDiscount.value
        .toString()
        .toDoubleConversionWithRoundOff();
    var cashAmount = paymentDialogModel.value.cashTextEditingController.text
        .toDoubleConversionWithRoundOff();
    var humoAmount = paymentDialogModel.value.humoTextEditingController.text
        .toDoubleConversionWithRoundOff();
    var uzCardAmount = paymentDialogModel.value.uzCardTextEditingController.text
        .toDoubleConversionWithRoundOff();
    var otherAmount = paymentDialogModel.value.otherTextEditingController.text
        .toDoubleConversionWithRoundOff();

    print("totalPayableAmount : $totalPayableAmount");
    print("cashAmount : $cashAmount");
    print("humoAmount : $humoAmount");
    print("uzCardAmount : $uzCardAmount");
    print("otherAmount : $otherAmount");

    switch (paymentDialogModel.value.paymentMethod) {
      case PaymentMethod.cash:
        var remainingAmount =
            (totalPayableAmount - (humoAmount + uzCardAmount + otherAmount));
        print("remainingAmount : $remainingAmount");
        if (remainingAmount >= 0) {
          paymentDialogModel.value.cashTextEditingController.text =
              remainingAmount.toString().replaceFirst(".00", "");
        } else {
          paymentDialogModel.value.cashTextEditingController.text = "0";
        }
        break;
      case PaymentMethod.humo:
        var remainingAmount =
            (totalPayableAmount - (cashAmount + uzCardAmount + otherAmount));
        if (remainingAmount > 0) {
          paymentDialogModel.value.humoTextEditingController.text =
              remainingAmount.toStringAsFixed(2).replaceFirst(".00", "");
        } else {
          paymentDialogModel.value.humoTextEditingController.text = "0";
        }
        break;
      case PaymentMethod.uzCard:
        var remainingAmount =
            (totalPayableAmount - (humoAmount + cashAmount + otherAmount));
        if (remainingAmount > 0) {
          paymentDialogModel.value.uzCardTextEditingController.text =
              remainingAmount.toStringAsFixed(2).replaceFirst(".00", "");
        } else {
          paymentDialogModel.value.uzCardTextEditingController.text = "0";
        }
        break;
      case PaymentMethod.other:
        var remainingAmount =
            (totalPayableAmount - (humoAmount + uzCardAmount + cashAmount));
        if (remainingAmount > 0) {
          paymentDialogModel.value.otherTextEditingController.text =
              remainingAmount.toStringAsFixed(2).replaceFirst(".00", "");
        } else {
          paymentDialogModel.value.otherTextEditingController.text = "0";
        }
        break;
      case PaymentMethod.none:
        print("none");
    }
    if (getTotalCalculatedAmount() <= totalPayableAmount) {
      paymentDialogModel.value.isValidData = true;
      paymentDialogModel.refresh();
    } else {
      paymentDialogModel.value.isValidData = false;
      paymentDialogModel.refresh();
    }
  }

  updateThePaymentStatus() async {
    showTopTableLoader(true);
    var timeTableData = timeTableList[selectedTimeTable.value];
    Map<String, dynamic> map = {
      "status": CheckStatus.payed.name,
      "cash": paymentDialogModel.value.cashTextEditingController.text,
      "amount": paymentDialogModel.value.totalPaybleAmount,
      "humo": paymentDialogModel.value.humoTextEditingController.text,
      "uzcard": paymentDialogModel.value.uzCardTextEditingController.text,
      "other": paymentDialogModel.value.otherTextEditingController.text,
      "date": getDateForApi(date: DateTime.now().toString()),
    };

    // String jsonUser = jsonEncode(tabLine);
    print(
        "********************** updateThePaymentStatus Request start **********************");
    print("updateThePaymentStatus : $map");
    print(
        "********************** updateThePaymentStatus Request start **********************");
    print(
        "********************** Object id ********************** : ${timeTableData.uuid ?? ""}");

    await feathersCheckService
        .patchMethodForCheckTabs(map, timeTableData.id ?? "");
    await getTimeListingApiIntegration(isClearList: true,isShowLoader: true);
    if (timeTableList.isEmpty) {
      topTableList.value = [];
      totalAmount.value = 0;
      checkCreatedDate.value = DateTime.now().toString();
      discount.value = 0;
      totalPayableAmountWithDiscount.value = 0;
      topTableList.refresh();
    } else {
      await getTopTableData(isShowLoader: true);
    }
    showTopTableLoader(false);
  }

  onPressRefreshIcon() {
    switch (paymentDialogModel.value.paymentMethod) {
      case PaymentMethod.cash:
        paymentDialogModel.value.cashTextEditingController.text =
            paymentDialogModel.value.totalPaybleAmount.toString();
        paymentDialogModel.value.humoTextEditingController.text = "";
        paymentDialogModel.value.uzCardTextEditingController.text = "";
        paymentDialogModel.value.otherTextEditingController.text = "";
        break;
      case PaymentMethod.humo:
        paymentDialogModel.value.cashTextEditingController.text = "";
        paymentDialogModel.value.humoTextEditingController.text =
            paymentDialogModel.value.totalPaybleAmount.toString();
        paymentDialogModel.value.uzCardTextEditingController.text = "";
        paymentDialogModel.value.otherTextEditingController.text = "";
        break;
      case PaymentMethod.uzCard:
        paymentDialogModel.value.cashTextEditingController.text = "";
        paymentDialogModel.value.humoTextEditingController.text = "";
        paymentDialogModel.value.uzCardTextEditingController.text =
            paymentDialogModel.value.totalPaybleAmount.toString();
        paymentDialogModel.value.otherTextEditingController.text = "";
        break;
      case PaymentMethod.other:
        paymentDialogModel.value.cashTextEditingController.text = "";
        paymentDialogModel.value.humoTextEditingController.text = "";
        paymentDialogModel.value.uzCardTextEditingController.text = "";
        paymentDialogModel.value.otherTextEditingController.text =
            paymentDialogModel.value.totalPaybleAmount.toString();

        break;
      case PaymentMethod.none:
        print("none");
    }
  }
}
