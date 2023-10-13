import 'dart:convert';
import 'dart:developer';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/search_list_response_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/time_table_response_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/top_table_response_model.dart';
import 'package:flutter_retail_pharmacies/core/service/connection_data.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:get/get.dart';

class FeathersCheckService {
  Future<TimeTableData?> createCheckDoc(CheckCreationRequestModel checkCreationModel) async {
    try {
      Map<String, dynamic> reqData = jsonDecode(checkCreationModelToJson(
          CheckCreationRequestModel(
            createdAt: DateTime.now().toString(),
            status: CheckStatus.draft.name,
            date: getDateForApi(date: DateTime.now().toString()),

          )));
      Map<String, dynamic> response = await Api.feathers().create(serviceName: "memories", data: reqData, params: {
        "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
        "ctx": const ['warehouse', 'dispatch', 'document'],
      });

      var data = TimeTableData.fromJson(response);
      String jsonUser = jsonEncode(data);
      print("********************** createCheckDoc response start **********************");
      print(jsonUser);
      print("********************** createCheckDoc response end **********************");
      return data;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          isHideCancel: true,
          message: AppStrings.somethingWentWrong.tr);
    }
  }
  Future<TimeTableResponseModel?> getTimeDataList({int offset = 0, Map<String, dynamic>? filters}) async {

    var query = {
      "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
      "ctx": const ['warehouse', 'dispatch', 'document'],
      "\u0024skip": offset,
    };

    if (filters != null) {
      query["filter"] = filters;
    }

    print("getTimeDataList query : ${query}");

    try {
      Map<String, dynamic> response = await Api.feathers().find(serviceName: "memories", query: query);

      log("getTimeDataListdfdsfdsdfds ${jsonEncode(response)}");

      var data = TimeTableResponseModel.fromJson(response);
      String jsonUser = jsonEncode(data);
      print("********************** getTimeDataList response start **********************");
      print(jsonUser);
      print("response $response");
      print("********************** getTimeDataList response end **********************");
      return data;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          isHideCancel: true,
          message: AppStrings.somethingWentWrong.tr);
    }
  }
  Future createCheckLine(Map<String, dynamic> data) async {
    try {
      Map<String, dynamic> response = await Api.feathers().create(serviceName: "memories", data: data, params: {
        "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
        "ctx": const ['warehouse', 'dispatch'],
      });

      print("createNewEntryInSelectedTopTable response >>>>>>>$response");
      return response;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          isHideCancel: true,
          message: AppStrings.somethingWentWrong.tr);
    }
  }
  Future<Map<String, dynamic>?> patchMethodForCheckJournalTableEntry(Map<String, dynamic> data, String goodId) async {
    // good id is the uuid of the selected goods.
    try {
      Map<String, dynamic> response = await Api.feathers().patch(
          serviceName: "memories",
          data: data,
          params: {
            "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
            "ctx": const ['warehouse', 'dispatch'],
          },
          objectId: goodId);

      print("patchMethodForTopTable response >>>>>>>$response");
      return response;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          isHideCancel: true,
          message: AppStrings.somethingWentWrong.tr);
    }
  }
  Future<Map<String, dynamic>?> patchMethodForCheckTabs(Map<String, dynamic> data, String id) async {
    try {
      Map<String, dynamic> response = await Api.feathers().patch(
          serviceName: "memories",
          params: {
            "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
            "ctx": const ['warehouse', 'dispatch', 'document'],
          },
          data: data,
          objectId: id);

      print("patchMethodForCheckTabs response >>>>>>>$response");
      return response;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          isHideCancel: true,
          message: AppStrings.somethingWentWrong.tr);
    }
  }
  createCheckLineUpdate(Map<String, dynamic> data, id) async {
    try {
      Map<String, dynamic> response = await Api.feathers().update(
          serviceName: "memories",
          data: data,
          params: {
            "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
            "ctx": const ['warehouse', 'dispatch'],
          },
          objectId: '$id');

      print("createCheckLineUpdate response >>>>>>>$response");
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          isHideCancel: true,
          message: AppStrings.somethingWentWrong.tr);
    }
  }
  Future<TopTableResponseModel?> findCheckLine(String docId, {int offset = 0}) async {
    log("findCheckLine $docId, offset : ${offset}");

    try {
      var response = await Api.feathers().find(serviceName: "memories", query: {
        "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
        "ctx": const ['warehouse', 'dispatch'],
        "filter": {
          "document": docId,
        },
        "\u0024skip": offset
      });
      print(response);
      var data = TopTableResponseModel.fromJson(response);
      String jsonUser = jsonEncode(data);
      print("********************** findCheckLine response sstart **********************");
      print(jsonUser);
      print("********************** findCheckLine response end **********************");
      return data;
    } catch (e, s) {
      print("Exception $e");
      print("StackTrace $s");
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
          },
          isHideCancel: true,
          message: AppStrings.somethingWentWrong.tr);
    }
  }
}
