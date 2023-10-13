import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/service/feather_service.dart';
import 'package:flutter_retail_pharmacies/core/service/network_helper.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/model/transfer_list_response_model.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:flutter_retail_pharmacies/features/organisation/model/network/common/organisation_data.dart';
import 'package:flutter_retail_pharmacies/features/organisation/model/network/response/organisation_list_response_model.dart';
import 'package:get/get.dart';

class FeathersOrganisationService {


  Future<OrganisationData?> createOrganisation({required Map<String,dynamic> requestData}) async {
    try {
      Map<String, dynamic>? response = await FeathersService.shared.create(
          serviceName: "memories",
          data: requestData,
          context: ['location'],
        methodName: "createOrganisation"
      );

      int statusCode = response?["code"] ?? 404;
      String statusMessage = response?["message"] ?? AppStrings.somethingWentWrong.tr;

      if(statusCode == 200){
        var data = OrganisationData.fromJson(response);
        responseLog(response: data, methodName: "createOrganisation");
        return data;
      }else{
        commonDialogWidget(
            onPressOkayButton: () {
              Get.back();
            },
            isHideCancel: true,
            message: statusMessage);
      }

    } catch (e, s) {
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          isHideCancel: true,
          message: AppStrings.somethingWentWrong.tr);
    }
  }

  Future<OrganisationListResponseModel?> getOrganisationsList({
    int offset = 0, Map<String, dynamic>? filters, String? search}) async {
    try {
      Map<String, dynamic>? response = await FeathersService.shared.find(
          serviceName: "memories",
          filters: filters,
          search: search,
          context: ['location'],
          methodName: "createOrganisation",
        offset: offset
      );

      int statusCode = response?["code"] ?? 404;
      String statusMessage = response?["message"] ?? AppStrings.somethingWentWrong.tr;

      if(statusCode == 200){
        var data = OrganisationListResponseModel.fromJson(response);
        responseLog(response: data, methodName: "createOrganisation");
        return data;
      }else{
        commonDialogWidget(
            onPressOkayButton: () {
              Get.back();
            },
            isHideCancel: true,
            message: statusMessage);
      }
    } catch (e, s) {
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          isHideCancel: true,
          message: AppStrings.somethingWentWrong.tr);
    }
  }


}



