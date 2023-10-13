// To parse this JSON data, do
//
//     final tableLine = tableLineFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_retail_pharmacies/core/models/common/cost_model.dart';
import 'package:flutter_retail_pharmacies/core/models/common/price_model.dart';
import 'package:flutter_retail_pharmacies/core/models/common/quantity_model.dart';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

TableLineRequest tableLineFromJson(String str) => TableLineRequest.fromJson(json.decode(str));

String tableLineToJson(TableLineRequest data) => json.encode(data.toJson());

class TableLineRequest {
  final String? status;
  final String? document;
  final String? goods;
  final List<QtyRequest>? qty;
  final Price? price;
  final Cost? cost;

  TableLineRequest({
    this.status,
    this.document,
    this.goods,
    this.qty,
    this.price,
    this.cost,
  });

  factory TableLineRequest.fromJson(Map<String, dynamic> json) => TableLineRequest(
        status: json["status"],
        document: json["document"],
        goods: json["goods"],
      qty: json["qty"] == null ? [] : List<QtyRequest>.from(json["qty"]!.map((x) => QtyRequest.fromJson(x))),
     price: Price.fromJson(json["price"]),
        cost: Cost.fromJson(json["cost"]),
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    if (status != null) {
      map["status"] = status;
    }

    if (document != null) {
      map["document"] = document;
    }

    if (goods != null) {
      map["goods"] = goods;
    }

    if (qty != null) {
      map["qty"] = qty == null ? [] : List<dynamic>.from(qty!.map((x) => x.toJson()));
    }



    if (cost != null) {
      map["cost"] = cost?.toJson();
    }

    if (price != null) {
      map["price"] = price?.toJson();
    }

    return map;
  }
}

class QtyRequest {
  QtyRequest({
    this.number,
    this.uom,
    this.of,});

  QtyRequest.fromJson(dynamic json) {
    number = json['number'].toString().toIntConversion();
    uom = json['number'].toString().toStringConversion();
    of = json['of'].toString().toStringConversion();
  }
  int? number;
  String? uom;
  String? of;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if(number != null){
      map['number'] = number;
    }
    if(uom != null){
      map['uom'] = uom;
    }
    if(of != null){
      map['of'] = of;
    }

    return map;
  }

}




