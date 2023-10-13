import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';
import 'package:flutter_retail_pharmacies/features/reports/model/network/common/stock_batch_model.dart';

class StocksResponseModel {
  StocksResponseModel({
      this.data, 
      this.total, 
      this.skip,});

  StocksResponseModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(StockData.fromJson(v));
      });
    }
    total = json['total'].toString().toIntConversion();
    skip = json['$skip'].toString().toIntConversion();
  }
  List<StockData>? data;
  int? total;
  int? skip;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['$skip'] = skip;
    return map;
  }

}

class StockData {
  StockData({
    this.name,
    this.vendorCode,
    this.categoryRef,
    this.uom,
    this.id,
    this.uuid,
    this.balance,
    this.category,
  this.batch,
  this.goods,
  this.storage});

  StockData.fromJson(dynamic json) {
    name = json['name'].toString().toStringConversion();
    vendorCode = json['vendor_code'].toString().toIntConversion();
    categoryRef = json['category'].toString().toStringConversion();
    uom = json['uom'] != null ? StockUom.fromJson(json['uom']) : null;
    id = json['_id'].toString().toStringConversion();
    uuid = json['_uuid'].toString().toStringConversion();
    balance = json['_balance'] != null ? StockBalance.fromJson(json['_balance']) : null;
    category = json['_category'].toString().toStringConversion();
    storage = json['storage'] != null ? StockStorage.fromJson(json['storage']) : null;
    goods = json['goods'] != null ? StockGoods.fromJson(json['goods']) : null;
    batch = json['batch'] != null ? StockBatch.fromJson(json['batch']) : null;
  }
  String? name;
  int? vendorCode;
  String? category;
  StockUom? uom;
  String? id;
  String? uuid;
  StockBalance? balance;
  String? categoryRef;
  StockStorage? storage;
  StockGoods? goods;
  StockBatch? batch;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['vendor_code'] = vendorCode;
    map['category'] = categoryRef;
    if (uom != null) {
      map['uom'] = uom?.toJson();
    }
    map['_id'] = id;
    map['_uuid'] = uuid;
    if (balance != null) {
      map['_balance'] = balance?.toJson();
    }
    map['_category'] = category;
    if (storage != null) {
      map['storage'] = storage?.toJson();
    }
    if (goods != null) {
      map['goods'] = goods?.toJson();
    }
    if (batch != null) {
      map['batch'] = batch?.toJson();
    }
    return map;
  }

}


class StockBalance {
  StockBalance({
    this.qty,
    this.cost,});

  StockBalance.fromJson(dynamic json) {
    qty = json['qty'].toString().toIntConversion();
    cost = json['cost'].toString().toStringConversionWithoutZero();
  }
  int? qty;
  String? cost;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['qty'] = qty;
    map['cost'] = cost;
    return map;
  }

}

class StockUom {
  StockUom({
    this.name,
    this.id,
    this.uuid,});

  StockUom.fromJson(dynamic json) {
    name = json['name'].toString().toStringConversion();
    id = json['_id'].toString().toStringConversion();
    uuid = json['_uuid'].toString().toStringConversion();
  }
  String? name;
  String? id;
  String? uuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['_id'] = id;
    map['_uuid'] = uuid;
    return map;
  }

}

class StockGoods {
  StockGoods({
    this.name,
    this.vendorCode,
    this.category,
    this.uom,
    this.id,
    this.uuid,});

  StockGoods.fromJson(dynamic json) {
    name = json['name'].toString().toStringConversion();
    vendorCode = json['vendor_code'].toString().toIntConversion();
    category = json['category'].toString().toStringConversion();
    uom = json['uom'] != null ? StockUom.fromJson(json['uom']) : null;
    id = json['_id'].toString().toStringConversion();
    uuid = json['_uuid'].toString().toStringConversion();
  }
  String? name;
  int? vendorCode;
  String? category;
  StockUom? uom;
  String? id;
  String? uuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['vendor_code'] = vendorCode;
    map['category'] = category;
    if (uom != null) {
      map['uom'] = uom?.toJson();
    }
    map['_id'] = id;
    map['_uuid'] = uuid;
    return map;
  }

}

class StockStorage {
  StockStorage({
    this.name,
    this.id,
    this.uuid,});

  StockStorage.fromJson(dynamic json) {
    name = json['name'].toString().toStringConversion();
    id = json['_id'].toString().toStringConversion();
    uuid = json['_uuid'].toString().toStringConversion();
  }
  String? name;
  String? id;
  String? uuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['_id'] = id;
    map['_uuid'] = uuid;
    return map;
  }

}