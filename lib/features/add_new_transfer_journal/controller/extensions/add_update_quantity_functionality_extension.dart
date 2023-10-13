import 'dart:convert';

import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/models/common/cost_model.dart';
import 'package:flutter_retail_pharmacies/core/models/common/per_model.dart';
import 'package:flutter_retail_pharmacies/core/models/common/price_model.dart';
import 'package:flutter_retail_pharmacies/core/models/common/quantity_model.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/models/request/table_line_request.dart';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/add_new_Transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/medicine_receipt_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/model/transfer_check_creation_model.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/add_quantity_dialog.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/common_textfield.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


extension AddUpdateQuantityFunctionalityExtension on AddNewTransferJournalController{
  String getTotalCountInsideThePackage({required String countInsideQuantity}) {
    var countInsideQuantityDouble = countInsideQuantity.toIntConversion();

    var quantityDouble = quantityTextController.text.toIntConversion();

    var totalNoOfTabletsIncludingAllPackages =
    (quantityDouble * countInsideQuantityDouble).toString();

    if (totalNoOfTabletsIncludingAllPackages != "0") {
      return totalNoOfTabletsIncludingAllPackages;
    } else {
      return countInsideQuantity;
    }
  }

  getQuantity({required List<Qty> qtyList}) {
    var quantity = qtyList
        .firstWhereOrNull((element) => element.uom?.id == QuantityTypes.pkg.name);
    var partial = qtyList.firstWhereOrNull(
            (element) => element.uom?.id == QuantityTypes.tablets.name);

    var totalQuantity = "0";

    if (quantity != null && partial != null && (partial?.number ?? 0) != 0) {
      totalQuantity =
      "${quantity.number == 0 ? "" : quantity.number} ${partial.number ?? 0}/${partial.of}";
    } else if (quantity != null) {
      totalQuantity = "${quantity.number ?? 0}";
    } else if (partial != null) {
      totalQuantity = "${partial.number ?? 0}";
    }

    return totalQuantity;
  }


  void deleteTopTableSelectedItem({required int index}) {
    print("topTableList[selectedIndexTop.value]>>>>>${selectedIndexTop.value}");
    var topTableRowData = topTableList[index];
    var status = topTableList[index].status ?? "";
    Map<String, dynamic> map = {};
    if (status == "") {
      map = {"status": "deleted"};
    } else {
      map = {"status": null};
    }

    // String jsonUser = jsonEncode(tabLine);
    print(
        "********************** deleteTopRow Request start **********************");
    print("jsonUser : $map");
    print(
        "********************** deleteTopRow Request start **********************");
    print(
        "********************** Object id ********************** : ${topTableRowData.id ?? ""}");

    feathersTransferService
        .patchMethodForTransferJournalTableEntry(map, topTableRowData.id ?? "")
        .then((value) => getTopTableData(isShowLoader: false,isClearList: true));
    Get.back();
  }


  addSearchEntryToTheTopTable() async {
    if (isValidatePopUp()) {
      Get.back();
      isShowErrorForQuantityPopUp.value = false;
      isShowErrorForQuantityPopUp.refresh();
      isQuantityPopupBool.value = false;

      var selectedSearchData = bottomTableList[selectedIndexBottom.value];

      if(docId.value == ""){

        feathersTransferService.createTransfer(TransferCheckCreationRequestModel(
            createdAt: DateTime.now().toString(),
            status: CheckStatus.draft.name,
            amount: "${totalAmount.value}",
            sender: "${senderAutoCompleteData.value.selectedValue.name}",
            receiver: "${receiverAutoCompleteData.value.selectedValue.name}",
            date: getDateForApi(date: DateTime.now().toString())
        ))
            .then((value) async {

          var quantityList = [
            QtyRequest(number: int.parse(quantityTextController.text), uom: "pkg")
          ];

          if (partialQuantityTextEditingController.text != "" &&
              partialQuantityTextEditingController.text != "0") {
            quantityList.add(QtyRequest(
                number: int.parse(partialQuantityTextEditingController.text),
                uom: "tablets",
                of: countPerQuantity));
          }

          TableLineRequest tabLine = TableLineRequest(
            document: value?.uuid ?? "",
            goods: selectedSearchData.uuid,
            qty: quantityList,
            price: Price(
                number: 25000,
                currency: "UZS",
                per: Per(number: 1, uom: "pkg")),
            cost: Cost(
                number: int.parse(summaTextController.text), currency: "UZS"),
          );

          docId.value = value?.uuid ?? "";
          id.value = value?.id ?? "";
          createdDateForMedicineReceipt.value = value?.createdAt ?? "";
          await feathersTransferService.createTransferCheckLine(tabLine.toJson());
          getTopTableData(isShowLoader: true);
        });
      }else{

        var quantityList = [
          QtyRequest(number: int.parse(quantityTextController.text), uom: "pkg")
        ];

        if (partialQuantityTextEditingController.text != "" &&
            partialQuantityTextEditingController.text != "0") {
          quantityList.add(QtyRequest(
              number: int.parse(partialQuantityTextEditingController.text),
              uom: "tablets",
              of: countPerQuantity));
        }

        TableLineRequest tabLine = TableLineRequest(
          document: docId.value,
          goods: selectedSearchData.uuid,
          qty: quantityList,
          price: Price(
              number: 25000,
              currency: "UZS",
              per: Per(number: 1, uom: "pkg")),
          cost: Cost(
              number: int.parse(summaTextController.text), currency: "UZS"),
        );

        print("Add Medicine Req : ${tabLine.toJson()}");

        await feathersTransferService.createTransferCheckLine(tabLine.toJson());
        print("Add Medicine Req :api ends");

        getTopTableData(isShowLoader: true);
      }


    } else {
      isShowErrorForQuantityPopUp.value = true;
      isShowErrorForQuantityPopUp.refresh();
    }
  }

  bool isValidatePopUp() {
    if (quantityTextController.text.isEmpty &&
        partialQuantityTextEditingController.text.isEmpty) {
      return false;
    }
    return true;
  }

  onTapSearchPopUpBackButton() {
    isQuantityPopupBool.value = false;
    Get.back();
  }

  onChangedSearchPopUpQuantityTextField(
      {required String value,
        required String sena,
        required String noOfTabletsInAPackage}) {
    print("value : $value, sena : $sena");

    int sum =
        quantityTextController.text.toIntConversion() * sena.toIntConversion();

    //If partialQuantity is there, then we need to caculate price accordingly.
    if (partialQuantityTextEditingController.text != "") {
      var pricePerTablet =
      (sena.toIntConversion() / noOfTabletsInAPackage.toIntConversion());

      int partialQuantityPrice = (pricePerTablet *
          partialQuantityTextEditingController.text.toIntConversion())
          .toInt();
      sum += partialQuantityPrice;
    }

    if (sum == 0) {
      summaTextController.text = "0.00";
    } else {
      summaTextController.text = sum.toString();
    }
  }

  openQuantityPopUp() {
    if (selectedIndexBottom.value > -1 && bottomTableFocusBool) {

      print("selectedIndexBottom : ${selectedIndexBottom.value} ");
      isQuantityPopupBool.value = true;
      searchFocusNode.unfocus();

      var data = bottomTableList.value[selectedIndexBottom.value];
      print("medicine name : ${data.name ?? ""} ");
      var popUpData = AddEditQuantityPopUpModel(
          name: data.name ?? "",
          manufacturar: data.manufacturer ?? "",
          series: "12345",
          totalQuantityAvailable: "20",
          expiryDate: "srokGod",
          totalPriceSum: 0,
          purchasedQuantity: "",
          partialQuantity: "",
          unitPrice: "25000",
          unitQuantity: "!0");

      summaTextController.text = "0.00";
      quantityTextController.text = "";
      isShowErrorForQuantityPopUp.value = false;
      partialQuantityTextEditingController.text = "";
      int maxQty = 10;

      addQuantityDialogWidgetAddTransfer(
          data: popUpData,
          partialQuantityTextController: partialQuantityTextEditingController,
          partialQuantityFocusNode: partialQuantityFocusNode,
          quantityController: quantityTextController,
          summaTextController: summaTextController,
          quantityFocusNode: quantityFocusNode,
          summaFocusNode: summaFocusNode,
          onChangedQuantity: (value) {
            onChangedSearchPopUpQuantityTextField(
                value: value,
                sena: "25000",
                noOfTabletsInAPackage: maxQty.toString());
          },
          onPressBackButton: () {
            onTapSearchPopUpBackButton();
          },
          onPressOkButton: () {
            addSearchEntryToTheTopTable();
          },
          maxQty: maxQty);
    }
    else if (selectedIndexTop.value > -1 && topTableFocusBool) {
      var data = topTableList[selectedIndexTop.value];
      var status = data.status ?? "";

      if (!(status == CheckStatus.deleted.name)) {
        isQuantityPopupBool.value = true;
        searchFocusNode.unfocus();

        var quantity = data.qty?.firstWhereOrNull(
                (element) => element.uom?.id == QuantityTypes.pkg.name);
        var partialQuantity = data.qty?.firstWhereOrNull(
                (element) => element.uom?.id == QuantityTypes.tablets.name);

        var popUpData = AddEditQuantityPopUpModel(
            name: data.goods?.name ?? "",
            manufacturar: "",
            series: "12345",
            totalQuantityAvailable: "20",
            expiryDate: "srokGod",
            totalPriceSum: data.cost?.number ?? 0,
            partialQuantity: partialQuantity?.number.toString() ?? "",
            purchasedQuantity: quantity?.number.toString() ?? "",
            unitPrice: "25000",
            unitQuantity: "10");

        quantityTextController.text =
            popUpData.purchasedQuantity.toString() ?? "";
        summaTextController.text = popUpData.totalPriceSum.toString() ?? "";
        partialQuantityTextEditingController.text =
            popUpData.partialQuantity.toString() ?? "";
        isShowErrorForQuantityPopUp.value = false;
        int maxQty = 10;

        addQuantityDialogWidgetAddTransfer(
            data: popUpData,
            isEdit: true,
            partialQuantityTextController: partialQuantityTextEditingController,
            partialQuantityFocusNode: partialQuantityFocusNode,
            quantityController: quantityTextController,
            summaTextController: summaTextController,
            quantityFocusNode: quantityFocusNode,
            summaFocusNode: summaFocusNode,
            onChangedQuantity: (value) {
              onChangedSearchPopUpQuantityTextField(
                  value: value,
                  sena: "25000",
                  noOfTabletsInAPackage: maxQty.toString());
            },
            onPressBackButton: () {
              onTapSearchPopUpBackButton();
            },
            onPressOkButton: () {
              updateQuantity();
            },
            maxQty: maxQty);
      } else {
        commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          title: AppStrings.error.tr,
          isHideCancel: true,
          message: AppStrings.youCantModifyItAsThisItemIsDeleted.tr,
        );
      }
    }
  }

  updateQuantity() async {
    if (isValidatePopUp()) {
      isQuantityPopupBool.value = false;
      Get.back();

      var selectedData = topTableList[selectedIndexTop.value];
      var quantityList = [
        QtyRequest(number: int.parse(quantityTextController.text), uom: "pkg")
      ];

      if (partialQuantityTextEditingController.text != "" &&
          partialQuantityTextEditingController.text != "0") {
        quantityList.add(QtyRequest(
            number: int.parse(partialQuantityTextEditingController.text),
            uom: "tablets",
            of: countPerQuantity));
      }

      TableLineRequest tableLine = TableLineRequest(
        qty: quantityList,
        cost: Cost(
          number: int.parse(summaTextController.text),
          currency: selectedData.cost?.currency ?? "",
        ),
      );

      String jsonUser = jsonEncode(tableLine);
      print(
          "********************** UpdateTopRow Request start **********************");
      print("jsonUser : $jsonUser");
      print("id : ${selectedData.id ?? ""}");
      print(
          "********************** UpdateTopRow Request start **********************");

      await feathersTransferService
          .patchMethodForTransferJournalTableEntry(tableLine.toJson(), selectedData.id ?? "");
      getTopTableData();
    }
  }

  addQuantityDialogWidgetAddTransfer(
      {required AddEditQuantityPopUpModel data,
        required TextEditingController quantityController,
        required TextEditingController summaTextController,
        required TextEditingController partialQuantityTextController,
        required FocusNode quantityFocusNode,
        required FocusNode partialQuantityFocusNode,
        required FocusNode summaFocusNode,
        required Function(String value) onChangedQuantity,
        required Function() onPressBackButton,
        required Function() onPressOkButton,
        bool isEdit = false,
        required int maxQty,}) {
/*  var sena = "25000";
  var seriya = "12345";
  var srokGod = "srokGod";
  var ostatok = "20";*/

    Get.dialog(AlertDialog(
      content: Container(
        width: 700,
        decoration: BoxDecoration(
            color: lightColorPalette.whiteColor.shade700.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            dialogHeader(
              onPressBackButton: (){
                onPressBackButton();
              },
              title:
              isEdit ? AppStrings.editQuantity.tr : AppStrings.addQuantity.tr,
              subTitle: "",
            ),
            Container(
              height: 0.4,
              decoration: BoxDecoration(
                color: lightColorPalette.blackColor.shade700,
              ),
            ),
            Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 400,
                                child: Text(
                                  data.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Color(0xFF0E0631),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                data.manufacturar,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF0E0631),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sena",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF0E0631),
                                ),
                              ),
                              Text(
                                data.unitPrice,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF0E0631),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.series2.tr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0E0631),
                                ),
                              ),
                              Text(
                                data.series,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF0E0631),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.expiryDate.tr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0E0631),
                                ),
                              ),
                              Text(
                                data.expiryDate,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF0E0631),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.remainder2.tr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0E0631),
                                ),
                              ),
                              Text(
                                data.totalQuantityAvailable,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF0E0631),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 50,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Text(
                                    AppStrings.quantity.tr,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color:
                                        lightColorPalette.blackColor.shade900,
                                        letterSpacing: -0.12,
                                        fontFamily: AppConstants
                                            .retailPharmaciesFontFamily),
                                    textAlign: TextAlign.start,
                                    // TextStyle(fontSize: 16.sp),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    quantityFocusNode.requestFocus();
                                  },
                                  child: Container(
                                    height: 44.h,
                                    decoration: BoxDecoration(
                                        color:
                                        lightColorPalette.whiteColor.shade900,
                                        borderRadius: BorderRadius.circular(6.r),
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            color: lightColorPalette
                                                .blackColor.shade700,
                                            width: 0.5)),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child:
                                          commonTextFieldWidgetWithoutBorder(
                                            inputFormatter: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            controller: quantityController,
                                            autoFocus: true,
                                            keyboardType: TextInputType.number,
                                            focusNode: quantityFocusNode,
                                            onChanged: (value) {
                                              onChangedQuantity(value);
                                            },
                                          ),
                                        ),
                                        VerticalDivider(
                                          width: 0,
                                          color: lightColorPalette
                                              .blackColor.shade700,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child:
                                                commonTextFieldWidgetWithoutBorder(
                                                  maxLength: 2,
                                                  inputFormatter: <
                                                      TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  controller:
                                                  partialQuantityTextController,
                                                  textAlign: TextAlign.center,
                                                  keyboardType:
                                                  TextInputType.number,
                                                  focusNode:
                                                  partialQuantityFocusNode,
                                                  onChanged: (value) {
                                                    if (value.toIntConversion() <=
                                                        maxQty) {
                                                      isPartialQuantityError
                                                          .value = false;
                                                      onChangedQuantity(value);
                                                    } else {
                                                      isPartialQuantityError
                                                          .value = true;
                                                      partialQuantityTextController
                                                          .text = "";
                                                    }
                                                  },
                                                ),
                                              ),
                                              Divider(
                                                  color: lightColorPalette
                                                      .blackColor.shade700,
                                                  height: 0),
                                              Expanded(
                                                  child: Container(
                                                    width: 1.sw,
                                                    decoration: BoxDecoration(
                                                        color: lightColorPalette
                                                            .greenColor.shade900
                                                            .withOpacity(0.2)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      countPerQuantity,
                                                      style: TextStyle(
                                                          color: lightColorPalette
                                                              .blackColor.shade900,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 14.sp,
                                                          fontFamily: AppConstants
                                                              .retailPharmaciesFontFamily),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Text(
                                    "Summa",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color:
                                        lightColorPalette.blackColor.shade900,
                                        letterSpacing: -0.12,
                                        fontFamily: AppConstants
                                            .retailPharmaciesFontFamily),
                                    textAlign: TextAlign.start,
                                    // TextStyle(fontSize: 16.sp),
                                  ),
                                ),
                                Container(
                                  height: 44.h,
                                  decoration: BoxDecoration(
                                      color:
                                      lightColorPalette.whiteColor.shade900,
                                      borderRadius: BorderRadius.circular(6.r),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                          color: lightColorPalette
                                              .blackColor.shade700,
                                          width: 0.5)),
                                  child: commonTextFieldWidgetWithoutBorder(
                                    keyboardType: TextInputType.number,
                                    controller: summaTextController,
                                    focusNode: summaFocusNode,
                                    readOnly: true,
                                    onChanged: (value) {
                                      onChangedQuantity(value);
                                    },
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'(^\d{0,10}\.?\d{0,2})'))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //error Msg
                      isShowErrorForQuantityPopUp.isTrue
                          ? errorText(errorMsg: AppStrings.pleaseEnterQuantity.tr)
                          : isPartialQuantityError.value
                          ? errorText(
                          errorMsg:
                          "${AppStrings.partialQuantityMsg.tr} $maxQty")
                          : SizedBox(height: 40.h),

                      //Quantity Textfields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              onPressOkButton();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 150,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: lightColorPalette.themeColor.shade900,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                AppStrings.oKButton.tr,
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: lightColorPalette.whiteColor.shade900,
                                    letterSpacing: -0.12,
                                    fontFamily:
                                    AppConstants.retailPharmaciesFontFamily),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                ))
          ],
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      backgroundColor: lightColorPalette.whiteColor.shade900,
    ),barrierDismissible: false);

    return;
  }



}