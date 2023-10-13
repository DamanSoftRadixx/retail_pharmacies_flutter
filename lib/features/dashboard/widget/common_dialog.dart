import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

commonDialogWidget({
  Function()? onPressCancelButton,
  required Function() onPressOkayButton,
  String? title,
  required String message,
  bool isHideCancel = false,
  String? leftBtnTitle,
  rightBtnTitle,
}) {

  if (Get.isDialogOpen == null || Get.isDialogOpen == false) {
    return Get.dialog(AlertDialog(
        content: Container(
          width: 100.w,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? AppStrings.alert.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xFF0E0631),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF0E0631),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isHideCancel)
                      InkWell(
                        onTap: () {
                          if (onPressCancelButton != null) onPressCancelButton();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 90,
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: lightColorPalette.blackColor.shade900,
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(leftBtnTitle ?? AppStrings.cancel.tr,
                              style: lightTextTheme.bodySmall?.copyWith(
                                  color: lightColorPalette.blackColor.shade900)),
                        ),
                      ),
                    if (!isHideCancel)
                      const SizedBox(
                        width: 30,
                      ),
                    InkWell(
                      onTap: () {
                        onPressOkayButton();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 90,
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: lightColorPalette.redColor.shade900,
                                width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          rightBtnTitle ?? AppStrings.ok.tr,
                          style: lightTextTheme.bodySmall
                              ?.copyWith(color: lightColorPalette.redColor.shade900),
                        ),
                      ),
                    ),
                  ],
                )
              ]),
        )));

  }


}
