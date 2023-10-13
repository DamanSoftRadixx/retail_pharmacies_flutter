import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/routes/routes.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/dashboard_contoller.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/transfer_details_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/transfer_list_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/transfer_journal_controller.dart';
import 'package:get/get.dart';

extension KeyboardFunctionalityExtension on TransferJournalController {

  bool onTransferJournalKeyPressed(KeyEvent keyEvent) {
    if (keyEvent is KeyDownEvent || keyEvent is KeyRepeatEvent) {
      var isDialogOpen = Get.isDialogOpen ?? false;

      if (!isDialogOpen) {
        if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp &&
            isEnabledUpDownKey) {
          arrowUPFunctionality();
        } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown &&
            isEnabledUpDownKey) {
          arrowDownFunctionality();
        }
        else if (keyEvent is KeyDownEvent &&
            keyEvent.logicalKey == LogicalKeyboardKey.enter) {
          onDoubleTapTopTableItem(
              index: selectedIndexTop.value, docId: docsId.value);
        }
      }
    }

    return false;
  }

    // This function includes the functionality of keyboard up button.
  arrowDownFunctionality() {
    if (topTableFocusBool == true && bottomTableFocusBool == true) {
      bottomTableFocusBool = true;
      bottomIncreaseSelected();
    } else {
      bottomTableFocusBool = false;
      topIncreaseSelected();
    }
  }

  // This function includes the functionality of keyboard down button.
  arrowUPFunctionality() {
    print("bottomTableFocusBool : ${bottomTableFocusBool}");
    print("topTableFocusBool : ${topTableFocusBool}");
    if (bottomTableFocusBool == false) {
      topTableFocusBool = true;
      if (selectedIndexTop.value == (-1)) {
        topIncreaseSelected();
      } else {
        topDecreaseSelected();
      }
    } else {
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
          index: selectedIndexTop.value,
          controller: topCheckListScrollController);
      selectedIndexTop.refresh();
      topTableTableList.refresh();
      docsId.value = topTableTableList[selectedIndexTop.value].uuid ?? "";
      getBottomCheckTableData(docId: docsId.value);
    }
  }

  // This function is used to increment the focused index of top data table.
  topIncreaseSelected() {
    if (selectedIndexTop.value < (topTableTableList.value.length - 1)) {
      selectedIndexTop.value = selectedIndexTop.value + 1;
      scrollToIndex(
          index: selectedIndexTop.value,
          controller: topCheckListScrollController);
      topTableTableList();
      docsId.value = topTableTableList[selectedIndexTop.value].uuid ?? "";
      getBottomCheckTableData(docId: docsId.value);
    } else {
      if (bottomTableFocusBool == true) arrowDownFunctionality();
      topTableTableList.refresh();
    }
  }
}
