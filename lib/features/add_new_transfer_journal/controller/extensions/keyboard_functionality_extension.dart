import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/autocomplete_textfield.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/add_new_Transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/add_update_quantity_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/medicine_receipt_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/search_table_functionality_extension.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

extension KeyboardFucntionalityExtension on AddNewTransferJournalController{


  bool onAddTransferJournalKeyPressed(KeyEvent keyEvent) {
    if (keyEvent is KeyDownEvent || keyEvent is KeyRepeatEvent) {
      var isDialogOpen = Get.isDialogOpen ?? false;

      if(senderAutoCompleteData.value.focusNode.hasFocus || senderAutoCompleteData.value.isEnableEditing){
        onSenderAutoCompleteTextFieldKeyPressed(keyEvent);
        // senderAutoCompleteTextFieldController.onAutoCompleteTextFieldKeyPressed(keyEvent);
      }else if(receiverAutoCompleteData.value.focusNode.hasFocus || receiverAutoCompleteData.value.isEnableEditing){
        onReceiverAutoCompleteTextFieldKeyPressed(keyEvent);
        // receiverAutoCompleteTextFieldController.onAutoCompleteTextFieldKeyPressed(keyEvent);
      }else{
        if (!isDialogOpen) {
          if ((RegExp("[0-9a-zA-Zа-яА-Я]")
              .hasMatch(keyEvent.character ?? ""))) {
            if (isQuantityPopupBool.value == false) {
              onFocusSearchFunction();
            }

          }
          else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp &&
              isEnabledUpDownKey) {
            arrowUPFunctionality();
          } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown &&
              isEnabledUpDownKey) {
            arrowDownFunctionality();
          } else if (keyEvent is KeyDownEvent && keyEvent.logicalKey == LogicalKeyboardKey.enter) {
            onEnterPress();
          }  else if (keyEvent.logicalKey == LogicalKeyboardKey.backspace) {
            onBackPress();
            return true;
          } else if (keyEvent is KeyDownEvent && keyEvent.logicalKey == LogicalKeyboardKey.delete) {
            print("delete key pressed");
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
        }
        else if (keyEvent is KeyDownEvent && bottomTableFocusBool &&
            isQuantityPopupBool.value &&
            keyEvent.logicalKey == LogicalKeyboardKey.enter) {
          addSearchEntryToTheTopTable();
        }
        /*else if (keyEvent is KeyDownEvent &&
            isOpenTransferDetailsDialog.value &&
            keyEvent.logicalKey == LogicalKeyboardKey.enter) {
          // onPressTransferDetailDoneButton();
        }
        else if (keyEvent is KeyDownEvent && keyEvent.logicalKey == LogicalKeyboardKey.escape) {
          if (Get.isDialogOpen == true) {
            isQuantityPopupBool.value = false;
            isOpenTransferDetailsDialog.value = false;
            Get.back();
          }
        }*/
      }
    }

    return false;
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
    if (!searchFocusNode.hasFocus && !(senderAutoCompleteData.value.isEnableEditing || receiverAutoCompleteData.value.isEnableEditing)) {
      unselectTopTableRow();
      unselectBottomTableRow();
      searchTextEditingController.clear();
      searchFocusNode.requestFocus();
    }
    return false;

  }
  // searchOnChange  function is used for onchange functionality of search textfield
  searchOnChange(String value){
    if(value.isNotEmpty){
      offsetCountBottom.value=0;
      loadMoreBottom.value = false;
      unselectBottomTableRow();
      searchApiIntegration(isClearListFirst: true);
    }else{
      bottomTableList.clear();
      bottomTableList.refresh();
    }
  }



  // onEnterPress is used for showing  quantity popup
  void onEnterPress() {
    print("open popup");
     openQuantityPopUp();
  }


}


extension SenderAddNewTransferkeyboardFunctionality on AddNewTransferJournalController{


  bool onSenderAutoCompleteTextFieldKeyPressed(KeyEvent keyEvent) {
    if (keyEvent is KeyDownEvent || keyEvent is KeyRepeatEvent) {
      var isDialogOpen = Get.isDialogOpen ?? false;

      if (!isDialogOpen) {
        if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp &&
            isEnabledUpDownKey) {
          senderArrowUPFunctionality();
        } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown &&
            isEnabledUpDownKey) {
          senderArrowDownFunctionality();
        }
        else if (keyEvent is KeyDownEvent &&
            keyEvent.logicalKey == LogicalKeyboardKey.enter && senderAutoCompleteData.value.currentIndex >= 0) {
          senderSelectAutoCompleteItem();
          return false;
        }
      }
    }

    return false;
  }

  // This function is used to decrement the focused index of search table.
  senderArrowUPFunctionality() {
    if (senderAutoCompleteData.value.currentIndex > 0) {
      senderAutoCompleteData.value.currentIndex = senderAutoCompleteData.value.currentIndex - 1;
      scrollToIndex(
          index: senderAutoCompleteData.value.currentIndex,
          controller: senderAutoCompleteData.value.scrollController);
      senderAutoCompleteData.refresh();
    }
  }

  // This function is used to increment the focused index of search table.
  senderArrowDownFunctionality() {
    if (senderAutoCompleteData.value.currentIndex < (senderAutoCompleteData.value.autoCompleteList.length - 1)) {
      senderAutoCompleteData.value.currentIndex = senderAutoCompleteData.value.currentIndex + 1;
      scrollToIndex(
          index: senderAutoCompleteData.value.currentIndex,
          controller: senderAutoCompleteData.value.scrollController);
      senderAutoCompleteData.refresh();
    }
  }


  senderSelectAutoCompleteItem(){
    var selectedData = senderAutoCompleteData.value.autoCompleteList[senderAutoCompleteData.value.currentIndex];
    senderAutoCompleteData.value.selectedValue = selectedData;
    senderAutoCompleteData.value.currentIndex = -1;
    senderAutoCompleteData.value.isEnableEditing = false;
    senderAutoCompleteData.value.textField.text = selectedData.name;
    AutoCompleteDropDownTextField.removeOverlay();
    if(docId.value != ""){
      updateTransferDetails();
    }
    senderAutoCompleteData.value.textField.text = senderAutoCompleteData.value.selectedValue.name;
    Future.delayed(Duration(milliseconds: AutoCompleteDropDownTextField.animationTime)).then((value) {
      senderAutoCompleteData.value.isEnableEditing = false;
      senderAutoCompleteData.refresh();

    });


  }


}

extension ReceiverAddNewTransferkeyboardFunctionality on AddNewTransferJournalController{


  bool onReceiverAutoCompleteTextFieldKeyPressed(KeyEvent keyEvent) {
    if (keyEvent is KeyDownEvent || keyEvent is KeyRepeatEvent) {
      var isDialogOpen = Get.isDialogOpen ?? false;

      if (!isDialogOpen) {
        if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp &&
            isEnabledUpDownKey) {
          senderArrowUPFunctionality();
        } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown &&
            isEnabledUpDownKey) {
          receiverArrowDownFunctionality();
        }
        else if (keyEvent is KeyDownEvent &&
            keyEvent.logicalKey == LogicalKeyboardKey.enter && receiverAutoCompleteData.value.currentIndex >= 0) {
          receiverSelectAutoCompleteItem();
        }
      }
    }

    return false;
  }

  // This function is used to decrement the focused index of search table.
  receiverArrowUPFunctionality() {
    if (receiverAutoCompleteData.value.currentIndex > 0) {
      receiverAutoCompleteData.value.currentIndex = receiverAutoCompleteData.value.currentIndex - 1;
      scrollToIndex(
          index: receiverAutoCompleteData.value.currentIndex,
          controller: receiverAutoCompleteData.value.scrollController);
      receiverAutoCompleteData.refresh();
    }
  }

  // This function is used to increment the focused index of search table.
  receiverArrowDownFunctionality() {
    if (receiverAutoCompleteData.value.currentIndex < (receiverAutoCompleteData.value.autoCompleteList.length - 1)) {
      receiverAutoCompleteData.value.currentIndex = receiverAutoCompleteData.value.currentIndex + 1;
      scrollToIndex(
          index: receiverAutoCompleteData.value.currentIndex,
          controller: receiverAutoCompleteData.value.scrollController);
      receiverAutoCompleteData.refresh();
    }
  }


  receiverSelectAutoCompleteItem(){
    var selectedData = receiverAutoCompleteData.value.autoCompleteList[receiverAutoCompleteData.value.currentIndex];
    receiverAutoCompleteData.value.currentIndex = -1;
    receiverAutoCompleteData.value.selectedValue = selectedData;
    receiverAutoCompleteData.value.isEnableEditing = false;
    receiverAutoCompleteData.value.textField.text = selectedData.name;
    AutoCompleteDropDownTextField.removeOverlay();
    if(docId.value != ""){
      updateTransferDetails();
    }
    receiverAutoCompleteData.value.textField.text = receiverAutoCompleteData.value.selectedValue.name;
    Future.delayed(Duration(milliseconds: AutoCompleteDropDownTextField.animationTime)).then((value) {
      receiverAutoCompleteData.value.isEnableEditing = false;
      receiverAutoCompleteData.refresh();
    });

  }


}