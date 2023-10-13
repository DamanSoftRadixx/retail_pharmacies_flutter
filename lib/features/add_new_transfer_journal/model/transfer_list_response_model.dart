import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';
import 'package:flutter_retail_pharmacies/features/organisation/model/network/common/organisation_data.dart';

class TransferListResponseModel {
  TransferListResponseModel({
    this.data,
    this.total,
    this.skip,
  });

  TransferListResponseModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TransferData.fromJson(v));
      });
    }
    total = json['total'].toString().toIntConversion();
    skip = json['\$skip'].toString().toIntConversion();
  }
  List<TransferData>? data;
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

class TransferData {
  TransferData({
    this.createdAt,
    this.status,
    this.id,
    this.uuid,
    this.sender,
    this.receiver,
    this.amount
  });

  TransferData.fromJson(dynamic json) {
    createdAt = json['created_at'].toString().toStringConversion();
    status = json['status'].toString().toStringConversion();
    id = json['_id'].toString().toStringConversion();
    uuid = json['_uuid'].toString().toStringConversion();

    if (json['sender'] != null) {
      if(json['sender'] is String){
        sender = json['sender'] != null ? OrganisationData(organisationAddress: json['sender'] ?? "") : null;
      }else{
        sender = json['sender'] != null ? OrganisationData.fromJson(json['sender']) : null;
      }
    }

    if (json['receiver'] != null) {
      if(json['receiver'] is String){
        receiver = json['receiver'] != null ? OrganisationData(organisationAddress: json['receiver'] ?? "") : null;
      }else{
        receiver = json['receiver'] != null ? OrganisationData.fromJson(json['receiver']) : null;
      }
    }


    // sender = json['sender'] != null ? OrganisationData.fromJson(json['sender']) : null;
    // sender = json['receiver'] != null ? OrganisationData.fromJson(json['receiver']) : null;

    amount = json['amount'].toString().toStringConversion();
  }
  String? createdAt;
  String? status;
  String? id;
  String? uuid;
  OrganisationData? sender;
  String? amount;
  OrganisationData? receiver;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['created_at'] = createdAt;
    map['status'] = status;
    map['_id'] = id;
    map['_uuid'] = uuid;
    if (sender != null) {
      map['sender'] = sender?.toJson();
    }
    if (receiver != null) {
      map['receiver'] = receiver?.toJson();
    }
    map['amount'] = amount;

    return map;
  }
}
