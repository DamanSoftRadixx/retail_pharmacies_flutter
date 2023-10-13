import 'package:flutter_retail_pharmacies/features/login_signup/controller/auth_dashboard_controller.dart';
import 'package:get/get.dart';

class AuthDashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AuthDashboardController>(
            () => AuthDashboardController());
  }

}