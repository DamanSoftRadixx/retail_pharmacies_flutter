//Method for showing the date picker
import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


void showDatePickerDialog({required Function(DateTime date) onPicked}) {
  
  var currentDate = DateTime.now();
  var firstDate = DateTime(currentDate.year - 100);
  var lastDate = currentDate;

  showDatePicker(
      context: Get.context!,
      initialDate: currentDate, //which date will display when user open the picker
      firstDate: firstDate, //what will be the previous supported year in picker
      lastDate: lastDate) //what will be the up to supported date in picker
      .then((pickedDate) {
    //then usually do the future job
    if (pickedDate == null) {
      //if user tap cancel then this function will stop
      return;
    }
    onPicked(pickedDate);
  });
}


rangeSelectionDatePickerDialog({
  required Function(DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) onSelectionChanged,
  required Function() onTap, required String selectedStartDate, required String selectedEndDate}){

  DateTime startDate =  apiDateFormat.parse(selectedStartDate);
  DateTime endDate =  apiDateFormat.parse(selectedEndDate);

  return Get.dialog(
      AlertDialog(
          content: SizedBox(
            width: 1.sw *0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SfDateRangePicker(
                  onSelectionChanged: (dateRangePickerSelectionChangedArgs){
                    onSelectionChanged(dateRangePickerSelectionChangedArgs);
                  },
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(
                      startDate,
                      endDate),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        onTap();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 150,
                        height: 45,
                        decoration: BoxDecoration(
                            color: lightColorPalette.themeColor.shade900,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          AppStrings.doneButton.tr,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: lightColorPalette.whiteColor.shade900,
                              letterSpacing: -0.12,
                              fontFamily: AppConstants.retailPharmaciesFontFamily),
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ),
          )));
}
