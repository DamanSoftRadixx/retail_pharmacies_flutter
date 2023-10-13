import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_asset/common_image.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_button/custom_icon_button.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/app_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/autocomplete_textfield.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/constants/image_resources.dart';
import 'package:flutter_retail_pharmacies/core/models/local/dropdown_model.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget commonTextFieldWidgetWithoutBorder(
    {required TextEditingController controller,
    String? title,
    String? hint,
    FocusNode? focusNode,
    Function(String value)? onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatter,
    bool readOnly = false,
    TextAlign textAlign = TextAlign.start,
    bool autoFocus = false,
    int? maxLength}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          focusNode?.requestFocus();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Center(
            child: TextFormField(
              controller: controller,
              textAlign: textAlign,
              maxLines: 1,
              minLines: 1,
              maxLength: maxLength ?? 10,
              readOnly: readOnly,
              expands: false,
              autofocus: autoFocus,
              keyboardType: keyboardType ?? TextInputType.name,
              focusNode: focusNode ?? FocusNode(),
              inputFormatters: inputFormatter ?? [],
              onChanged: (value) {
                if (onChanged != null) onChanged(value);
              },
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                counterText: "",
                hintText: hint ?? "",
                hintStyle: TextStyle(
                  color: lightColorPalette.blackColor.shade900,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),

                // contentPadding: EdgeInsets.only(left:10.w,right: 10.w,top: 0.h),
              ),
              style: focusNode != null && focusNode.hasFocus
                  ? TextStyle(
                      color: lightColorPalette.blackColor.shade900,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      fontFamily: AppConstants.retailPharmaciesFontFamily)
                  : TextStyle(
                      color: lightColorPalette.blackColor.shade900,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      fontFamily: AppConstants.retailPharmaciesFontFamily),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget commonTextFieldWidget({
  required TextEditingController controller,
  String? title,
  String? hint,
  FocusNode? focusNode,
  Function(String value)? onChanged,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatter,
  bool isShowBorder = true,
  GlobalKey? globalKey,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    key: globalKey ?? GlobalKey(),
    children: [
      if (title != null && title != "")
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: lightColorPalette.blackColor.shade700,
                letterSpacing: -0.12,
                fontFamily: AppConstants.retailPharmaciesFontFamily),
            textAlign: TextAlign.center,
            // TextStyle(fontSize: 16.sp),
          ),
        ),
      GestureDetector(
        onTap: () {
          focusNode?.requestFocus();
        },
        child: Container(
          width: 1.sw,
          height: 44.h,
          padding: EdgeInsets.only(top: 0.h),
          decoration: BoxDecoration(
              color: lightColorPalette.whiteColor.shade900,
              borderRadius: BorderRadius.circular(6.r),
              shape: BoxShape.rectangle,
              boxShadow: focusNode != null && focusNode.hasFocus
                  ? [
                      BoxShadow(
                        blurRadius: 0,
                        color: lightColorPalette.greyColor.shade700
                            .withOpacity(0.5),
                        offset: const Offset(0, 4.5),
                        spreadRadius: -2,
                      ),
                    ]
                  : [],
              border: isShowBorder
                  ? Border.all(
                      color: lightColorPalette.greyColor.shade900, width: 0.5)
                  : null),
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.w),
            child: Center(
              child: TextFormField(
                controller: controller,
                maxLines: 1,
                minLines: 1,
                expands: false,
                keyboardType: keyboardType ?? TextInputType.name,
                focusNode: focusNode ?? FocusNode(),
                inputFormatters: inputFormatter ?? [],
                onChanged: (value) {
                  if (onChanged != null) onChanged(value);
                },
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: hint ?? "",
                  hintStyle: TextStyle(
                    color: lightColorPalette.blackColor.shade900,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),

                  // contentPadding: EdgeInsets.only(left:10.w,right: 10.w,top: 0.h),
                ),
                style: focusNode != null && focusNode.hasFocus
                    ? TextStyle(
                        color: lightColorPalette.blackColor.shade900,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        fontFamily: AppConstants.retailPharmaciesFontFamily)
                    : TextStyle(
                        color: lightColorPalette.blackColor.shade900,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        fontFamily: AppConstants.retailPharmaciesFontFamily),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget commonSearchField({
  required TextEditingController controller,
  String? title,
  String? label,
  String? hint,
  required bool isSelected,
  required FocusNode focusNode,
  Function(String value)? onChanged,
  Function()? onTap,
  Function()? onTapClose,
  required Function() onTapTrailingIcon,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatter,
  GlobalKey? globalKey,
  required IconData leadingIcon,
  required IconData trailingIcon,
}) {

  var enabledColor = lightColorPalette.greyColor.shade900;
  var focusedColor = lightColorPalette.whiteColor.shade900;

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
        child: GestureDetector(
          onTap: () {
            if(onTap != null) onTap();
            focusNode.requestFocus();

          },
          child: ClipRRect(
            borderRadius:AutoCompleteDropDownTextField.overlayEntry == null ? BorderRadius.circular(6) : BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ) ,
            child: Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: searchDecoration(
                  isSelected: isSelected,
                  isShowFullBorderRadius: !isSelected,isError: false),
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: TextFormField(
                  // keyboardType: keyboardType,
                  controller: controller,
                 maxLines: null,
                 /* maxLines: 1,
                  minLines: 1,
                  maxLength: 50,*/
                  onChanged: onChanged,
                  onTap: (){
                    if(onTap != null) onTap();
                  },
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.search,

                  inputFormatters: inputFormatter,
                  expands: true,
                  focusNode: focusNode,
                  onFieldSubmitted: (value) {
                    print("onFieldSubmitted");
                  },
                  decoration: InputDecoration(
                    // isCollapsed: true,
                    contentPadding: EdgeInsets.only(bottom: 2,top: 2),
                    constraints: BoxConstraints(
                        minHeight: 30,
                        maxHeight: 100
                    ),
                    filled: true,
                    // isDense: true,
                    fillColor:  isSelected ? focusedColor : enabledColor,
                   /* border: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(6))
                    ),*/
                    // hintText: hinzt ?? "",
                    counterText: "",
                    // border: UnderlineInputBorder(),
                    labelText: label ?? "" ,
                    border: InputBorder.none,

                    /*focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: focusedColor),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: enabledColor),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                    ),*/
                    prefixIcon: Icon(
                      leadingIcon,
                      size: 20,
                      color: lightColorPalette.iconColor,
                    ),
                    suffixIcon: controller.text.isNotEmpty ? GestureDetector(
                      onTap: () {
                        controller.text = "";
                        if(onTapClose != null){
                          onTapClose();
                        }
                      },
                      child: Icon(
                        Icons.cancel,
                        size: 20,
                        color: lightColorPalette.iconColor,
                      ),
                    ) : GestureDetector(
                      onTap: () {
                        onTapTrailingIcon();
                      },
                      child: Icon(
                        trailingIcon,
                        size: 20,
                        color: lightColorPalette.iconColor,
                      ),
                    ),
                    labelStyle: CustomTextTheme.normalText1(
                        color: focusNode.hasFocus ? lightColorPalette.themeColor.shade900 : lightColorPalette.blackColor.shade800),
                    hintStyle: CustomTextTheme.normalText1(
                        color: lightColorPalette.blackColor.shade900),
                    hoverColor: Colors.transparent
                  ),
                  style: CustomTextTheme.normalText1(
                      color: lightColorPalette.blackColor.shade900),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}


Widget commonTextFieldWidgetAuth({
  required TextEditingController controller,
  String? title,
  String? hint,
  FocusNode? focusNode,
  Function(String value)? onChanged,
  Function()? onTap,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatter,
  String? errorMsg,
  Function(String value)? onFieldSubmitted,
  required IconData leadingIcon,
  bool? isError,
  bool readOnly = false,
  bool autoFocus = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (title != null && title != "")
        AppTextWidget(
          style: CustomTextTheme.normalText1(
            color: lightColorPalette.themeColor.shade900,
          ),
          text: title ?? "",
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: 3.0),
      GestureDetector(
        onTap: () {
          if(readOnly == false){focusNode?.requestFocus();};
          if(onTap != null) onTap();
        },
        child: Container(
          width: 1.sw,
          height: 44.h,
          padding: EdgeInsets.only(top: 0.h),
          decoration: decoration(
              isSelected: focusNode?.hasFocus ?? false,
              isError: isError ?? false),
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  leadingIcon,
                  size: 20,
                  color: lightColorPalette.iconColor,
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: keyboardType,
                    controller: controller,
                    maxLines: 1,
                    minLines: 1,
                    maxLength: 50,
                    onChanged: onChanged,
                    inputFormatters: inputFormatter,
                    expands: false,
                    readOnly: readOnly,
                    autofocus: autoFocus,
                    focusNode: focusNode,
                    onTap: (){
                      if(onTap != null) onTap();
                    },
                    onFieldSubmitted: (value) {
                      print("onFieldSubmitted");
                      if (onFieldSubmitted != null) onFieldSubmitted(value);
                    },
                    decoration: InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.only(left: 15.0, right: 15.w),
                      border: InputBorder.none,
                      hintText: hint ?? "",
                      counterText: "",
                      hintStyle: CustomTextTheme.normalText1(
                          color: lightColorPalette.greyColor.shade900),
                    ),
                    style: CustomTextTheme.normalText1(
                        color: lightColorPalette.blackColor.shade900),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Visibility(
        visible: isError ?? false,
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: AppTextWidget(
              text: errorMsg ?? "",
              style: CustomTextTheme.smallText1(
                color: lightColorPalette.redColor.shade800,
              ),
            ),
          ),
        ),
      )
    ],
  );
}

Widget commonSearchAutoCompleteTextFieldWidget({
  required TextEditingController controller,
  String? title,
  String? hint,
  required FocusNode focusNode,
  Function(String value)? onChanged,
  TextInputType? keyboardType,
  Color? textColor,
  required Function() onTapPlusIcon,
  required Function() onTapSeachIcon,
  List<TextInputFormatter>? inputFormatter,
  bool isShowBorder = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (title != null && title != "")
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: textColor,
                letterSpacing: -0.12,
                fontFamily: AppConstants.retailPharmaciesFontFamily),
            textAlign: TextAlign.center,
            // TextStyle(fontSize: 16.sp),
          ),
        ),
      GestureDetector(
        onTap: () {
          focusNode?.requestFocus();
        },
        child: AbsorbPointer(
          child: Container(
            width: 1.sw,
            height: 44.h,
            padding: EdgeInsets.only(top: 0.h),
            decoration: BoxDecoration(
                color: lightColorPalette.whiteColor.shade900,
                borderRadius: focusNode.hasFocus ?
                     BorderRadius.only(
                       topLeft: Radius.circular(6),
                       topRight: Radius.circular(6),
                     )
                    : BorderRadius.circular(6),
                shape: BoxShape.rectangle,
                boxShadow: focusNode != null && focusNode.hasFocus
                    ? [
                        BoxShadow(
                          blurRadius: 0,
                          color: lightColorPalette.greyColor.shade700
                              .withOpacity(0.5),
                          offset: const Offset(0, 4.5),
                          spreadRadius: -2,
                        ),
                      ]
                    : [],
                border: isShowBorder
                    ? Border.all(
                        color: lightColorPalette.greyColor.shade900, width: 0.5)
                    : null),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    onTapSeachIcon();
                  },
                  child: Icon(Icons.search),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.w),
                    child: Center(
                      child: TextFormField(
                        controller: controller,
                        maxLines: 1,
                        minLines: 1,
                        expands: false,
                        keyboardType: keyboardType ?? TextInputType.name,
                        focusNode: focusNode ?? FocusNode(),
                        inputFormatters: inputFormatter ?? [],
                        onChanged: (value) {
                          if (onChanged != null) onChanged(value);
                        },
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintText: hint ?? "",
                          hintStyle: TextStyle(
                            color: lightColorPalette.blackColor.shade900,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),

                          // contentPadding: EdgeInsets.only(left:10.w,right: 10.w,top: 0.h),
                        ),
                        style: focusNode != null && focusNode.hasFocus
                            ? TextStyle(
                                color: lightColorPalette.blackColor.shade900,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                fontFamily:
                                    AppConstants.retailPharmaciesFontFamily)
                            : TextStyle(
                                color: lightColorPalette.blackColor.shade900,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                fontFamily:
                                    AppConstants.retailPharmaciesFontFamily),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    onTapPlusIcon();
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget commonPasswordText(
    {required final String title,
    required bool passwordVisible,
    final VoidCallback? onPress,
    required final TextEditingController controller,
    required FocusNode focusNode,
    String? errorMsg,
    bool? isError,
    String? hint,
    Function(String value)? onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatter,
    Function(String value)? onFieldSubmitted,
    TextInputAction? textInputAction,
    required IconData leadingIcon}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null && title != "")
        AppTextWidget(
          style: CustomTextTheme.normalText1(
            color: lightColorPalette.themeColor.shade900,
          ),
          text: title ?? "",
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: 3.0),
      GestureDetector(
        onTap: () {
          focusNode.requestFocus();
        },
        child: Container(
          width: 1.sw,
          height: 44.h,
          padding: EdgeInsets.only(top: 0.h),
          decoration: decoration(
              isSelected: focusNode?.hasFocus ?? false,
              isError: isError ?? false),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                leadingIcon,
                size: 20,
                color: lightColorPalette.iconColor,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: keyboardType,
                  controller: controller,
                  maxLines: 1,
                  minLines: 1,
                  maxLength: 30,
                  onChanged: onChanged,
                  expands: false,
                  obscureText: !passwordVisible,
                  inputFormatters: inputFormatter,
                  focusNode: focusNode,
                  onFieldSubmitted: (value) {
                    if (onFieldSubmitted != null) onFieldSubmitted(value);
                  },
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.only(left: 15.0, right: 15),
                    border: InputBorder.none,
                    hintText: hint ?? "",
                    counterText: "",
                    hintStyle: CustomTextTheme.normalText1(
                        color: lightColorPalette.greyColor.shade900),
                  ),
                  style: CustomTextTheme.normalText1(
                      color: lightColorPalette.blackColor.shade900),
                ),
              ),
              CustomInkwell(
                padding: EdgeInsets.zero,
                onTap: onPress == null
                    ? null
                    : () {
                        onPress();
                      },
                child: passwordVisible
                    ? AssetWidget(
                        asset: Asset(
                            type: AssetType.svg, path: ImageResource.hideEye),
                      )
                    : AssetWidget(
                        asset: Asset(
                            type: AssetType.svg, path: ImageResource.openEye),
                      ),
              ),
              SizedBox(
                width: 15,
              )
            ],
          ),
        ),
      ),
      Visibility(
        visible: isError ?? false,
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: AppTextWidget(
              text: errorMsg ?? "",
              style: CustomTextTheme.smallText1(
                color: lightColorPalette.redColor.shade800,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}


Widget dropdownField(
    {String? hint,
      required DropDownModel selectedValue,
      required Function(DropDownModel value) onClick,
      EdgeInsetsGeometry? padding,
      required List<DropDownModel> list,
      bool? isExpanded,
      bool isMandatory = false,
      bool isShowRightButton = false,
      String? title,
      Widget? rightButtonDesign,
      bool isError = false,
      Function()? onTap,
      String? errorMsg,
      bool? isDisable,
      bool hasFocus = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null && title != "")
        Padding(
          padding: EdgeInsets.only(bottom: 3.h),
          child: AppTextWidget(
            style: CustomTextTheme.normalText1(color: lightColorPalette.blackColor.shade900),
            text: title,
            textAlign: TextAlign.center,
          ),
        ),
      Container(
          height: 44,
          decoration: decoration(isSelected: hasFocus),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<DropDownModel>(
              // isDense: true,
              /* menuItemStyleData:
                  MenuItemStyleData(padding: EdgeInsets.only(left: 24.w)),*/
              dropdownStyleData: DropdownStyleData(
                // elevation: 3,
                offset: const Offset(0, -5.59),
                maxHeight: 300.h,
                decoration: BoxDecoration(
                  color: lightColorPalette.whiteColor.shade900,
                  boxShadow: [
                    BoxShadow(
                        color: lightColorPalette.blackColor.withOpacity(0.10),
                        spreadRadius: 2,
                        blurRadius: 20,
                        offset: const Offset(1, 1))
                  ],
                  borderRadius: BorderRadius.circular(borderRadius),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      color: lightColorPalette.greyColor.withOpacity(0.3),
                      width: 0.3),
                ),
              ),
              isExpanded: isExpanded ?? false,
              underline: const SizedBox(),
              customButton: Padding(
                padding: EdgeInsets.only(right: 10.0, left: 16.0),
                child: Row(
                  children: [
                    selectedValue.name == ""
                        ? AppTextWidget(
                      text: hint ?? "",
                      style: CustomTextTheme.normalText1(
                          color:
                          lightColorPalette.blackColor.withOpacity(0.5)),
                    )
                        : AppTextWidget(
                      text: selectedValue.name,
                      style: CustomTextTheme.normalText1(
                          color: lightColorPalette.blackColor.shade900),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Center(
                        child: Icon(Icons.arrow_drop_down),
                      ),
                    )
                  ],
                ),
              ),

              hint: AppTextWidget(
                text: hint ?? "",
                style: CustomTextTheme.normalText1(
                    color: lightColorPalette.blackColor.shade900.withOpacity(0.5)),
              ),
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.only(left: 2, right: 5),
              ),
              value: selectedValue.name == "" ? null : selectedValue,
              selectedItemBuilder: (_) {
                return list.map<Widget>((item) {
                  return Row(
                    children: [
                      AppTextWidget(
                        text: item.name.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppConstants.retailPharmaciesFontFamily,
                          color: lightColorPalette.blackColor.shade900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                }).toList();
              },
              menuItemStyleData: MenuItemStyleData(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                customHeights: getCustomItemsHeights(items: list),
              ),
              items: addDividersAfterItems(
                  items: list,
                  selectedValue: selectedValue,
                  isDisable: isDisable),
              onChanged: (DropDownModel? value) {
                onClick(value!);
              },
            ),
          )),
      Visibility(
        visible: isError ?? false,
        child: Align(
          alignment: Alignment.topLeft,
          child: AppTextWidget(
            text: errorMsg ?? "",
            style: CustomTextTheme.normalText1(
              color: lightColorPalette.redColor.shade900,
            ),
          ).paddingOnly(top: 5),
        ),
      ),
    ],
  );
}


List<DropdownMenuItem<DropDownModel>> addDividersAfterItems(
    {required List<DropDownModel> items,
      required DropDownModel selectedValue,
      bool? isDisable}) {
  List<DropdownMenuItem<DropDownModel>>? menuItems = [];
  for (final item in items) {
    menuItems.addAll(
      [
        DropdownMenuItem<DropDownModel>(
          value: item,
          child: Row(
            children: [
              AppTextWidget(
                text: item.name.toString(),
                style: CustomTextTheme.normalText1(
                    color: selectedValue.dropDownId == item.dropDownId
                        ? lightColorPalette.blackColor.shade900
                        : isDisable == true
                        ? lightColorPalette.greyColor.shade900
                        : lightColorPalette.blackColor.shade900),
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              selectedValue.dropDownId == item.dropDownId
                  ? Icon(Icons.check,size: 15,)
                  : Container(),
            ],
          ).paddingSymmetric(horizontal: 15),
        ),
        //If it's last item, we will not add Divider after it.
        if (item != items.last)
          const DropdownMenuItem<DropDownModel>(
            enabled: false,
            child: Divider(),
          ),
      ],
    );
  }
  return menuItems;
}

List<double> getCustomItemsHeights({required List<DropDownModel> items}) {
  final List<double> itemsHeights = [];
  for (int i = 0; i < (items.length * 2) - 1; i++) {
    if (i.isEven) {
      itemsHeights.add(32);
    }
    //Dividers indexes will be the odd indexes
    if (i.isOdd) {
      itemsHeights.add(4);
    }
  }
  return itemsHeights;
}


