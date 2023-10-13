import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_retail_pharmacies/core/common_fucntionality/chage_language.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/routes/routes.dart';
import 'package:flutter_retail_pharmacies/core/storage/local_storage.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    navigateToNext();
    super.onInit();
  }

  Future navigateToNext() async {
    changeLanguage();

    Future.delayed(const Duration(seconds: 3), () async{
      print("isWeb : ${kIsWeb}");

      var token = await LocalStorage.read(LocalStorage.accessToken);
      print("accessToken : ${token}");
      token == null
          ? Get.offNamed(Routes.authDashboard)
          : Get.offNamed(Routes.dashboard);
    });
  }
}
