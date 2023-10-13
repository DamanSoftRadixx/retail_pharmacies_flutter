// // To parse this JSON data, do
// //
// //     final searchData = searchDataFromJson(jsonString);
//
// import 'dart:convert';
//
// SearchData searchDataFromJson(String str) =>
//     SearchData.fromJson(json.decode(str));
//
// class SearchData {
//   SearchData({
//     required this.data,
//     required this.total,
//     required this.skip,
//   });
//
//   final List<Data> data;
//   final int total;
//   final int skip;
//
//   factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
//         data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
//         total: json["total"],
//         skip: json["\u0024skip"],
//       );
// }
//
// class Data {
//   Data({
//     required this.name,
//     required this.manufacturer,
//     required this.id,
//     required this.uuid,
//   });
//
//   final String name;
//   final String manufacturer;
//   final String id;
//   final String uuid;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         name: json["name"],
//         manufacturer: json["manufacturer"],
//         id: json["_id"],
//         uuid: json["_uuid"],
//       );
// }
//
//
//
// // To parse this JSON data, do
// //
// //     final searchData = searchDataFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

SearchListResponseModel searchDataFromJson(String str) => SearchListResponseModel.fromJson(json.decode(str));

String searchDataToJson(SearchListResponseModel data) => json.encode(data.toJson());

class SearchListResponseModel {
  List<SearchData>? data;
  int? total;
  int? skip;
  int? status;
  String? message;

  SearchListResponseModel({
    this.data,
    this.total,
    this.skip,
    this.message,
    this.status
  });

  factory SearchListResponseModel.fromJson(Map<String, dynamic> json) => SearchListResponseModel(
    data: json["data"] == null ? [] : List<SearchData>.from(json["data"]!.map((x) => SearchData.fromJson(x))),
    total: json["total"].toString().toIntConversion(),
    skip: json["\u0024skip"].toString().toIntConversion(),
    status: json["status"].toString().toIntConversion(),
    message: json["message"].toString().toStringConversion(),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
    "\u0024skip": skip,
    "status" : status,
    "message" : message
  };
}

class SearchData {
  String? name;
  String? manufacturer;
  String? id;
  String? uuid;

  SearchData({
    this.name,
    this.manufacturer,
    this.id,
    this.uuid,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
    name: json["name"].toString().toStringConversion(),
    manufacturer: json["manufacturer"].toString().toStringConversion(),
    id: json["_id"].toString().toStringConversion(),
    uuid: json["_uuid"].toString().toStringConversion(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "manufacturer": manufacturer,
    "_id": id,
    "_uuid": uuid,
  };
}