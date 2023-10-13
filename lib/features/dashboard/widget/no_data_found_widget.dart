import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget noDataFound(){
  return Center(
    child: Text(
      "${AppStrings.noDataFound.tr}",
      style : TextStyle(
          color: lightColorPalette.blackColor.shade900,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          fontFamily: AppConstants.retailPharmaciesFontFamily
      ),
      textAlign: TextAlign.center,
    ),
  );
}