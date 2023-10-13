import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class SignUpResponseModel {

  SignUpResponseModel({
      this.id, 
      this.accessToken, 
      this.email,this.code,this.message});

  SignUpResponseModel.fromJson(dynamic json) {
    id = json['_id'].toString().toStringConversion();
    accessToken = json['accessToken'].toString().toStringConversion();
    email = json['email'].toString().toStringConversion();

    if(accessToken != null && accessToken != ""){
      code = 200;
    }else{
      code = json['code'].toString().toIntConversion();
    }
    message = json['message'].toString().toStringConversion();
  }
  String? id;
  String? accessToken;
  String? email;
  int? code;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['accessToken'] = accessToken;
    map['email'] = email;
    map['code'] = code;
    map['message'] = message;
    return map;
  }

}