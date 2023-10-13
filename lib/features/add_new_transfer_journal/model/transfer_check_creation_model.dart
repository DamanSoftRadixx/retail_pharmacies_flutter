import 'dart:convert';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

enum TransferCheckStatus {
  draft,
  deleted,
  send,
  received
}

class TransferCheckCreationRequestModel {
  String? createdAt;
  String? status;
  String? date;
  String? sender;
  String? amount;
  String? receiver;


  TransferCheckCreationRequestModel({
    required this.createdAt,
    required this.status,
    required this.date,
    required this.receiver,
    required this.sender,
    required this.amount
  });

  factory TransferCheckCreationRequestModel.fromJson(Map<String, dynamic> json) =>
      TransferCheckCreationRequestModel(
        createdAt: json["created_at"].toString().toStringConversion(),
        status: json["status"].toString().toStringConversion(),
        date: json["date"].toString().toStringConversion(),
        amount: json["amount"].toString().toStringConversion(),
        sender: json["sender"].toString().toStringConversion(),
        receiver: json["receiver"].toString().toStringConversion(),

      );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toString(),
    "status": status ?? "",
    "date": date ?? "",
  'sender' : sender ?? "",
  'amount': amount ?? "",
  'receiver': receiver ?? ""
  };
}
