import 'package:flutter_retail_pharmacies/features/splash/controller/splash_controller.dart';
import 'package:get/get.dart';

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
