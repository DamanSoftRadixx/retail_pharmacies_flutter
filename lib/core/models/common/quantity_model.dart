import 'package:flutter_retail_pharmacies/core/models/common/uom_model.dart';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class Qty {
  Qty({
    this.number,
    this.uom,
    this.of,});

  Qty.fromJson(dynamic json) {
    number = json['number'].toString().toIntConversion();

    if(json['uom'] != null){
      if(json['uom'] is String){
        uom = Uom(id: json['uom'].toString().toStringConversion());
      }else{
        uom = Uom.fromJson(json['uom']);
      }
    }
    of = json['of'].toString().toStringConversion();
  }
  int? number;
  Uom? uom;
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
