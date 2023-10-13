import 'dart:developer';

import 'package:flutter_feathersjs/flutter_feathersjs.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/service/feather_error_model.dart';
import 'package:flutter_retail_pharmacies/core/service/network_helper.dart';
import 'package:get/get.dart';

class FeatherExceptions implements Exception {
  static Map<String, dynamic> featherExceptionsErrorHandling({required featherError}) {
    log("featherError $featherError}");
    if (featherError is FeatherJsError) {
      if (featherError.type == FeatherJsErrorType.IS_GENERAL_ERROR) {
        var errorJson = getJsonFromString(message: featherError.message);
        var errorModel = FeatherErrorModel.fromJson(errorJson);
        return errorModel.toJson();
      }else {
       return jsonDefaultFeatherError();
      }
    } else {
      return jsonDefaultFeatherError();

    }
  }

  static Map<String,dynamic> jsonDefaultFeatherError(){
    final errorModel = FeatherErrorModel(
        code: 404, message: AppStrings.somethingWentWrong.tr);
    return errorModel.toJson();
  }
}
