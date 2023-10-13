import 'dart:convert';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

enum CheckStatus {
  draft,
  deleted,
  payed,
  closed
}

CheckCreationRequestModel checkCreationModelFromJson(String str) =>
    CheckCreationRequestModel.fromJson(json.decode(str));

String checkCreationModelToJson(CheckCreationRequestModel data) =>
    json.encode(data.toJson());

class CheckCreationRequestModel {
  String? createdAt;
  String? status;
  String? date;

  CheckCreationRequestModel({
    required this.createdAt,
    required this.status,
    required this.date,
  });

  factory CheckCreationRequestModel.fromJson(Map<String, dynamic> json) =>
      CheckCreationRequestModel(
        createdAt: json["created_at"].toString().toStringConversion(),
        status: json["status"].toString().toStringConversion(),
        date: json["date"].toString().toStringConversion(),
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt.toString(),
        "status": status ?? "",
        "date": date ?? "",
      };
}
