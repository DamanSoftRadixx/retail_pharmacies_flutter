import 'package:flutter/cupertino.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget tableRowTextWidget({required String name,Color? textColor}){
  return Text(
    name,
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
    textAlign: TextAlign.center,
    style: lightTextTheme.titleSmall?.copyWith(
        color: textColor ?? lightColorPalette.transferJournalColor.topTableRowTextColorNormal,
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        fontFamily: AppConstants.retailPharmaciesFontFamily),
  );
}