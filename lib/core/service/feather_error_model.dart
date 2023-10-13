import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class FeatherErrorModel {
  FeatherErrorModel({
      this.className, 
      this.code, 
      this.message, 
      this.name,});

  FeatherErrorModel.fromJson(dynamic json) {
    className = json['className'].toString().toStringConversion();
    code = json['code'].toString().toIntConversion();
    message = json['message'].toString().toStringConversion();
    name = json['name'].toString().toStringConversion();
  }
  String? className;
  int? code;
  String? message;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['className'] = className;
    map['code'] = code;
    map['message'] = message;
    map['name'] = name;
    return map;
  }

}