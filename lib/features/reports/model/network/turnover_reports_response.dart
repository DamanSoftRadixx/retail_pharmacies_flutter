import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';
import 'package:flutter_retail_pharmacies/features/reports/model/network/common/stock_batch_model.dart';

class TurnoverReportsResponse {
  TurnoverReportsResponse({
      this.data, 
      this.total, 
      this.skip,});

  TurnoverReportsResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TurnOverData.fromJson(v));
      });
    }
    total = json['total'].toString().toIntConversion();
    skip = json['\$skip'].toString().toIntConversion();
  }
  List<TurnOverData>? data;
  int? total;
  int? skip;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['\$skip'] = skip;
    return map;
  }

}

class TurnOverData {
  TurnOverData({
      this.date, 
      this.type, 
      this.id, 
      this.qty, 
      this.cost,});

  TurnOverData.fromJson(dynamic json) {
    date = json['date'].toString().toStringConversion();
    type = json['type'].toString().toStringConversion();
    id = json['_id'].toString().toStringConversion();
    qty = json['qty'].toString().toStringConversionWithoutZero();
    cost = json['cost'].toString().toStringConversionWithoutZero();

    from = json['from'].toString().toStringConversion();
    goods = json['goods'].toString().toStringConversion();
    op = json['op'] != null ? TurnOverOp.fromJson(json['op']) : null;
    isDependent = json['is_dependent'];
    into = json['into'].toString().toStringConversion();
    batch = json['batch'] != null ? StockBatch.fromJson(json['batch']) : null;
  }
  String? date;
  String? type;
  String? id;
  String? qty;
  String? cost;

  String? from;
  String? goods;
  TurnOverOp? op;
  bool? isDependent;
  String? into;
  StockBatch? batch;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['type'] = type;
    map['_id'] = id;
    map['qty'] = qty;
    map['cost'] = cost;
    map['from'] = from;
    map['goods'] = goods;
    if (op != null) {
      map['op'] = op?.toJson();
    }
    map['is_dependent'] = isDependent;
    map['into'] = into;
    if (batch != null) {
      map['batch'] = batch?.toJson();
    }
    return map;
  }

}

class TurnOverOp {
  TurnOverOp({
    this.type,
    this.qty,
    this.cost,
    this.mode,});

  TurnOverOp.fromJson(dynamic json) {
    type = json['type'].toString().toStringConversion();
    qty = json['qty'].toString().toStringConversionWithoutZero();
    cost = json['cost'].toString().toStringConversionWithoutZero();
    mode = json['mode'].toString().toStringConversionWithoutZero();
  }
  String? type;
  String? qty;
  String? cost;
  String? mode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['qty'] = qty;
    map['cost'] = cost;
    map['mode'] = mode;
    return map;
  }

}