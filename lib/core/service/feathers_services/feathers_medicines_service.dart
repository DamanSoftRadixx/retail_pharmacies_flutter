import 'dart:convert';
import 'dart:developer';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/models/response/search_list_response_model.dart';
import 'package:flutter_retail_pharmacies/core/service/connection_data.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:get/get.dart';

class FeathersMedicineService {
  Future<SearchListResponseModel?> getSearchData(String search, int offset) async {
    print("search request : $search, offset : $offset");

    try {
      Map<String, dynamic> response = await Api.feathers().find(serviceName: "memories", query: {
        "oid": "yjmgJUmDo_kn9uxVi8s9Mj9mgGRJISxRt63wT46NyTQ",
        "ctx": const ['drugs'],
        "search": search,
        "\u0024skip": offset
      });

      var data = SearchListResponseModel.fromJson(response);
      data.status = 200;
      String jsonUser = jsonEncode(data);
      print("********************** getSearchData response start **********************");
      print(jsonUser);
      print("********************** getSearchData response end **********************");
      log("getSearchData $jsonUser");
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


