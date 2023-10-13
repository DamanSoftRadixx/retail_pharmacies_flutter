import 'package:flutter_retail_pharmacies/core/models/common/per_model.dart';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class Price {
  Price({
    this.number,
    this.currency,
    this.per,});

  Price.fromJson(dynamic json) {
    number = json['number'].toString().toIntConversion();
    currency = json['currency'].toString().toStringConversion();
    per = json['per'] != null ? Per.fromJson(json['per']) : null;
  }
  int? number;
  String? currency;
  Per? per;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if(number != null){
      map['number'] = number;
    }
    if(currency != null){
      map['currency'] = currency;
    }
    if (per != null) {
      map['per'] = per?.toJson();
    }
    return map;
  }

}


