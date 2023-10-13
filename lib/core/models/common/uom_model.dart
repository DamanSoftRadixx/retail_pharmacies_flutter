import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class Uom {
  String? id;
  String? status;

  Uom({
    this.id,
    this.status,
  });

  Uom.fromJson(dynamic json) {
    id = json["_id"].toString().toStringConversion();
    status = json["_status"].toString().toStringConversion();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if(id != null){
      map['_id'] = id;
    }
    if(status != null){
      map['_status'] = status;
    }

    return map;
  }

}
