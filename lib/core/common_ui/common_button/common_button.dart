import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_fucntionality/delay/create_delay.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_asset/common_image.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/app_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonButton extends StatelessWidget {
  final Color? bgColor;
  final Color? textColor;
  final String commonButtonBottonText;
  final bool? isEnable;
  final bool? isIconEnable;
  final double? radius;
  final double? elevation;
  final double vertical;
  final double horizontal;
  final double? minWidth;
  final double? minHeight;
  final VoidCallback? onPress;
  final TextStyle? style;
  final ShowImagePositionAt? type;
  final MainAxisAlignment? mainAxisAlignment;
  final double? spaceBetween;
  final String? image;
  final bool? needStyle;

  const CommonButton(
      {Key? key,
      this.bgColor,
      required this.commonButtonBottonText,
      this.radius,
        this.textColor,
      this.elevation = 0.0,
      this.vertical = 18.0,
      this.horizontal = 0.0,
      this.minWidth = double.infinity,
      this.isEnable = true,
      this.isIconEnable = true,
      this.style,
      this.needStyle,
      this.mainAxisAlignment,
      this.spaceBetween,
      this.minHeight,
      this.image,
      required this.onPress,
      this.type = ShowImagePositionAt.none})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress == null
          ? null
          : () {
        if (isRedundentClick(DateTime.now())) {
          // print('hold on, processing');
          return;
        }
        onPress!();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? borderRadius)),
        backgroundColor: bgColor ?? lightColorPalette.themeColor.shade900,
        // disabledBackgroundColor: lightColorPalette.additionalSwatch1.shade800,
        textStyle: style ??
            CustomTextTheme.subText2(
              color: textColor ?? lightColorPalette.whiteColor.shade900,
            ),
        splashFactory: isEnable == true ? null : NoSplash.splashFactory,
        elevation: elevation,
        maximumSize: Size(minWidth!, minHeight ?? 55.h),
        minimumSize: Size(minWidth!, minHeight ?? 55.h),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: horizontal),
      ),
      child: AppTextWidget(
        text: commonButtonBottonText,
        style: CustomTextTheme.heading3(
          color: textColor ?? lightColorPalette.whiteColor.shade900,
        ),
      ),
    );
  }
}

