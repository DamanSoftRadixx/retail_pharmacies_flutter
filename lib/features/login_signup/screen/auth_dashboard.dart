import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_asset/common_image.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/app_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/constants/image_resources.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_loader.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/controller/auth_dashboard_controller.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/controller/login_controller.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/controller/signup_controller.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/screen/login_screen.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/screen/signup_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AuthDashboardScreen extends GetView<AuthDashboardController> {
  const AuthDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorPalette.whiteColor.shade900,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              foregroundWidget(),
              Obx(() =>
              controller.showLoader.isTrue ? commonLoader() : SizedBox())
            ],
          ),
        ),
      ),
    );
  }

  loginHeadingText() {
    return AppTextWidget(
      text: AppStrings.login.tr,
      style: CustomTextTheme.heading1(
        color: lightColorPalette.blackColor.shade900,
      ),
    );
  }

  loginSubHeadingText() {
    return AppTextWidget(
      text: AppStrings.welcomeBackCatchy.tr,
      style: CustomTextTheme.heading2(
        color: lightColorPalette.blackColor.shade800,
      ),
    );
  }

  Widget foregroundWidget() {
    return Container(
      width: 1.sw,
      height: 1.sh,
      child: Row(
        children: [
          Expanded(
              child: Container(
                height: 1.sh,
                alignment: Alignment.center,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(borderRadius),
                      bottomRight: Radius.circular(borderRadius)),
                ),
                child: Container(
                  child: AssetWidget(
                    asset: Asset(
                      type: AssetType.png,
                      path: ImageResource.authenticationImage,
                    ),
                  ),
                ),
              )),
          Obx(() => getCurrentAuthScreen()),
        ],
      ),
    );
  }


  getCurrentAuthScreen(){
    if(controller.currentAuthScreen.value == AuthSectionEnum.login){
      if(Get.isRegistered<SignUpController>()){
        Get.delete<SignUpController>();
      }
      Get.put(LoginController());
      return LoginScreen();
    }else{
      if(Get.isRegistered<LoginController>()){
        Get.delete<LoginController>();
      }
      Get.put(SignUpController());
      return SignUpScreen();

    }
  }

}
