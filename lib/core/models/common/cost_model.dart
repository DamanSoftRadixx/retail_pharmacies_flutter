import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class Cost {
  Cost({
    this.number,
    this.currency,});

  Cost.fromJson(dynamic json) {
    number = json['number'].toString().toIntConversion();
    currency = json['currency'].toString().toStringConversion();
  }
  int? number;
  String? currency;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if(number != null){
      map['number'] = number;
    }

    if(currency != null){
      map['currency'] = currency;
    }
    return map;
  }

}
