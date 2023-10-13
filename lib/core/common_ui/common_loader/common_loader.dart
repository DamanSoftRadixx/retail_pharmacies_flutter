import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';

commonRefreshLoader({Color? color}){
  return Container(
    margin: EdgeInsets.all(10),
    child: SizedBox(
      height: 20,
      width: 20,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: color ?? lightColorPalette.greenColor.shade900,
        ),
      ),
    ),
  );
}