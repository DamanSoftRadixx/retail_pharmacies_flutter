import 'package:flutter_retail_pharmacies/core/models/common/cost_model.dart';
import 'package:flutter_retail_pharmacies/core/models/common/goods_model.dart';
import 'package:flutter_retail_pharmacies/core/models/common/price_model.dart';
import 'package:flutter_retail_pharmacies/core/models/common/quantity_model.dart';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';


class TopTableResponseModel {
  List<TopTableData>? data;
  int? total;
  int? skip;
  int? status;
  String? message;

  TopTableResponseModel({
    this.data,
    this.total,
    this.skip,
    this.status,
    this.message
  });

  factory TopTableResponseModel.fromJson(Map<String, dynamic> json) => TopTableResponseModel(
    data: json["data"] == null ? [] : List<TopTableData>.from(json["data"]!.map((x) => TopTableData.fromJson(x))),
    skip: json['\$skip'].toString().toIntConversion(),
    total: json['total'].toString().toIntConversion() < 0 ? 0 : json['total'].toString().toIntConversion(),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
    "\$skip": skip,
  };
}

class TopTableData {
  TopTableData({
      this.document, 
      this.goods, 
      this.qty, 
      this.cost, 
      this.price, 
      this.id, 
      this.uuid,
  this.status});

  TopTableData.fromJson(dynamic json) {
    document = json['document'].toString().toStringConversion();
    goods = json['goods'] != null ? Goods.fromJson(json['goods']) : null;

    if (json['qty'] != null) {
      qty = [];

      if(json['qty'] is List<dynamic>){
        json['qty'].forEach((v) {
          qty?.add(Qty.fromJson(v));
        });
      }else if(json['qty'] is String){
        qty?.add(Qty(number: json['qty'].toString().toIntConversion()));
      }else{
       qty?.add(Qty.fromJson(json['qty']));
        print("qty json : ${json['qty']}");
      }

    }
    cost = json['cost'] != null ? Cost.fromJson(json['cost']) : null;

    if(json['price'] != null){
      if(json['price'] is String){
        price = Price(number: json['price'].toString().toIntConversion());
      }else{
        price = json['price'] != null ? Price.fromJson(json['price']) : null;
      }
    }

    id = json['_id'].toString().toStringConversion();
    uuid = json['_uuid'].toString().toStringConversion();
    status = json['status'].toString().toStringConversion();
  }
  String? document;
  Goods? goods;
  List<Qty>? qty;
  Cost? cost;
  Price? price;
  String? id;
  String? uuid;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['document'] = document;
    if (goods != null) {
      map['goods'] = goods?.toJson();
    }
    if (qty != null) {
      map['qty'] = qty?.map((v) => v.toJson()).toList();
    }
    if (cost != null) {
      map['cost'] = cost?.toJson();
    }
    if (price != null) {
      map['price'] = price?.toJson();
    }
    if (status != null) {
      map['status'] = status;
    }
    map['_id'] = id;
    map['_uuid'] = uuid;
    return map;
  }

}





