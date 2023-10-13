import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class StockBatch {
  StockBatch({
    this.barcode,
    this.id,
    this.date,});

  StockBatch.fromJson(dynamic json) {
    barcode = json['barcode'].toString().toIntConversion();
    id = json['id'].toString().toStringConversion();
    date = json['date'].toString().toStringConversion();
  }
  int? barcode;
  String? id;
  String? date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['barcode'] = barcode;
    map['id'] = id;
    map['date'] = date;
    return map;
  }

}