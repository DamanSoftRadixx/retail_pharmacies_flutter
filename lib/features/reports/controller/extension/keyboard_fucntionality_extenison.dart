import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/local_library/scroll_to_index.dart';
import 'package:flutter_retail_pharmacies/features/reports/controller/inventory_reports_controller.dart';
import 'package:get/get.dart';

extension KeyboardFucntionalityExtension on InventoryReportsController {
  bool onInventoryReportsKeyPressed(KeyEvent keyEvent) {
    if (keyEvent is KeyDownEvent || keyEvent is KeyRepeatEvent) {
      var isDialogOpen = Get.isDialogOpen ?? false;
      if (!isDialogOpen) {
        if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp &&
            isEnabledUpDownKey) {
          arrowUPFunctionality();
        } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown &&
            isEnabledUpDownKey) {
          arrowDownFunctionality();
        } else if (keyEvent is KeyDownEvent &&
            keyEvent.logicalKey == LogicalKeyboardKey.enter) {
          onPressEnterKey();
        } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowRight &&
            isEnabledUpDownKey) {
          arrowRightFunctionality();
        } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowLeft &&
            isEnabledUpDownKey) {
          arrowLeftFunctionality();
        } else if (keyEvent.logicalKey == LogicalKeyboardKey.escape) {
          escapeKeyFunctionality();
        }
      }
    }

    return false;
  }

  onPressEnterKey() {
    var selectedTab = tabBarList[selectedTabIndex.value];

    if (selectedTab.selectedRowIndex > -1) {
      onDoubleTapRowItemOfGroup(sectionRowIndex: selectedTab.selectedRowIndex);
    }
  }

  // This function includes the functionality of keyboard up button.
  arrowDownFunctionality() {
    var selectedTab = tabBarList[selectedTabIndex.value];
    if (selectedTab.sectionRowList.isNotEmpty &&
        selectedTab.selectedRowIndex == -1){
      selectedTab.selectedRowIndex += 2;
      scrollAndSelectRowAfterIndexUpdated();
    }
    else if (selectedTab.sectionRowList.isNotEmpty &&
        selectedTab.selectedRowIndex < selectedTab.sectionRowList.length - 1) {
      selectedTab.selectedRowIndex += 1;
      var selectedRowAfterUpdate =
          selectedTab.sectionRowList[selectedTab.selectedRowIndex];
      if (selectedRowAfterUpdate.isTableHeaderRow) {
        if (selectedTab.selectedRowIndex ==
            selectedTab.sectionRowList.length - 1) {
          selectedTab.selectedRowIndex -= 1;
        } else {
          selectedTab.selectedRowIndex += 1;
          scrollAndSelectRowAfterIndexUpdated();
        }
      } else {
        scrollAndSelectRowAfterIndexUpdated();
      }
    }

    tabBarList.refresh();
  }

  scrollAndSelectRowAfterIndexUpdated(){
    var selectedTab = tabBarList[selectedTabIndex.value];

    setSelectedGroupRowIndex(rowIndex: selectedTab.selectedRowIndex);

    // To prevent bouncing of table, we will not let the table scroll for last index
    // if(selectedTab.selectedRowIndex != selectedTab.sectionRowList.length - 1){
      scrollToIndex(
          index: selectedTab.selectedRowIndex,
          controller: selectedTab.scrollController);
    // }
  }
  // This function includes the functionality of keyboard down button.
  arrowUPFunctionality() {
    var selectedTab = tabBarList[selectedTabIndex.value];

    if (selectedTab.sectionRowList.isNotEmpty &&
        selectedTab.selectedRowIndex > 0) {
      selectedTab.selectedRowIndex -= 1;

      var selectedRowAfterUpdate =
          selectedTab.sectionRowList[selectedTab.selectedRowIndex];

      //we are checking for another table
      if (selectedRowAfterUpdate.isTableHeaderRow) {
        if (selectedTab.selectedRowIndex == 0) {
          selectedTab.selectedRowIndex += 1;
        } else {
          selectedTab.selectedRowIndex -= 1;
          scrollAndSelectRowAfterIndexUpdated();
        }
      } else {
        scrollAndSelectRowAfterIndexUpdated();
      }
    }

    tabBarList.refresh();
  }

  Future scrollToIndex(
      {required int index, required AutoScrollController controller}) async {
    isEnabledUpDownKey = false;
    await controller.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);
    isEnabledUpDownKey = true;
  }

  arrowRightFunctionality() {
    goToNextTab();
  }

  arrowLeftFunctionality() {
    goToPreviousTab();
  }

  escapeKeyFunctionality() {
    goToPreviousTabWithClearingTabs();
  }

  goToPreviousTab() {
    if (selectedTabIndex.value > 0) {
      selectedTabIndex.value -= 1;
      tabBarController?.animateTo(selectedTabIndex.value);
    }
  }

  goToPreviousTabWithClearingTabs() {
    if (selectedTabIndex.value > 0) {
      var startingPoint = tabBarList.length - 1;
      for (int i = startingPoint; i >= selectedTabIndex.value; i--) {
        tabBarList.removeLast();
      }
      updateTabBarController();
    }
  }

  goToNextTab() {
    if (selectedTabIndex.value < tabBarList.length - 1) {
      selectedTabIndex.value += 1;
      tabBarController?.animateTo(selectedTabIndex.value);
    }
  }
}
