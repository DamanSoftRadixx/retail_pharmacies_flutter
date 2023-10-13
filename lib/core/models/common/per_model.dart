import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class Per {
  Per({
    this.number,
    this.uom,
    this.of,});

  Per.fromJson(dynamic json) {
    number = json['number'].toString().toIntConversion();
    uom = json['uom'].toString().toStringConversion();
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
