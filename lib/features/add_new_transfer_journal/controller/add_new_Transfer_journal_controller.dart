import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/local_library/scroll_to_index.dart';
import 'package:flutter_retail_pharmacies/core/models/local/auto_complete_textfield_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/search_list_response_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/top_table_response_model.dart';
import 'package:flutter_retail_pharmacies/core/service/feathers_services/feathers_medicines_service.dart';
import 'package:flutter_retail_pharmacies/core/service/feathers_services/feathers_transfer_service.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/pagination_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/model/transfer_check_creation_model.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:flutter_retail_pharmacies/features/organisation/controller/create_organisation_controller.dart';
import 'package:flutter_retail_pharmacies/features/organisation/model/network/common/organisation_data.dart';
import 'package:get/get.dart';

class AddNewTransferJournalController extends GetxController {

  //feathers is a service class which we have use for api integration
  FeathersTransferService feathersTransferService = FeathersTransferService();
  FeathersMedicineService feathersMedicineService = FeathersMedicineService();

  // TextFieldControllers - used for read  and update the user inputs in the texfields
  final quantityTextController = TextEditingController();

  var summaTextController = TextEditingController(text: "0.00");
  TextEditingController searchTextEditingController = TextEditingController();
  TextEditingController partialQuantityTextEditingController =
  TextEditingController();

  //AutoScrollController - used to scroll the table at particular index
  AutoScrollController bottomListScrollController = AutoScrollController();
  AutoScrollController topListScrollController = AutoScrollController();

  //TextFieldFocusNode - used to focus or unfocus the input fields.
  FocusNode quantityFocusNode = FocusNode();
  FocusNode summaFocusNode = FocusNode();
  FocusNode searchFocusNode = FocusNode();
  FocusNode partialQuantityFocusNode = FocusNode();

  //Below variables are used tp hold the selected index of listviews
  RxInt selectedIndexBottom = (-1).obs;
  RxInt selectedIndexTop = (-1).obs;

  //Below list variables holds the data from the feather apis
  RxList<SearchData> bottomTableList = <SearchData>[].obs;
  RxList<TopTableData> topTableList = <TopTableData>[].obs;

  //Below variables are used to track the currently focused table
  bool topTableFocusBool = false;
  bool bottomTableFocusBool = false;

  //isQuantityPopupBool is used to hide/show the AddQuantity popup
  RxBool isQuantityPopupBool = false.obs;
  RxBool isShowErrorForQuantityPopUp = false.obs;
  var countPerQuantity = "10";

  //Below variables are used to show data on the receipt
  RxInt totalAmount = 0.obs; //Used for showing amount of receipt
  RxString createdDateForMedicineReceipt = DateTime.now().toString().obs;

  //isEnabledUpDownKey variable used to create the delay, between the up,down and left, right arrow keys.
  bool isEnabledUpDownKey = true;

  //Below variables are used to implement the pagination functionality
  RxBool loadMoreBottom = false.obs;
  RxInt totalNumberOfRecordBottom = 0.obs;
  RxInt offsetCountBottom = 0.obs;
  final paginationLengthBottom = 10;

  //Below variables are used to implement the pagination functionality
  RxBool loadMoreTop = false.obs;
  RxBool isPaginationEndTop = false.obs;
  RxInt offsetCountTop = 0.obs;
  final paginationLengthTop = 10;

  //Payment dialog variables
  RxBool isValidPaymentAmount = true.obs;

  //loaders to wait the socket data
  var showTopTableLoader = false.obs;

  //check if Partial Quantity more than value
  RxBool isPartialQuantityError = false.obs;

  var docId = "".obs;
  var id = "".obs;


  //Sender/Receiver
  // var selectedSenderData = OrganisationData().obs;
  // var selectedReceiverData = OrganisationData().obs;
/*  var isEditSenderAddress = false.obs;
  var isEditReceiverAddress = false.obs;*/

  //Organization Dialog
  var createOrganisationController = Get.put(CreateOrganisationController());
  var isOpenOrganisationDetailsDialog = false.obs;

  var isShowLoader = false.obs;
  var errorString = "".obs;

  //Autocomplete textfield
  var senderAutoCompleteData = AutoCompleteTextFieldModel<OrganisationData>(
      textField: TextEditingController(),
      focusNode: FocusNode(),
      isShowLoader: false,
      selectedValue: OrganisationData(),
      autoCompleteList: [],
      currentIndex: -1,
      isEnableEditing: false,
      scrollController: AutoScrollController(),
    isPaginationEnd: false,
    loadMore: false,
    offsetCount: 0,
    paginationLength: 10
  ).obs;

  var receiverAutoCompleteData = AutoCompleteTextFieldModel<OrganisationData>(
      textField: TextEditingController(),
      focusNode: FocusNode(),
      selectedValue: OrganisationData(),
      isShowLoader: false,
      autoCompleteList: [],
      currentIndex: -1,
      scrollController: AutoScrollController(),
      isPaginationEnd: false,
      loadMore: false,
      isEnableEditing: false,
      offsetCount: 0,
      paginationLength: 10
  ).obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("AddNewTransferJournalController onInit");
    initAutoScrollControllers();
    addFocusListeners();
  }

  showLoader({required bool value}) {
    isShowLoader.value = value;
    isShowLoader.refresh();
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

    bottomListScrollController.addListener(() {
      bottomTablePagination();
    });
    topListScrollController.addListener(() {
      topTablePagination();
    });


    senderAutoCompleteData.value.scrollController.addListener(() {
      senderPagination();
    });

    receiverAutoCompleteData.value.scrollController.addListener(() {
      receiverPagination();
    });

  }


  addFocusListeners() {
    senderAutoCompleteData.value.focusNode.addListener(() {

      if(senderAutoCompleteData.value.focusNode.hasFocus){
        senderAutoCompleteData.value.textField.selection = TextSelection(baseOffset: 0, extentOffset: senderAutoCompleteData.value.textField.value.text.length);
      }

      print("sender focus : ${senderAutoCompleteData.value.focusNode.hasFocus}");
      senderAutoCompleteData.refresh();

    });
    receiverAutoCompleteData.value.focusNode.addListener(() {
      if(receiverAutoCompleteData.value.focusNode.hasFocus){
        receiverAutoCompleteData.value.textField.selection = TextSelection(baseOffset: 0, extentOffset: receiverAutoCompleteData.value.textField.value.text.length);
      }
      print("receiver focus : ${receiverAutoCompleteData.value.focusNode.hasFocus}");

      receiverAutoCompleteData.refresh();
    });
  }

  disposeFocusListeners() {
    senderAutoCompleteData.value.focusNode.removeListener(() {});
    receiverAutoCompleteData.value.focusNode.removeListener(() {});
  }

  Future scrollToIndex(
      {required int index, required AutoScrollController controller}) async {
    isEnabledUpDownKey = false;
    await controller.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);
    isEnabledUpDownKey = true;
  }

  updateTransferStatusToSend() async{
      showTopTableLoader(true);

      Map<String, dynamic> map = {
        "status": TransferCheckStatus.send.name,
        "sender": senderAutoCompleteData.value.selectedValue?.toJson(),
        "receiver":  receiverAutoCompleteData.value.selectedValue?.toJson(),
        "amount": totalAmount.value,
        "date": getDateForApi(date: DateTime.now().toString()),
      };

      print("Update Transfer Request: ${map}");

      await feathersTransferService
          .patchMethodForTransfer(map, id.value);
      showTopTableLoader(false);

  }

  updateTransferDetails() async{
    showTopTableLoader(true);
    Map<String, dynamic> map = {
      "status": TransferCheckStatus.draft.name,
      "sender": senderAutoCompleteData.value.selectedValue?.toJson(),
      "receiver":  receiverAutoCompleteData.value.selectedValue?.toJson(),
      // "amount": totalAmount.value,
      "date": getDateForApi(date: DateTime.now().toString()),
    };

    print("Update Transfer Request: ${map}");


    await feathersTransferService
        .patchMethodForTransfer(map, id.value);
    showTopTableLoader(false);


  }


  bool isValidTransferData(){
    if(docId.value.isEmpty){
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          isHideCancel: true,
          message: AppStrings.pleaseAddMinimumOneEntryFirst.tr);
      return false;
    }else if(senderAutoCompleteData.value.selectedValue.name.isEmpty || receiverAutoCompleteData.value.selectedValue.name.isEmpty){
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          isHideCancel: true,
          message: AppStrings.pleaseAddSenderReceiverAddressFirst.tr);
      return false;
    }
    return true;
  }

  void releaseResources() {
    print("AddNewTransferJournalController dispose");
    disposeFocusListeners();
    Get.delete<CreateOrganisationController>();
  }

  @override
  void onClose() {
    releaseResources();
    super.onClose();
  }


  @override
  void dispose() {
    releaseResources();
    super.dispose();
  }

}
