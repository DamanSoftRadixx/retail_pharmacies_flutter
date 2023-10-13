import 'package:flutter_retail_pharmacies/core/common_ui/textfields/autocomplete_textfield.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/models/local/dropdown_model.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/top_table_response_model.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/add_new_Transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/add_update_quantity_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/extensions/keyboard_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/organisation/dialog/create_organisation_dialog.dart';
import 'package:flutter_retail_pharmacies/features/organisation/model/network/common/organisation_data.dart';
import 'package:flutter_retail_pharmacies/features/organisation/model/network/response/organisation_list_response_model.dart';
import 'package:get/get.dart';

extension MedicineReceiptTableFunctionalityExtension
    on AddNewTransferJournalController {
  //getTopTableData function is used for api integration of top time table
  getTopTableData({bool isShowLoader = true, bool isClearList = true}) async {
    if (isShowLoader) showTopTableLoader(true);

    if (isClearList) {
      offsetCountTop.value = 0;
      isPaginationEndTop.value = false;
    }

    TopTableResponseModel? topTableListModel = await feathersTransferService
        .fetchTransferDetails(docId.value, offset: offsetCountTop.value);
    showTopTableLoader(false);
    if (isClearList) {
      topTableList.clear();
      totalAmount.value = 0;
      loadMoreTop.value = false;
      createdDateForMedicineReceipt.value = DateTime.now().toString();
      offsetCountTop.value = 0;
      isPaginationEndTop.value = false;
    }

    if (topTableListModel != null && topTableListModel.data!.isNotEmpty) {
      topTableListModel.data?.forEach((element) {
        topTableList.add(element);

        if (element.status?.toLowerCase().toString() !=
            CheckStatus.deleted.name) {
          totalAmount.value = totalAmount.value + (element.cost?.number ?? 0);
        }
      });
    }

    if (topTableListModel != null &&
        topTableListModel.data != null &&
        topTableListModel.data!.isEmpty) {
      isPaginationEndTop.value = true;
    }

    topTableList.refresh();
    totalAmount.refresh();
    loadMoreTop.value = false;
  }

  onTapTopTableItem({required int index}) {
    changeItemStatusToSelectedForMedicineReceiptTable(index: index);
  }

  void onDoubleTapTopTableRow({required int index}) {
    changeItemStatusToSelectedForMedicineReceiptTable(index: index);
    openQuantityPopUp();
  }

  changeItemStatusToSelectedForMedicineReceiptTable({required int index}) {
    selectedIndexTop.value = index;
    topTableFocusBool = true;
    bottomTableFocusBool = false;
    selectedIndexBottom.value = -1;
    topTableList.refresh();
    bottomTableList.refresh();
  }

  unselectTopTableRow() {
    topTableFocusBool = false;
    selectedIndexTop.value = -1;
    topTableList.refresh();
  }

  onPressCancelReceipt() {}
  Future onPressSenderTextFieldCloseButton() async {
    var selectedReceiverId =
        senderAutoCompleteData.value.selectedValue.uuid ?? "";

    if (selectedReceiverId.isNotEmpty) {
      senderAutoCompleteData.value.textField.text = "";
      senderAutoCompleteData.value.selectedValue = OrganisationData();
      senderAutoCompleteData.refresh();
      updateTransferDetails();
    } else {
      senderAutoCompleteData.value.textField.text = "";
      senderAutoCompleteData.value.selectedValue = OrganisationData();
      senderAutoCompleteData.refresh();
    }

    if (senderAutoCompleteData.value.isEnableEditing) {
      await onChangedSenderTextField(
          value: senderAutoCompleteData.value.textField.text);
    }

    return true;
  }

  void onTapPlusIcon({required TransferPartyEnum transferType}) async {
    if (transferType == TransferPartyEnum.sender) {
      createOrganisationController.selectedOrganisation =
          senderAutoCompleteData.value.selectedValue;
    } else if (transferType == TransferPartyEnum.receiver) {
      createOrganisationController.selectedOrganisation =
          receiverAutoCompleteData.value.selectedValue;
    }
    await CreateOrganizationDialog().createOrganizationDialog();
    if (transferType == TransferPartyEnum.sender &&
        senderAutoCompleteData.value.selectedValue !=
            createOrganisationController.selectedOrganisation) {
      senderAutoCompleteData.value.selectedValue =
          createOrganisationController.selectedOrganisation ??
              OrganisationData();
      senderAutoCompleteData.value.textField.text =
          senderAutoCompleteData.value.selectedValue.name ?? "";
      senderAutoCompleteData.refresh();

      if (docId.value.isNotEmpty) {
        updateTransferDetails();
      }
    } else if (transferType == TransferPartyEnum.receiver &&
        receiverAutoCompleteData.value.selectedValue !=
            createOrganisationController.selectedOrganisation) {
      receiverAutoCompleteData.value.selectedValue =
          createOrganisationController.selectedOrganisation ??
              OrganisationData();
      receiverAutoCompleteData.value.textField.text =
          receiverAutoCompleteData.value.selectedValue.name ?? "";
      receiverAutoCompleteData.refresh();
      if (docId.value.isNotEmpty) {
        updateTransferDetails();
      }
    }
  }

  Future<List<OrganisationData>> getOrganisationList(
      {bool isFromPagination = false, int? offset, String? searchText}) async {
    var organisationList = <OrganisationData>[];

    OrganisationListResponseModel? response =
        await createOrganisationController.getOrganisationListApi(
            search: searchText ?? "",
            offset: offset ?? 0,
            isFromPagination: isFromPagination);
    if (response != null) {
      var responseList = response?.data ?? [];
      organisationList = responseList;
    }
    return organisationList;
  }

  void onTapSearchIcon({required TransferPartyEnum transferType}) {}

  Future<List<DropDownModel>> onChangedSenderTextField(
      {required String value}) async {
    senderAutoCompleteData.value.isEnableEditing = true;
    senderAutoCompleteData.value.loadMore = false;
    senderAutoCompleteData.value.isPaginationEnd = false;
    senderAutoCompleteData.value.offsetCount = 0;
    senderAutoCompleteData.value.isShowLoader = true;
    senderAutoCompleteData.value.currentIndex = -1;
    senderAutoCompleteData.refresh();

    var response = await getOrganisationList(
        searchText: senderAutoCompleteData.value.textField.text);
    senderAutoCompleteData.value.autoCompleteList = response;
    senderAutoCompleteData.value.isShowLoader = false;
    senderAutoCompleteData.refresh();

    return [];
  }

  void onTapSenderListItem({required int index}) {
    senderAutoCompleteData.value.focusNode.requestFocus();
    senderAutoCompleteData.value.currentIndex = index;
    senderAutoCompleteData.refresh();
  }

  void onDoubleTapSenderListItem({required int index}) {
    senderAutoCompleteData.value.currentIndex = index;
    senderAutoCompleteData.refresh();
    senderSelectAutoCompleteItem();
  }

  void onTapReceiverListItem({required int index}) {
    receiverAutoCompleteData.value.focusNode.requestFocus();
    receiverAutoCompleteData.value.currentIndex = index;
    receiverAutoCompleteData.refresh();
  }

  void onDoubleTapReceiverListItem({required int index}) {
    receiverAutoCompleteData.value.currentIndex = index;
    receiverAutoCompleteData.refresh();
    receiverSelectAutoCompleteItem();
  }

  Future<List<DropDownModel>> onChangedReceiverTextField(
      {required String value}) async {
    receiverAutoCompleteData.value.isEnableEditing = true;
    receiverAutoCompleteData.value.loadMore = false;
    receiverAutoCompleteData.value.isPaginationEnd = false;
    receiverAutoCompleteData.value.offsetCount = 0;
    receiverAutoCompleteData.value.isShowLoader = true;
    receiverAutoCompleteData.refresh();

    var response = await getOrganisationList(
        searchText: receiverAutoCompleteData.value.textField.text);
    receiverAutoCompleteData.value.autoCompleteList = response;
    receiverAutoCompleteData.value.isShowLoader = false;
    receiverAutoCompleteData.refresh();

    return [];
  }

  Future onPressReceiverTextFieldCloseButton() async {
    var selectedReceiverId =
        receiverAutoCompleteData.value.selectedValue.uuid ?? "";

    if (selectedReceiverId.isNotEmpty) {
      receiverAutoCompleteData.value.textField.text = "";
      receiverAutoCompleteData.value.selectedValue = OrganisationData();
      updateTransferDetails();
    } else {
      receiverAutoCompleteData.value.textField.text = "";
      receiverAutoCompleteData.value.selectedValue = OrganisationData();
      receiverAutoCompleteData.refresh();
    }

    if (receiverAutoCompleteData.value.isEnableEditing) {
      await onChangedReceiverTextField(
          value: receiverAutoCompleteData.value.textField.text);
    }

    return true;
  }
}
