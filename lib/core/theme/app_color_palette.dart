import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';

//AppColor palette class contains all the colors and text theme of entire project

class AppColorPalette {
  final MaterialColor blueColor;
  final MaterialColor yellowColor;
  final MaterialColor greyColor;
  final MaterialColor blackColor;
  final MaterialColor pitchColor;
  final MaterialColor redColor;
  final MaterialColor greenColor;
  final MaterialColor themeColor;
  final MaterialColor whiteColor;
  final ModuleColors checkJournalColor;
  final ModuleColors transferJournalColor;
  final ModuleColors addNewTransferJournalColor;
  final ModuleColors addNewChecksColor;
  final ModuleColors inventoryReportsColor;
  final Color backgroundColor;
  final Color backgroundColorGreen;
  final Color iconColor;
  final Color textfieldGrey;


  const AppColorPalette({
    required this.blueColor,
    required this.yellowColor,
    required this.greyColor,
    required this.blackColor,
    required this.pitchColor,
    required this.redColor,
    required this.greenColor,
    required this.themeColor,
    required this.whiteColor,
    required this.backgroundColor,
    required this.backgroundColorGreen,
    required this.iconColor,
    required this.addNewChecksColor,
    required this.addNewTransferJournalColor,
    required this.transferJournalColor,
    required this.checkJournalColor,
    required this.inventoryReportsColor,
    required this.textfieldGrey,

  });
}

 AppColorPalette lightColorPalette = AppColorPalette(
  blueColor: MaterialColor(900, {
    900: Color(0xFF2195f3),
    800:Color(0xFF1B7EAC)
  }),

  themeColor: MaterialColor(900, {
    900: Color(0xFF0f53b3),
    800: Color(0xFF08b2d7),
    700: Color(0xFFa7cdcf),
    600: Color(0xFFB0C4DE ),


  }),
  yellowColor: MaterialColor(900, {
    900: Color(0xFFfec106),
  }),
  greyColor:  MaterialColor(900, {
    900: Color(0xFFdadada),
    800:Color(0XFFfbfbfb),
    700:Color(0XFFf5f5f5),

  }),
  blackColor:  MaterialColor(900, {
    900: Colors.black,
    800: Colors.black54,
    700 : Color(0xFF757474)
  }),
  pitchColor:  MaterialColor(900, {
    900: Color(0xFFf8bbcf),
  }),
  redColor:  MaterialColor(900, {
    900: Color(0xFFfd0807),
    800: Color(0xAAfd0807)
  }),
  greenColor:  MaterialColor(900, {
    900: Color(0xFF3a8841),
    800: Color(0xFF587058)
  }),
  whiteColor:  MaterialColor(900, {
    900: Color(0xFFFFFFFF),
    800: Color(0xFFedf3f0),
    700: Color(0xFFFAF9F6)
  }),

   transferJournalColor:  ModuleColors(
     topTableHeadingBgColor: Color(0xFF587058),
     topTableHeadingTextColor: Color(0xFFFFFFFF),

     topTableRowBgColorSelected: Color(0xFF587058).withOpacity(0.2),
     topTableRowBgColorNormal: Color(0xFFFFFFFF),

     topTableRowTextColorSelected: Colors.black,
     topTableRowTextColorNormal: Colors.black,

     topTableReceiptBgColor: Color(0xFF587058),
     topTableReceiptTextColor: Color(0xFFFFFFFF),

     searchFieldBgColor: Color(0xFF587058).withOpacity(0.6),
     searchFieldTextColor: Colors.black,

     bottomTableHeadingBgColor: Color(0xFF587058),
     bottomTableHeadingTextColor: Color(0xFFFFFFFF),

     bottomTableRowBgColorSelected: Color(0xFF587058).withOpacity(0.2),
     bottomTableRowBgColorNormal: Color(0xFFFFFFFF),

     bottomTableRowTextColorSelected: Colors.black,
     bottomTableRowTextColorNormal: Colors.black,

     bottomTableReceiptBgColor: Color(0xFF587058),
     bottomTableReceiptTextColor:  Color(0xFFFFFFFF),

     topTableLoaderColor: Color(0xFF587058),
     bottomTableLoaderColor: Color(0xFF587058),
   ),


   checkJournalColor:  ModuleColors(
    topTableHeadingBgColor: Color(0xFF1B7EAC),
    topTableHeadingTextColor: Color(0xFFFFFFFF),

    topTableRowBgColorSelected: Color(0xFF1B7EAC).withOpacity(0.2),
    topTableRowBgColorNormal: Color(0xFFFFFFFF),

    topTableRowTextColorSelected: Colors.black,
    topTableRowTextColorNormal: Colors.black,

    topTableReceiptBgColor: Color(0xFF1B7EAC),
    topTableReceiptTextColor: Color(0xFFFFFFFF),

    searchFieldBgColor: Color(0xFF1B7EAC).withOpacity(0.6),
    searchFieldTextColor: Colors.black,

    bottomTableHeadingBgColor: Color(0xFF1B7EAC),
    bottomTableHeadingTextColor: Color(0xFFFFFFFF),

    bottomTableRowBgColorSelected: Color(0xFF1B7EAC).withOpacity(0.2),
    bottomTableRowBgColorNormal: Color(0xFFFFFFFF),

    bottomTableRowTextColorSelected: Colors.black,
    bottomTableRowTextColorNormal: Colors.black,

    bottomTableReceiptBgColor: Color(0xFF1B7EAC),
    bottomTableReceiptTextColor:  Color(0xFFFFFFFF),

     topTableLoaderColor: Color(0xFF1B7EAC),
     bottomTableLoaderColor: Color(0xFF1B7EAC),
  ),

  addNewTransferJournalColor:  ModuleColors(
    topTableHeadingBgColor: Color(0xFF0f53b3),
    topTableHeadingTextColor: Color(0xFFFFFFFF),

    topTableRowBgColorSelected: Color(0xFF0f53b3).withOpacity(0.2),
    topTableRowBgColorDeleted: Color(0xFFdadada).withOpacity(0.1),
    topTableRowBgColorNormal: Color(0xFFFFFFFF),

    topTableRowTextColorDeleted: Colors.black.withOpacity(0.25),
    topTableRowTextColorNormal: Colors.black,

    topTableReceiptBgColor: Color(0xFF0f53b3),
    topTableReceiptTextColor: Color(0xFFFFFFFF),

    searchFieldBgColor: Color(0xFF0f53b3).withOpacity(0.6),
    searchFieldTextColor: Colors.black,

    bottomTableHeadingBgColor: Color.fromARGB(255, 218, 218, 218),
    bottomTableHeadingTextColor: Colors.black,

    bottomTableRowBgColorSelected: Color(0xFF0f53b3).withOpacity(0.2),
    bottomTableRowBgColorNormal: Color(0xFFFFFFFF),

    bottomTableRowTextColorDeleted: Colors.black.withOpacity(0.25),
    bottomTableRowTextColorNormal: Colors.black,

    bottomTableReceiptBgColor: Color(0xFF0f53b3),
    bottomTableReceiptTextColor:  Color(0xFFFFFFFF),

    topTableLoaderColor: Color(0xFF0f53b3),
    bottomTableLoaderColor: Color(0xFF0f53b3),
  ),

   addNewChecksColor:  ModuleColors(
     topTableHeadingBgColor: Color(0xFF0f53b3),
     topTableHeadingTextColor: Color(0xFFFFFFFF),

     topTableRowBgColorSelected: Color(0xFF0f53b3).withOpacity(0.2),
     topTableRowBgColorDeleted: Color(0xFFdadada).withOpacity(0.1),
     topTableRowBgColorNormal: Color(0xFFFFFFFF),

     topTableRowTextColorDeleted: Colors.black.withOpacity(0.25),
     topTableRowTextColorNormal: Colors.black,

     topTableReceiptBgColor: Color(0xFF0f53b3),
     topTableReceiptTextColor: Color(0xFFFFFFFF),

     searchFieldBgColor: Color(0xFF0f53b3).withOpacity(0.6),
     searchFieldTextColor: Colors.black,

     bottomTableHeadingBgColor: Color.fromARGB(255, 218, 218, 218),
     bottomTableHeadingTextColor: Colors.black,

     bottomTableRowBgColorSelected: Color(0xFF0f53b3).withOpacity(0.2),
     bottomTableRowBgColorNormal: Color(0xFFFFFFFF),

     bottomTableRowTextColorDeleted: Colors.black.withOpacity(0.25),
     bottomTableRowTextColorNormal: Colors.black,

     bottomTableReceiptBgColor: Color(0xFF0f53b3),
     bottomTableReceiptTextColor:  Color(0xFFFFFFFF),

     topTableLoaderColor: Color(0xFF0f53b3),
     bottomTableLoaderColor: Color(0xFF0f53b3),
   ),

   inventoryReportsColor:  ModuleColors(
     tableRowSelectedBgColor: Color(0xFF587058).withOpacity(0.2),
     tableRowUnSelectedBgColor: Color(0xFFFFFFFF),
     tableHeaderBgColor: Color(0xFF587058),
     tableHeaderTextColor: Color(0xFFFFFFFF),
   ),

  backgroundColor: const Color(0xFFEDF4FF),
  backgroundColorGreen: const Color(0xFFEDF4FF),
  iconColor : const Color(0xFF1A4563),
   textfieldGrey: const Color(0xffeeeeee),







 );
const TextTheme lightTextTheme = TextTheme(

  displaySmall: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1,
    color: Color(0xFF000000),
  ),
  headlineLarge: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1,
    color: Color(0xFF000000),
  ),
  titleLarge: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1,
    color: Color(0xFF000000),
  ),
  titleSmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1,
    color: Color(0xFF000000),
  ),
bodySmall: TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1,
  color: Color(0xFF000000),
)

);

class CustomTextTheme {
  static TextStyle heading1({required Color color}) {
    return TextStyle(
      fontFamily: AppConstants.retailPharmaciesFontFamily,
      fontSize: 35,
      fontWeight: FontWeight.w600,
      height: 1.33,
      color: color,
    );
  }

  static TextStyle heading2({required Color color}) {
    return TextStyle(
      fontFamily: AppConstants.retailPharmaciesFontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.33,
      color: color,
    );
  }

  static TextStyle heading3({required Color color}) {
    return TextStyle(
      fontFamily: AppConstants.retailPharmaciesFontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.25,
      color: color,
    );
  }

  static TextStyle heading4({required Color color}) {
    return TextStyle(
        fontFamily: AppConstants.retailPharmaciesFontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.72
    );
  }

  static TextStyle normalText1({required Color color}) {
    return TextStyle(
        fontFamily: AppConstants.retailPharmaciesFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.56

    );
  }

  static TextStyle normalText2({required Color color}) {
    return TextStyle(
      fontFamily: AppConstants.retailPharmaciesFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle normalText3({required Color color}) {
    return TextStyle(
      fontFamily: AppConstants.retailPharmaciesFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.56,
      color: color,
    );
  }

  static TextStyle normalText4({required Color color}) {
    return TextStyle(
      fontFamily: AppConstants.retailPharmaciesFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.42,
      color: color,
    );
  }

  static TextStyle subText1({required Color color}) {
    return TextStyle(
      fontFamily: AppConstants.retailPharmaciesFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1,
      color: color,
    );
  }

  static TextStyle subText2({required Color color}) {
    return TextStyle(
      fontFamily: AppConstants.retailPharmaciesFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1,
      color: color,
    );
  }


  static TextStyle smallText1({required Color color}) {
    return TextStyle(
      fontFamily: AppConstants.retailPharmaciesFontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1,
      color: color,
    );
  }

  static TextStyle smallText2({required Color color}) {
    return TextStyle(
        fontFamily: AppConstants.retailPharmaciesFontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1,
        color: color);
  }

  static TextStyle settingTabsText({required Color color}) {
    return TextStyle(
        fontFamily: AppConstants.retailPharmaciesFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1,
        color: color);
  }
}




BoxDecoration decoration({required bool isSelected,bool isError = false}) {
  return BoxDecoration(
      color: lightColorPalette.whiteColor.shade900,
      borderRadius: BorderRadius.circular(borderRadius),
      shape: BoxShape.rectangle,
      boxShadow: isSelected
          ? [
        BoxShadow(
          blurRadius: 14,
          color: lightColorPalette.themeColor.shade900.withOpacity(0.25),
          offset: const Offset(0, 6),
          spreadRadius: 0,
        ),
      ]
          : [],
      border: Border.all(
          color: isSelected
              ? lightColorPalette.themeColor.shade900
              : (isError ? lightColorPalette.redColor.shade800 :
          lightColorPalette.greyColor.shade900),
          width: isSelected ? 1 : 1));
}

BoxDecoration searchDecoration({required bool isSelected,bool isError = false,bool isShowFullBorderRadius = true}) {
  return BoxDecoration(
      color: isSelected ? lightColorPalette.whiteColor.shade900 : lightColorPalette.greyColor.shade900,
      borderRadius:isShowFullBorderRadius ? BorderRadius.circular(borderRadius) : BorderRadius.only(
        topLeft: Radius.circular(6),
        topRight: Radius.circular(6),
      ) ,
      shape: BoxShape.rectangle,
      /*boxShadow: isSelected
          ? [
        BoxShadow(
          blurRadius: 14,
          color: lightColorPalette.whiteColor.shade900.withOpacity(0.25),
          offset: const Offset(0, 6),
          spreadRadius: 0,
        ),
      ]
          : [],*/
      border: Border.all(
          color: isSelected
              ? lightColorPalette.whiteColor.shade900
              : (isError ? lightColorPalette.redColor.shade800 :
          lightColorPalette.greyColor.shade900),
      ));
}



const double borderRadius = 4;


class ModuleColors{
  Color tableRowSelectedBgColor;
  Color tableRowUnSelectedBgColor;
  Color tableHeaderBgColor;
  Color tableHeaderTextColor;



  Color topTableHeadingBgColor;
  Color topTableHeadingTextColor;
  Color topTableRowTextColorSelected;
  Color topTableRowTextColorDeleted;
  Color topTableRowTextColorNormal;
  Color topTableRowBgColorSelected;
  Color topTableRowBgColorDeleted;
  Color topTableRowBgColorNormal;
  Color topTableReceiptBgColor;
  Color topTableReceiptTextColor;
  Color topTableLoaderColor;


  Color searchFieldBgColor;
  Color searchFieldTextColor;

  Color bottomTableHeadingBgColor;
  Color bottomTableHeadingTextColor;
  Color bottomTableRowTextColorSelected;
  Color bottomTableRowTextColorDeleted;
  Color bottomTableRowTextColorNormal;
  Color bottomTableRowBgColorSelected;
  Color bottomTableRowBgColorDeleted;
  Color bottomTableRowBgColorNormal;
  Color bottomTableReceiptBgColor;
  Color bottomTableReceiptTextColor;

  Color bottomTableLoaderColor;

  ModuleColors({
     this.tableRowSelectedBgColor = Colors.blue,
     this.tableRowUnSelectedBgColor = Colors.blue,

     this.tableHeaderBgColor = Colors.blue,
     this.tableHeaderTextColor = Colors.blue,

     this.topTableHeadingBgColor = Colors.blue,
     this.topTableHeadingTextColor = Colors.blue,

     this.topTableRowTextColorSelected = Colors.blue,
     this.topTableRowTextColorDeleted = Colors.blue,
     this.topTableRowTextColorNormal = Colors.blue,

     this.topTableRowBgColorSelected = Colors.blue,
     this.topTableRowBgColorDeleted = Colors.blue,
     this.topTableRowBgColorNormal = Colors.blue,

     this.topTableReceiptBgColor = Colors.blue,
     this.topTableReceiptTextColor = Colors.blue,

    this.topTableLoaderColor = Colors.blue,

     this.searchFieldBgColor = Colors.blue,
     this.searchFieldTextColor = Colors.blue,

     this.bottomTableHeadingBgColor = Colors.blue,
     this.bottomTableHeadingTextColor = Colors.blue,

     this.bottomTableRowTextColorSelected = Colors.blue,
     this.bottomTableRowTextColorDeleted = Colors.blue,
     this.bottomTableRowTextColorNormal = Colors.blue,

     this.bottomTableRowBgColorSelected = Colors.blue,
     this.bottomTableRowBgColorDeleted = Colors.blue,
     this.bottomTableRowBgColorNormal = Colors.blue,

     this.bottomTableReceiptBgColor = Colors.blue,
     this.bottomTableReceiptTextColor = Colors.blue,

    this.bottomTableLoaderColor = Colors.blue
  });


}