import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/common_textfield.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/core/utility_extensions/string_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/add_new_Transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/dashboard_contoller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


errorText({required String errorMsg}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: Text(
      errorMsg,
      style: TextStyle(
          color: lightColorPalette.redColor.shade900,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          fontFamily: AppConstants.retailPharmaciesFontFamily),
      textAlign: TextAlign.center,
    ),
  );
}

dialogHeader({
  required String title,
  required String subTitle,
  required Function() onPressBackButton,
}) {
  return Container(
    padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: lightColorPalette.blackColor.shade900,
                  letterSpacing: -0.12,
                  fontFamily: AppConstants.retailPharmaciesFontFamily),
              textAlign: TextAlign.center,
              // TextStyle(fontSize: 16.sp),
            ),
            if (subTitle != "")
              const SizedBox(
                height: 8,
              ),
            if (subTitle != "")
              Text(
                subTitle,
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color:
                        lightColorPalette.blackColor.shade700.withOpacity(0.6),
                    letterSpacing: -0.12,
                    fontFamily: AppConstants.retailPharmaciesFontFamily),
                textAlign: TextAlign.center,
                // TextStyle(fontSize: 16.sp),
              ),
          ],
        ),
        GestureDetector(
            onTap: () {
              onPressBackButton();
            },
            child: const Icon(Icons.close))
      ],
    ),
  );
}

class AddEditQuantityPopUpModel {
  String name;
  String manufacturar;
  String series;
  String totalQuantityAvailable;
  String expiryDate;
  int totalPriceSum;
  String purchasedQuantity;
  String partialQuantity;
  String unitPrice;
  String unitQuantity;

  AddEditQuantityPopUpModel(
      {required this.name,
      required this.manufacturar,
      required this.series,
      required this.totalQuantityAvailable,
      required this.expiryDate,
      required this.totalPriceSum,
      required this.purchasedQuantity,
      required this.unitPrice,
      required this.partialQuantity,
      required this.unitQuantity});
}
