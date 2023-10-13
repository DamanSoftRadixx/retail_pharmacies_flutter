import 'dart:convert';
import 'dart:developer';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/models/response/top_table_response_model.dart';
import 'package:flutter_retail_pharmacies/core/service/connection_data.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/model/transfer_check_creation_model.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/model/transfer_list_response_model.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:get/get.dart';

class FeathersTransferService {

  Future<TransferListResponseModel?> getTransferList({int offset = 0, Map<String, dynamic>? filters}) async {

    var query = {
      "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
      "ctx": const ['warehouse', 'transfer', 'document'],
      "\u0024skip": offset,
    };

    if (filters != null) {
      query["filter"] = filters;
    }

    print("getTimeDataList query : ${query}");

    try {
      Map<String, dynamic> response = await Api.feathers().find(serviceName: "memories", query: query);

      log("getTimeDataListdfdsfdsdfds ${jsonEncode(response)}");

      var data = TransferListResponseModel.fromJson(response);
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

  Future<TransferData?> createTransfer(TransferCheckCreationRequestModel checkCreationModel) async {
    try {
      Map<String, dynamic> response = await Api.feathers().create(serviceName: "memories", data: checkCreationModel.toJson(), params: {
        "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
        "ctx": const ['warehouse', 'transfer', 'document'],
      });

      var data = TransferData.fromJson(response);
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

  Future<TopTableResponseModel?> fetchTransferDetails(String docId, {int offset = 0}) async {
    log("findCheckLine $docId, offset : ${offset}");

    try {
      var response = await Api.feathers().find(serviceName: "memories", query: {
        "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
        "ctx": const ['warehouse', 'transfer'],
        "filter": {
          "document": docId,
        },
        "\u0024skip": offset
      });
      print(response);
      var data = TopTableResponseModel.fromJson(response);
      String jsonUser = jsonEncode(data);
      print("********************** findCheckLine response start **********************");
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

  Future createTransferCheckLine(Map<String, dynamic> data) async {
    try {
      Map<String, dynamic> response = await Api.feathers().create(serviceName: "memories", data: data, params: {
        "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
        "ctx": const ['warehouse', 'transfer'],
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

  Future<Map<String, dynamic>?> patchMethodForTransferJournalTableEntry(Map<String, dynamic> data, String goodId) async {
    // good id is the uuid of the selected goods.
    print("document id: ${goodId}");
    try {
      Map<String, dynamic> response = await Api.feathers().patch(
          serviceName: "memories",
          data: data,
          params: {
            "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
            "ctx": const ['warehouse', 'transfer'],
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

  Future<Map<String, dynamic>?> patchMethodForTransfer(Map<String, dynamic> data, String id) async {
    print("document id: ${id}");

    try {
      Map<String, dynamic> response = await Api.feathers().patch(
          serviceName: "memories",
          params: {
            "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
            "ctx": const ['warehouse', 'transfer', 'document'],
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

}


