import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:get/get.dart';
class AuthDashboardController extends GetxController{

  var showLoader = false.obs;
  var currentAuthScreen = AuthSectionEnum.login.obs;

  @override
  void onInit() {
    super.onInit();
  }

  setShowPassword({required bool value}){
    showLoader(value);
  }

  changeAuthScreen({required AuthSectionEnum nextScreen}){
    currentAuthScreen.value = nextScreen;
    currentAuthScreen.refresh();
  }

}