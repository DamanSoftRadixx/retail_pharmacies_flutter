import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class Goods {
  Goods({
    this.name,
    this.manufacturer,
    this.id,
    this.uuid,});

  Goods.fromJson(dynamic json) {
    name = json['name'].toString().toStringConversion();
    manufacturer = json['manufacturer'].toString().toStringConversion();
    id = json['_id'].toString().toStringConversion();
    uuid = json['_uuid'].toString().toStringConversion();
  }
  String? name;
  String? manufacturer;
  String? id;
  String? uuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if(name != null){
      map['name'] = name;
    }
    if(manufacturer != null){
      map['manufacturer'] = manufacturer;
    }
    if(id != null){
      map['_id'] = id;
    }
    if(uuid != null){
      map['_uuid'] = uuid;
    }
    return map;
  }

}