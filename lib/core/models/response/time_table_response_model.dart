import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class TimeTableResponseModel {
  TimeTableResponseModel({
    this.data,
    this.total,
    this.skip,
  });

  TimeTableResponseModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TimeTableData.fromJson(v));
      });
    }
    total = json['total'].toString().toIntConversion();
    skip = json['\$skip'].toString().toIntConversion();
  }
  List<TimeTableData>? data;
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

class TimeTableData {
  TimeTableData({
    this.createdAt,
    this.status,
    this.id,
    this.uuid,
    this.cash,
    this.amount,
    this.humo,
    this.uzcard,
    this.other,
  });

  TimeTableData.fromJson(dynamic json) {
    createdAt = json['created_at'].toString().toStringConversion();
    status = json['status'].toString().toStringConversion();
    id = json['_id'].toString().toStringConversion();
    uuid = json['_uuid'].toString().toStringConversion();
    cash = json['cash'].toString().toStringConversion();
    amount = json['amount'].toString().toStringConversion();
    humo = json['humo'].toString().toStringConversion();
    uzcard = json['uzcard'].toString().toStringConversion();
    other = json['other'].toString().toStringConversion();
  }
  String? createdAt;
  String? status;
  String? id;
  String? uuid;
  String? cash;
  String? amount;
  String? humo;
  String? uzcard;
  String? other;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['created_at'] = createdAt;
    map['status'] = status;
    map['_id'] = id;
    map['_uuid'] = uuid;
    map['cash'] = cash;
    map['amount'] = amount;
    map['humo'] = humo;
    map['uzcard'] = uzcard;
    map['other'] = other;
    return map;
  }
}
