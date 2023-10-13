import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_button/common_button.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_button/custom_icon_button.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/app_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/common_textfield.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/controller/login_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loginWidget();
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

  loginWidget(){
    return Container(
      height: 1.sh,
      width: 1.sw * 0.4,
      color: Colors.transparent,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 30,right: 50, top: 20,bottom: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loginHeadingText(),
            SizedBox(
              height: 10,
            ),
            loginSubHeadingText(),
            SizedBox(
              height: 50,
            ),
            emailTextFieldWidget(),
            SizedBox(
              height: 20,
            ),
            passwordTextFieldWidget(),
            loginButtonWidget(),

            showSignupButton()
          ],
        ),
      ),
    );
  }

  emailTextFieldWidget() {
    return Obx(() => commonTextFieldWidgetAuth(
        controller: controller.emailController,
        focusNode: controller.emailFocusNode.value,
        isError: controller.emailError.value.isError,
        leadingIcon: Icons.email,
        errorMsg: controller.emailError.value.errorMessage,
        hint: AppStrings.email.tr,
        inputFormatter: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
        ],
        onFieldSubmitted: (value){
          controller.onSubmittedEmailTextField();
        },
        onChanged: (value) {
          controller.onChangedEmailTextField();
        }));
  }

  passwordTextFieldWidget() {
    return Obx(() => commonPasswordText(
        controller: controller.passwordController,
        focusNode: controller.passwordFocusNode.value,
        isError: controller.passwordError.value.isError,
        errorMsg: controller.passwordError.value.errorMessage,
        hint: AppStrings.password.tr,
        leadingIcon: Icons.lock,
        inputFormatter: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
        ],
        title: "",
        onPress: (){
          controller.onPressHideShowPasswordIcon();
        },
        onFieldSubmitted: (value){
          controller.onSubmittedPasswordTextField();
          return false;
        },
        passwordVisible: controller.isShowPassword.value,
        onChanged: (value) {
          controller.onChangedPasswordTextField();
        }));
  }

  loginButtonWidget() {
    return CommonButton(
        commonButtonBottonText: AppStrings.login.tr,
        onPress: () {
          controller.onPressLoginButton();
        }).paddingOnly(top: 50.h);
  }

  showSignupButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: AppTextWidget(
            style:
            CustomTextTheme.normalText1(color: lightColorPalette.blackColor.shade900),
            text: AppStrings.dontHaveAccount.tr,
            textAlign: TextAlign.center,
          ),
        ),
        CustomInkwell(
          padding: EdgeInsets.zero,
          onTap: () {
            controller.onPressSignUpButton();
          },
          child: AppTextWidget(
            style: CustomTextTheme.normalText1(
                color: lightColorPalette.themeColor.shade900),
            text: AppStrings.signup.tr,
          ),
        )
      ],
    ).paddingOnly(
      top: 28.h,
      bottom: 29.h,
    );
  }
}
