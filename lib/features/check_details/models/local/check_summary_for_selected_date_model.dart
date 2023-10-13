import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';

class CheckSummaryForSelectedDateModel {
  CheckSummaryForSelectedDateModel({
      this.totalHumo, 
      this.totalUzcard, 
      this.totalOther, 
      this.totalCash,});

  CheckSummaryForSelectedDateModel.fromJson(dynamic json) {
    totalHumo = json['total_humo'].toString().toDoubleConversionWithRoundOff();
    totalUzcard = json['total_uzcard'].toString().toDoubleConversionWithRoundOff();;
    totalOther = json['total_other'].toString().toDoubleConversionWithRoundOff();;
    totalCash = json['total_cash'].toString().toDoubleConversionWithRoundOff();;
  }
  double? totalHumo;
  double? totalUzcard;
  double? totalOther;
  double? totalCash;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_humo'] = totalHumo;
    map['total_uzcard'] = totalUzcard;
    map['total_other'] = totalOther;
    map['total_cash'] = totalCash;
    return map;
  }

}