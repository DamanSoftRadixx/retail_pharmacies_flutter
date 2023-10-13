import 'dart:convert';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/service/connection_data.dart';
import 'package:flutter_retail_pharmacies/core/service/feather_error_model.dart';
import 'package:flutter_retail_pharmacies/core/service/feather_exceptions.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:get/get.dart';

//Singleton class
class FeathersService {
  static final FeathersService shared = FeathersService._internal();

  factory FeathersService() {
    return shared;
  }

  FeathersService._internal();

  Future<Map<String, dynamic>?> create(
      {required String serviceName,
      required Map<String, dynamic> data,
      required List<String> context,
      required String methodName}) async {
    try {
      print("${methodName} context : ${context}, req : ${data}");

      Map<String, dynamic>? response = await Api.feathers()
          .create(serviceName: serviceName, data: data, params: {
        "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
        "ctx": context,
      });
      print("DirectResponse(${methodName}) : ${response}");
      if (response != null) {
        response?["code"] = 200;
        response?["message"] = AppStrings.success.tr;
        return response;
      } else {
        return FeatherExceptions.jsonDefaultFeatherError();
      }
    } catch (e, s) {
      FeatherExceptions.featherExceptionsErrorHandling(featherError: e);
    }
  }

  Future<Map<String, dynamic>?> find(
      {required String serviceName,
      int offset = 0,
      Map<String, dynamic>? filters,
      String? search,
      required List<String> context,
      required String methodName}) async {
    try {
      var query = {
        "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
        "\u0024skip": offset,
      };

      if (context.isNotEmpty) {
        query["ctx"] = context;
      }

      if (filters != null) {
        query["filter"] = filters;
      }

      if (search != null) {
        query["search"] = search;
      }

      print("${methodName} context : ${context}, req : ${query}");

      Map<String, dynamic>? response =
          await Api.feathers().find(serviceName: serviceName, query: query);
      print("DirectResponse(${methodName}) : ${response}");
      if (response != null) {
        response?["code"] = 200;
        response?["message"] = AppStrings.success.tr;
        return response;
      } else {
        return FeatherExceptions.jsonDefaultFeatherError();
      }
    } catch (e, s) {
      FeatherExceptions.featherExceptionsErrorHandling(featherError: e);
    }
  }
}
