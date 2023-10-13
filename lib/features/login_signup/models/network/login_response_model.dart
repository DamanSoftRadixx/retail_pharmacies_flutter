import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class LoginResponseModel {
  LoginResponseModel({
      this.accessToken, 
      this.user,this.code,this.message});

  LoginResponseModel.fromJson(dynamic json) {
    accessToken = json['accessToken'].toString().toStringConversion();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if(accessToken != null && accessToken != ""){
      code = 200;
    }else{
      code = json['code'].toString().toIntConversion();
    }
    message = json['message'].toString().toStringConversion();
  }
  String? accessToken;
  User? user;
  int? code;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accessToken'] = accessToken;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['code'] = code;
    map['message'] = message;
    return map;
  }

}

class User {
  User({
      this.strategy, 
      this.email, 
      this.id,});

  User.fromJson(dynamic json) {
    strategy = json['strategy'].toString().toStringConversion();
    email = json['email'].toString().toStringConversion();
    id = json['_id'].toString().toStringConversion();
  }
  String? strategy;
  String? email;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['strategy'] = strategy;
    map['email'] = email;
    map['_id'] = id;
    return map;
  }

}