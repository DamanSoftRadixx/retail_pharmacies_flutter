import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';
import 'package:flutter_retail_pharmacies/features/organisation/model/network/common/organisation_data.dart';

class OrganisationListResponseModel {
  OrganisationListResponseModel({
      this.data, 
      this.total, 
      this.skip,});

  OrganisationListResponseModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(OrganisationData.fromJson(v));
      });
    }
    total = json['total'].toString().toIntConversion();
    skip = json['\$skip'].toString().toIntConversion();
  }
  List<OrganisationData>? data;
  int? total;
  int? skip;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['\$skip'] = skip;
    return map;
  }

}