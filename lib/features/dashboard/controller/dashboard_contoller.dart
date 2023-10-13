import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/common_fucntionality/chage_language.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/autocomplete_textfield.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/local_library/scroll_to_index.dart';
import 'package:flutter_retail_pharmacies/core/models/common/quantity_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/search_list_response_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/time_table_response_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/top_table_response_model.dart';
import 'package:flutter_retail_pharmacies/core/service/feathers_services/feathers_check_service.dart';
import 'package:flutter_retail_pharmacies/core/service/feathers_services/feathers_medicines_service.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/add_new_Transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/screens/extensions/transfer_detail_dialog_extension.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/keyboard_handing_functionality.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/search_field_fucntionailty.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/top_table_functionality.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/payment_dialog.dart';
import 'package:flutter_retail_pharmacies/features/settings/screen/settings_screen.dart';
import 'package:get/get.dart';

// DashboardController is used for handling all the functionality part of our dashboard screen.
class DashboardController extends GetxController {
  //feathers is a service class which we have use for api integration
  FeathersCheckService feathersCheckService = FeathersCheckService();
  FeathersMedicineService feathersMedicinesService = FeathersMedicineService();

  // TextFieldControllers - used for read  and update the user inputs in the texfields
  final quantityTextController = TextEditingController();

  var summaTextController = TextEditingController(text: "0.00");
  TextEditingController searchTextEditingController = TextEditingController();
  TextEditingController partialQuantityTextEditingController =
      TextEditingController();

  //AutoScrollController - used to scroll the table at particular index
  AutoScrollController bottomListScrollController = AutoScrollController();
  AutoScrollController topListScrollController = AutoScrollController();
  AutoScrollController timeListScrollController = AutoScrollController();

  //TextFieldFocusNode - used to focus or unfocus the input fields.
  FocusNode quantityFocusNode = FocusNode();
  FocusNode summaFocusNode = FocusNode();
  FocusNode searchFocusNode = FocusNode();
  FocusNode partialQuantityFocusNode = FocusNode();

  //Below variables are used tp hold the selected index of listviews
  RxInt selectedIndexBottom = (-1).obs;
  RxInt selectedIndexTop = (-1).obs;
  RxInt selectedTimeTable = (0).obs;

  //Below list variables holds the data from the feather apis
  RxList<SearchData> bottomTableList = <SearchData>[].obs;
  RxList<TopTableData> topTableList = <TopTableData>[].obs;
  RxList<TimeTableData> timeTableList = <TimeTableData>[].obs;

  //Below variables are used to track the currently focused table
  bool topTableFocusBool = false;
  bool bottomTableFocusBool = false;

  //isQuantityPopupBool is used to hide/show the AddQuantity popup
  RxBool isQuantityPopupBool = false.obs;
  RxBool isShowErrorForQuantityPopUp = false.obs;
  var countPerQuantity = "10";

  //docsId is used for api integration of top table
  RxString docsId = "".obs;

  //Below variables are used to show data on the receipt
  RxInt totalAmount = 0.obs; //Used for showing amount of receipt
  RxString checkCreatedDate =
      DateTime.now().toString().obs; //Used for showing amount of receipt
  RxInt discount = 0.obs; //Used for showing discount amount of card receipt
  RxInt totalPayableAmountWithDiscount =
      0.obs; //Used for showing grandTotal amount of card receipt

  //isEnabledUpDownKey variable used to create the delay, between the up,down and left, right arrow keys.
  bool isEnabledUpDownKey = true;

  //Below variables are used to implement the pagination functionality
  RxBool loadMoreBottom = false.obs;
  RxInt totalNumberOfRecordBottom = 0.obs;
  RxInt offsetCountBottom = 0.obs;
  final paginationLengthBottom = 10;

  //Below variables are used to implement the pagination functionality
  RxBool loadMoreTime = false.obs;
  RxBool isPaginationEndTime = false.obs;
  RxInt offsetCountTime = 0.obs;
  final paginationLengthTime = 10;

  //Below variables are used to implement the pagination functionality
  RxBool loadMoreTop = false.obs;
  RxBool isPaginationEndTop = false.obs;
  RxInt offsetCountTop = 0.obs;
  final paginationLengthTop = 10;

  //Payment dialog variables
  RxBool isValidPaymentAmount = true.obs;
  RxBool isPaymentDialogOpen = false.obs;
  var paymentDialogModel = PaymentDialogModel(totalPaybleAmount: "0").obs;
  var selectedPaymentMethod = PaymentMethod.none.obs;
  //loaders to wait the socket data
  var showTopTableLoader = false.obs;

  //check if Partial Quantity more than value
  RxBool isPartialQuantityError = false.obs;

  //Is Show  check ui

  // RxBool isShowCheckUi = false.obs;
  var isCtrlPressing = false;
  var selectedLeftPanelTab = LeftPanelTabs.dashboard.obs;
  var selectedRightPanelTab = RightPanelTabs.none.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("DashboardController onInit");
    changeLanguage();


    addListenersToPaymentDialogFocusNodes();
    initAutoScrollControllers();
    // keyboard listener function is used for keyboard functionality.
    keyboardListenerHandler();

    //getTimeListingApiIntegration function is used for api integration of time table
    getTimeListingApiIntegration().whenComplete(() {
      //getTopTableData function is used for api integration of top time table
      if (timeTableList.isNotEmpty) {
        getTopTableData();
      }
    });
  }

  addListenersToPaymentDialogFocusNodes() {
    paymentDialogModel.value.cashFocusNode.addListener(() {});
    paymentDialogModel.value.uzCardFocusNode.addListener(() {});
    paymentDialogModel.value.humoFocusNode.addListener(() {});
    paymentDialogModel.value.otherFocusNode.addListener(() {});
  }

  removeListenersToPaymentDialogFocusNodes() {
    paymentDialogModel.value.cashFocusNode.removeListener(() {});
    paymentDialogModel.value.uzCardFocusNode.removeListener(() {});
    paymentDialogModel.value.humoFocusNode.removeListener(() {});
    paymentDialogModel.value.otherFocusNode.removeListener(() {});
  }

  void bottomTablePagination() {
    if ((bottomListScrollController.position.pixels ==
        bottomListScrollController.position.maxScrollExtent)) {
      print("end of the table");
      if (totalNumberOfRecordBottom.value > offsetCountBottom.value &&
          !(loadMoreBottom.value)) {
        loadMoreBottom.value = true;
        offsetCountBottom.value += paginationLengthBottom;
        print("offsetCount.value<<<<${offsetCountBottom.value}");
        searchApiIntegration();
      }
    }
  }

  void timeTablePagination() {
    if ((timeListScrollController.position.pixels ==
        timeListScrollController.position.maxScrollExtent)) {
      print("isPaginationEndTime : ${isPaginationEndTime}");
      if (isPaginationEndTime.isFalse && !(loadMoreTime.value)) {
        loadMoreTime.value = true;
        offsetCountTime.value += paginationLengthTime;
        print("offsetCount.value<<<<${offsetCountTime.value}");
        getTimeListingApiIntegration(isShowLoader: false, isClearList: false);
      }
    }
  }

  void topTablePagination() {
    if ((topListScrollController.position.pixels ==
        topListScrollController.position.maxScrollExtent)) {
      print("isPaginationEndTop : ${isPaginationEndTop}");
      if (isPaginationEndTop.isFalse && !(loadMoreTop.value)) {
        loadMoreTop.value = true;
        offsetCountTop.value += paginationLengthTop;
        print("offsetCount.value<<<<${offsetCountTop.value}");
        getTopTableData(isClearList: false, isShowLoader: false);
      }
    }
  }

  initAutoScrollControllers() {
    bottomListScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, Get.mediaQuery.padding.bottom),
        axis: Axis.vertical);

    topListScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, Get.mediaQuery.padding.bottom),
        axis: Axis.vertical);

    timeListScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, Get.mediaQuery.padding.bottom),
        axis: Axis.horizontal);

    bottomListScrollController.addListener(() {
      bottomTablePagination();
    });

    timeListScrollController.addListener(() {
      timeTablePagination();
    });

    topListScrollController.addListener(() {
      topTablePagination();
    });
  }

  Future scrollToIndex(
      {required int index, required AutoScrollController controller}) async {
    isEnabledUpDownKey = false;
    await controller.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);
    isEnabledUpDownKey = true;
  }

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
    var quantity = qtyList.firstWhereOrNull(
        (element) => element.uom?.id == QuantityTypes.pkg.name);
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

  setCurrentLeftPanelTab({required LeftPanelTabs currentTab}) {

    selectedLeftPanelTab.value = currentTab;
    selectedRightPanelTab.value = RightPanelTabs.none;
    selectedLeftPanelTab.refresh();
  }

  setCurrentRightPanelTab({required RightPanelTabs currentTab}) {
    selectedRightPanelTab.value = currentTab;
    selectedRightPanelTab.refresh();
  }

  void onPressAddNewTransferButton() {
    var addNewTransferController = Get.put(AddNewTransferJournalController());
    addNewTransferController.docId.value = "";
    // addNewTransferController.senderReceiverDetailDialog();

    setCurrentRightPanelTab(currentTab: RightPanelTabs.addNewTransferJournal);
  }

  void onPressTransferDoneButton() async {
    var addNewTransferController = Get.find<AddNewTransferJournalController>();

    if (addNewTransferController.isValidTransferData()) {
      await addNewTransferController.updateTransferStatusToSend();
      setCurrentRightPanelTab(currentTab: RightPanelTabs.none);
    }
  }

  onTapAnywhereOnTheScreen(){
    if(Get.isRegistered<AddNewTransferJournalController>()){
      var addNewTransferJournalController = Get.find<AddNewTransferJournalController>();
      Future.delayed(Duration(milliseconds: AutoCompleteDropDownTextField.animationTime)).then((value){
        if(addNewTransferJournalController.senderAutoCompleteData.value.isEnableEditing){
          addNewTransferJournalController.senderAutoCompleteData.value.isEnableEditing = false;
          addNewTransferJournalController.senderAutoCompleteData.value.textField.text = addNewTransferJournalController.senderAutoCompleteData.value.selectedValue.organisationAddress ?? "";
          addNewTransferJournalController.senderAutoCompleteData.refresh();

        }
        if(addNewTransferJournalController.receiverAutoCompleteData.value.isEnableEditing){
          addNewTransferJournalController.receiverAutoCompleteData.value.isEnableEditing = false;
          addNewTransferJournalController.receiverAutoCompleteData.value.textField.text = addNewTransferJournalController.receiverAutoCompleteData.value.selectedValue.organisationAddress ?? "";
          addNewTransferJournalController.receiverAutoCompleteData.refresh();


        }
      });
      AutoCompleteDropDownTextField.removeOverlay();
    }
  }

  void onPressSettingsButton(){
    Get.dialog(
        SettingsScreen(),
        barrierDismissible: true);
  }

  void releaseResources() {
    print("DashboardController dispose");
    ServicesBinding.instance.keyboard.removeHandler(onAddCheckJournalKeyPressed);
  }

  @override
  void onClose() {
    releaseResources();
    super.onClose();
  }

  @override
  void dispose() {
    releaseResources();
    removeListenersToPaymentDialogFocusNodes();
    super.dispose();
  }
}
