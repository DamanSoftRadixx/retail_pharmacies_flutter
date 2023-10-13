import 'dart:convert';
import 'dart:developer';
import 'package:flutter_feathersjs/flutter_feathersjs.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/service/connection_data.dart';
import 'package:flutter_retail_pharmacies/core/service/feather_error_model.dart';
import 'package:flutter_retail_pharmacies/core/service/network_helper.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/models/network/login_response_model.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/models/network/signup_response_model.dart';
import 'package:get/get.dart';

class FeathersAuthService {
  Future<SignUpResponseModel?> register({required String email,required String password}) async {
    try{

      var data = {
        "strategy": "local",
        "email": email.trim(),
        "password": password.trim(),
      };

      print("SignUp Request : ${data}");


      var response = await Api.feathers().create(serviceName: "users", data: data);
      print("SignUp response : ${response}");
      final authData = SignUpResponseModel.fromJson(response);
      String jsonUser = jsonEncode(authData);
      print("********************** SignUp response start **********************");
      print(jsonUser);
      print("********************** SignUp response end **********************");
      log("SignUp $jsonUser");
      return authData;
    }catch(e){
      print("SignUp : ${e.toString()}");

      if(e is FeatherJsError){
        var featherError = e as FeatherJsError;
        if(featherError.type == FeatherJsErrorType.IS_GENERAL_ERROR){
          var errorJson = getJsonFromString(message: featherError.message);
          var errorModel = FeatherErrorModel.fromJson(errorJson);
          final authData = SignUpResponseModel(code: 404,message: "${errorModel.message.toString().capitalizeFirst}.");
          return authData;
        }
      }else{
        final authData = SignUpResponseModel(code: 404,message: AppStrings.somethingWentWrong.tr);
        return authData;
      }

    }
  }

  Future<LoginResponseModel?> login({required String email,required String password}) async {
    try{

      var data = {
        "strategy": "local",
        "email": email.trim(),
        "password": password.trim(),
      };

      print("Login Request : ${data}");
      var response = await Api.feathers().create(serviceName: "authentication", data: data);
      print("Login response : ${response}");

      final authData = LoginResponseModel.fromJson(response);
      String jsonUser = jsonEncode(authData);
      print("********************** Login response start **********************");
      print(jsonUser);
      print("********************** Login response end **********************");
      log("LoginData $jsonUser");
      return authData;
    }catch(e){
      print("Login : ${e.toString()}");
      if(e is FeatherJsError){
        var featherError = e as FeatherJsError;
        if(featherError.type == FeatherJsErrorType.IS_GENERAL_ERROR){
          var errorJson = getJsonFromString(message: featherError.message);
          var errorModel = FeatherErrorModel.fromJson(errorJson);
          final authData = LoginResponseModel(code: 404,message: "${errorModel.message.toString().capitalizeFirst}.");
          return authData;
        }
      }else{
        final authData = LoginResponseModel(code: 404,message: AppStrings.somethingWentWrong.tr);
        return authData;
      }

    }
  }
}


