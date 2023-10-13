import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/routes/routes.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/add_new_Transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/keyboard_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/check_details/controller/check_details_controller.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/dashboard_contoller.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/add_quantity_popup_functionality.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/bottom_table_functionality.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/payment_method_functionality.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/search_field_fucntionailty.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/top_table_functionality.dart';
import 'package:flutter_retail_pharmacies/features/reports/controller/extension/keyboard_fucntionality_extenison.dart';
import 'package:flutter_retail_pharmacies/features/reports/controller/inventory_reports_controller.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/keyboard_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/transfer_journal_controller.dart';
import 'package:get/get.dart';

// This extension contains the logical part related to keyboard handling.
extension KeyboardHandlingFunctionality on DashboardController {
  keyboardListenerHandler() {
    ServicesBinding.instance.keyboard.addHandler(onKeyboardCallback);
  }


  bool onKeyboardCallback(KeyEvent keyEvent){
    if(Get.currentRoute == Routes.dashboard){

      if(selectedLeftPanelTab.value == LeftPanelTabs.dashboard) {
        onAddCheckJournalKeyPressed(keyEvent);
      }
      else if(selectedLeftPanelTab.value == LeftPanelTabs.checkJournal &&
          Get.isRegistered<CheckDetailsController>()){
        CheckDetailsController controller = Get.find();
        controller.onCheckJournalKeyPressed(keyEvent);
      }
      else if(selectedLeftPanelTab.value == LeftPanelTabs.transferJournal &&
          selectedRightPanelTab.value != RightPanelTabs.addNewTransferJournal &&
          Get.isRegistered<TransferJournalController>()){
        TransferJournalController controller = Get.find();
        controller.onTransferJournalKeyPressed(keyEvent);
      }
      else if(selectedLeftPanelTab.value == LeftPanelTabs.transferJournal &&
          selectedRightPanelTab.value == RightPanelTabs.addNewTransferJournal &&
          Get.isRegistered<AddNewTransferJournalController>()){
        AddNewTransferJournalController controller = Get.find();
        controller.onAddTransferJournalKeyPressed(keyEvent);
      }
      else if(selectedLeftPanelTab.value == LeftPanelTabs.inventoryReports &&
          Get.isRegistered<InventoryReportsController>()){
        InventoryReportsController controller = Get.find();
        controller.onInventoryReportsKeyPressed(keyEvent);
      }
    }


    return false;
  }

  bool onAddCheckJournalKeyPressed(KeyEvent keyEvent) {

    if(keyEvent.logicalKey == LogicalKeyboardKey.controlLeft && keyEvent is KeyDownEvent){
      isCtrlPressing = true;
    }else if(keyEvent.logicalKey == LogicalKeyboardKey.controlLeft && keyEvent is KeyUpEvent){
      isCtrlPressing = false;
    }

    if (keyEvent is KeyDownEvent || keyEvent is KeyRepeatEvent) {
      var isDialogOpen = Get.isDialogOpen ?? false;

      if (!isDialogOpen) {
        if (!isCtrlPressing && (RegExp("[0-9a-zA-Zа-яА-Я]")
            .hasMatch(keyEvent.character ?? ""))) {
          if (isQuantityPopupBool.value == false) {
            onFocusSearchFunction();
          }

        } else if (isCtrlPressing &&
            keyEvent is KeyDownEvent && keyEvent.physicalKey == PhysicalKeyboardKey.keyN) {
          onTapNewEntryButtonInTimeList();

        }else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp &&
            isEnabledUpDownKey) {
          arrowUPFunctionality();
        } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown &&
            isEnabledUpDownKey) {
          arrowDownFunctionality();
        } else if (keyEvent is KeyDownEvent && keyEvent.logicalKey == LogicalKeyboardKey.enter) {
          onEnterPress();
        } else if (keyEvent is KeyDownEvent && keyEvent.logicalKey == LogicalKeyboardKey.f8) {
          onPressFunctionKeys(functionKey: PaymentMethodFunctionKeys.f8);
        } else if (keyEvent is KeyDownEvent && keyEvent.logicalKey == LogicalKeyboardKey.f9) {
          onPressFunctionKeys(functionKey: PaymentMethodFunctionKeys.f9);
        } else if (keyEvent is KeyDownEvent && keyEvent.logicalKey == LogicalKeyboardKey.f10) {
          onPressFunctionKeys(functionKey: PaymentMethodFunctionKeys.f10);
          return true;
        } else if (keyEvent is KeyDownEvent && keyEvent.logicalKey == LogicalKeyboardKey.f12) {
          onPressFunctionKeys(functionKey: PaymentMethodFunctionKeys.f12);
          return true;
        } else if (keyEvent.logicalKey == LogicalKeyboardKey.backspace) {
          onBackPress();
          return true;
        } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowLeft &&
            isEnabledUpDownKey) {
          searchFocusNode.unfocus();
          timeTableDecreaseSelected();
        } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowRight &&
            isEnabledUpDownKey) {
          searchFocusNode.unfocus();
          timeTableIncreaseSelected();
        } else if (keyEvent is KeyDownEvent && keyEvent.logicalKey == LogicalKeyboardKey.delete) {
          searchFocusNode.unfocus();
          if (topTableFocusBool = true && selectedIndexTop.value > -1) {
            deleteTopTableSelectedItem(index: selectedIndexTop.value);
          }
        }
      }
      else if (keyEvent is KeyDownEvent && topTableFocusBool &&
          isQuantityPopupBool.value &&
          keyEvent.logicalKey == LogicalKeyboardKey.enter) {
        updateQuantity();
        Get.back();

      }  else if (keyEvent is KeyDownEvent && isPaymentDialogOpen.value &&
          keyEvent.logicalKey == LogicalKeyboardKey.enter) {
        onPressPaymentDoneButton();
      }else if (keyEvent is KeyDownEvent && bottomTableFocusBool &&
          isQuantityPopupBool.value &&
          keyEvent.logicalKey == LogicalKeyboardKey.enter) {
        addSearchEntryToTheTopTable();
      } else if (keyEvent is KeyDownEvent && keyEvent.logicalKey == LogicalKeyboardKey.escape) {
        if (Get.isDialogOpen == true) {
          isQuantityPopupBool.value = false;
          isPaymentDialogOpen.value = false;
          Get.back();
        }
      }
    }

    return false;
  }

    onPressFunctionKeys({required PaymentMethodFunctionKeys functionKey}) {
    if (timeTableList.isNotEmpty) {
      switch (functionKey) {
        case PaymentMethodFunctionKeys.f8:
          onPressPaymentMethods(
            paymentMethod: PaymentMethod.cash,
          );
          break;
        case PaymentMethodFunctionKeys.f9:
          onPressPaymentMethods(paymentMethod: PaymentMethod.humo);
          break;
        case PaymentMethodFunctionKeys.f10:
          onPressPaymentMethods(paymentMethod: PaymentMethod.uzCard);
          break;
        case PaymentMethodFunctionKeys.f12:
          onPressPaymentMethods(paymentMethod: PaymentMethod.other);
          break;
      }
    }
  }

  onPressF8() {
    if (timeTableList.isNotEmpty) {}
  }

  onPressF9() {
    if (timeTableList.isNotEmpty) {
      onPressPaymentMethods(paymentMethod: PaymentMethod.humo);
    }
  }

  onPressF10() {
    if (timeTableList.isNotEmpty) {
      onPressPaymentMethods(paymentMethod: PaymentMethod.uzCard);
    }
  }

  onPressF12() {
    onPressPaymentMethods(paymentMethod: PaymentMethod.other);
  }

  // This function includes the functionality of keyboard up button.
  arrowDownFunctionality() {
    searchFocusNode.unfocus();
    if (topTableFocusBool == false) {
      bottomTableFocusBool = true;
      bottomIncreaseSelected();
    } else {
      bottomTableFocusBool = false;
      topIncreaseSelected();
    }
  }

  // This function includes the functionality of keyboard down button.
  arrowUPFunctionality() {
    searchFocusNode.unfocus();

    if (bottomTableFocusBool == false) {
      topTableFocusBool = true;
      if (selectedIndexTop.value == (-1)) {
        topIncreaseSelected();
      } else {
        topDecreaseSelected();
      }
    } else {
      topTableFocusBool = false;
      bottomDecreaseSelected();
    }
  }

  // This function is used to decrement the focused index of search table.
  bottomDecreaseSelected() {
    if (selectedIndexBottom.value > 0) {
      selectedIndexBottom.value = selectedIndexBottom.value - 1;
      scrollToIndex(
          index: selectedIndexBottom.value,
          controller: bottomListScrollController);
      selectedIndexBottom.refresh();
      bottomTableList.refresh();
    } else {
      bottomTableFocusBool = false;
      selectedIndexBottom.value = -1;
      bottomTableList.refresh();
      arrowUPFunctionality();
    }
  }

  // This function is used to increment the focused index of search table.
  bottomIncreaseSelected() {
    if (selectedIndexBottom.value < (bottomTableList.value.length - 1)) {
      selectedIndexBottom.value = selectedIndexBottom.value + 1;
      scrollToIndex(
          index: selectedIndexBottom.value,
          controller: bottomListScrollController);
      selectedIndexBottom.refresh();
      bottomTableList.refresh();
    }
  }

  // This function is used to decrement the focused index of top data table.
  topDecreaseSelected() {
    if (selectedIndexTop.value > 0) {
      selectedIndexTop.value = selectedIndexTop.value - 1;
      scrollToIndex(
          index: selectedIndexTop.value, controller: topListScrollController);
      selectedIndexTop.refresh();
      topTableList.refresh();
    }
  }

  // This function is used to increment the focused index of top data table.
  topIncreaseSelected() {
    if (selectedIndexTop.value < (topTableList.value.length - 1)) {
      selectedIndexTop.value = selectedIndexTop.value + 1;
      scrollToIndex(
          index: selectedIndexTop.value, controller: topListScrollController);
      topTableList.refresh();
    } else {
      topTableFocusBool = false;
      selectedIndexTop.value = -1;
      arrowDownFunctionality();
      topTableList.refresh();
    }
  }

  // This function is used to decrement the focused index of time table.
  timeTableDecreaseSelected() {
    if (selectedTimeTable.value > 0) {
      selectedTimeTable.value = selectedTimeTable.value - 1;
      selectedIndexTop.value = -1;
      selectedIndexTop.refresh();
      scrollToIndex(
          index: selectedTimeTable.value, controller: timeListScrollController);
      docsId.value = timeTableList[selectedTimeTable.value].uuid ?? "";

      if (docsId.value == "temp") {
        topTableList.value.clear();
        topTableList.refresh();
        totalAmount.value = 0;
        checkCreatedDate.value = DateTime.now().toString();
        totalPayableAmountWithDiscount.value = 0;
        discount.value = 0;
      } else {
        getTopTableData();
      }
      selectedTimeTable.refresh();
      timeTableList.refresh();
    }
  }

  // This function is used to increment the focused index of time table.
  timeTableIncreaseSelected() {
    if (selectedTimeTable.value < (timeTableList.value.length - 1)) {
      selectedTimeTable.value = selectedTimeTable.value + 1;
      selectedIndexTop.value = -1;
      selectedIndexTop.refresh();
      scrollToIndex(
          index: selectedTimeTable.value, controller: timeListScrollController);
      docsId.value = timeTableList[selectedTimeTable.value].uuid ?? "";
      if (docsId.value == "temp") {
        topTableList.clear();
        topTableList.refresh();
        totalAmount.value = 0;
        totalPayableAmountWithDiscount.value = 0;
        discount.value = 0;
        checkCreatedDate.value = DateTime.now().toString();

      } else {
        getTopTableData();
      }

      selectedTimeTable.refresh();
      timeTableList.refresh();
    }
  }

  //This function is used to implement the delete searchFieldText functionality word by word.
  void onBackPress() {
    print("on Press Back button");
    if (isQuantityPopupBool.value == false &&
        topTableFocusBool == true &&
        selectedIndexTop.value > -1) {
      deleteTopTableSelectedItem(index: selectedIndexTop.value);
    } else if (searchFocusNode.hasFocus) {
      if (searchTextEditingController.text.isNotEmpty) {
        searchTextEditingController.text = searchTextEditingController.text
            .substring(0, searchTextEditingController.text.length - 1);

        // This lines moves the cursor to end of the text inside the searchField.
        searchTextEditingController.selection = TextSelection.collapsed(
            offset: searchTextEditingController.text.length);
        searchOnChange(searchTextEditingController.text);
      }
    }else{
      if (searchTextEditingController.text.isNotEmpty) {
        searchFocusNode.requestFocus();

        searchTextEditingController.text = searchTextEditingController.text
            .substring(0, searchTextEditingController.text.length - 1);

        // This lines moves the cursor to end of the text inside the searchField.
        searchTextEditingController.selection = TextSelection.collapsed(
            offset: searchTextEditingController.text.length);
        searchOnChange(searchTextEditingController.text);
      }
    }
  }

  // This function is used to focus the searchTextField, and clear the textField.
  onFocusSearchFunction() {
    if (!searchFocusNode.hasFocus) {
      unselectTopTableRow();
      unselectBottomTableRow();
      searchTextEditingController.clear();
      searchFocusNode.requestFocus();
    }
    return false;

  }

  // onEnterPress is used for showing  quantity popup
  void onEnterPress() {
    openQuantityPopUp();
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

    feathersCheckService.patchMethodForCheckJournalTableEntry(map, topTableRowData.id ?? "")
        .then((value) => getTopTableData(isShowLoader: false,isClearList: true));
    Get.back();
  }
}
