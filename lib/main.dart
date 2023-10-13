import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/app/app.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/core/routes/routes.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/core/translator/localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'core/constants/app_strings.dart';

void main() {
  GetStorage.init();
  runApp(AppContainer(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final incrementKeySet = LogicalKeySet(LogicalKeyboardKey.f11 // Replace with control on Windows
      );

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit is used for dynamic sizes of fonts, radius, padding, height or width etc.
    return ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          //GetMaterialApp -> It is the requirement for Getx state management technique.
          return GetMaterialApp(
            title: AppStrings.pharmacy.tr,
            translations: LocalString(),
            //By default language used by the app is Russian
            locale: const Locale(
              'ru',
            ),
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            getPages: AppPages(),
            initialRoute: Routes.root,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: lightColorPalette.themeColor.shade900, //<-- SEE HERE
              ),
              textTheme: AppContainer.of(context).textTheme,
            ),
          );
        });
  }
}
