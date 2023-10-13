import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';

Widget commonLoader({Color? color}){
  return Center(
    child: CircularProgressIndicator(color: color ?? lightColorPalette.themeColor.shade900,)
  );
}