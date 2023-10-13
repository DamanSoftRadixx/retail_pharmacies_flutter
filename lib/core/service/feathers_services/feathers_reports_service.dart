import 'dart:developer';

import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/service/feather_service.dart';
import 'package:flutter_retail_pharmacies/core/service/network_helper.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:flutter_retail_pharmacies/features/organisation/model/network/response/organisation_list_response_model.dart';
import 'package:flutter_retail_pharmacies/features/reports/model/network/stocks_response_model.dart';
import 'package:flutter_retail_pharmacies/features/reports/model/network/turnover_reports_response.dart';
import 'package:get/get.dart';

class FeathersReportsService {

  Future<StocksResponseModel?> getInventoryReportsList({
    int offset = 0, Map<String, dynamic>? filters, String? search}) async {
    try {
      Map<String, dynamic>? response = await FeathersService.shared.find(
          serviceName: "memories",
          filters: filters,
          search: search,
          context: ['warehouse','stock'],
          methodName: "getReportsList",
          offset: offset
      );

      int statusCode = response?["code"] ?? 404;
      String statusMessage = response?["message"] ?? AppStrings.somethingWentWrong.tr;

      // log("getReportsListJson : ${response}");

      if(statusCode == 200){
        var data = StocksResponseModel.fromJson(response);
        responseLog(response: data, methodName: "getInventoryReportsList");
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

  Future<TurnoverReportsResponse?> getTurnOverReportsList({
    int offset = 0, Map<String, dynamic>? filters, String? search}) async {

    // filter: {storage: "uuid", goods: "uuid", batch_id: "uuid", batch_date: "2023-08-01", dates: {from: "2023-01-01", till: "2023-08-30"}}

    try {
      Map<String, dynamic>? response = await FeathersService.shared.find(
          serviceName: "inventory",
          filters: filters,
          search: search,
          context: [],
          methodName: "getTurnOverReportsList",
          offset: offset
      );

      int statusCode = response?["code"] ?? 404;
      String statusMessage = response?["message"] ?? AppStrings.somethingWentWrong.tr;

      if(statusCode == 200){
        var data = TurnoverReportsResponse.fromJson(response);
        responseLog(response: data, methodName: "getTurnOverReportsList");
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


