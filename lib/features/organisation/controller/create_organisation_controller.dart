import 'package:flutter/cupertino.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/service/feathers_services/feathers_organisation_service.dart';
import 'package:flutter_retail_pharmacies/features/organisation/model/network/common/organisation_data.dart';
import 'package:flutter_retail_pharmacies/features/organisation/model/network/response/organisation_list_response_model.dart';
import 'package:get/get.dart';

class CreateOrganisationController extends GetxController {
  FeathersOrganisationService feathersOrganisationService =
      FeathersOrganisationService();

  //Organization Dialog Variables
  var organisationNameTextField = TextEditingController().obs;
  var organisationAddressTextField = TextEditingController().obs;
  var organisationNameFocusNode = FocusNode().obs;
  var organisationAddressFocusNode = FocusNode().obs;
  var errorString = "".obs;
  var isOpenOrganisationDialog = false.obs;
  var isShowLoader = false.obs;
  var organisationList = <OrganisationData>[].obs;
  OrganisationData? selectedOrganisation;


  showLoader({required bool value}) {
    isShowLoader.value = value;
    isShowLoader.refresh();
  }

  onPressAddOrganisationDoneButton() {
    if (organisationNameTextField.value.text.isEmpty) {
      errorString.value = AppStrings.pleaseEnterName.tr;
    } else if (organisationAddressTextField.value.text.isEmpty) {
      errorString.value = AppStrings.pleaseEnterAdress.tr;
    } else {
      errorString.value = "";
    }

    errorString.refresh();

    if (errorString.isEmpty) {
      isOpenOrganisationDialog.value = false;
      organisationNameTextField.refresh();
      hitCreateOrganisationApi();
    }
  }

  onPressNameTextFieldChangedButton() {
   /* errorString.value = "";
    errorString.refresh();*/
  }

  onPressAddressTextFieldChangedButton() {
    /*errorString.value = "";
    errorString.refresh();*/
  }

  hitCreateOrganisationApi() async {
    showLoader(value: true);

    try {
      OrganisationData? response =
          await feathersOrganisationService.createOrganisation(requestData: {
        "organisation_name": organisationNameTextField.value.text,
        "organisation_address": organisationAddressTextField.value.text
      });
      if(response != null){
        selectedOrganisation = response!;
      }
      showLoader(value: false);
      Get.back();
      if (response != null) {}
    } catch (e) {
      showLoader(value: false);
      Get.back();
    }
  }

  clearAllFields(){
    organisationNameTextField.value.text = "";
    organisationAddressTextField.value.text = "";
    errorString.value = "";
  }



  Future<OrganisationListResponseModel?> getOrganisationListApi({
    int offset = 0, Map<String, dynamic>? filters, String? search,bool isFromPagination = false}) async {
    try {
      OrganisationListResponseModel? response =
      await feathersOrganisationService.getOrganisationsList(filters: filters,offset: offset, search: search);
      if (response != null) {
        if(isFromPagination){
          organisationList.addAll(response.data ?? []);
        }else{
          organisationList.value = response.data ?? [];
        }

        organisationList.refresh();

        return response;
      }
    } catch (e) {
      showLoader(value: false);
    }
  }

}
