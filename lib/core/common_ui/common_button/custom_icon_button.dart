import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInkwell extends StatelessWidget {
  final Widget child;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  // final VoidCallback onPressed;
  final void Function()? onTap;

  const CustomInkwell(
      {Key? key,
      required this.child,
      this.iconSize,
      required this.onTap,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
        data: const CupertinoThemeData(primaryColor: Colors.transparent),
        child: CupertinoButton.filled(
          borderRadius: BorderRadius.zero,
          minSize: iconSize,
          padding: padding ?? EdgeInsets.all(12.w),
          //onPressed: () => onPressed(),
          onPressed: onTap,
          child: child,
        ));
  }
}
