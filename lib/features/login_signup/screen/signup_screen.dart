import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_button/common_button.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_button/custom_icon_button.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/text/app_text_widget.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/common_textfield.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/controller/signup_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return signupWidget();
  }

  signUpHeadingText() {
    return AppTextWidget(
      text: AppStrings.signup.tr,
      style: CustomTextTheme.heading1(
        color: lightColorPalette.blackColor.shade900,
      ),
    );
  }

  signUpSubHeadingText() {
    return AppTextWidget(
      text: AppStrings.createAccount.tr,
      style: CustomTextTheme.heading2(
        color: lightColorPalette.blackColor.shade800,
      ),
    );
  }

  Widget signupWidget() {
    return Container(
      height: 1.sh,
      width: 1.sw * 0.4,
      color: Colors.transparent,
      padding: EdgeInsets.only(left: 30,right: 50, top: 20,bottom: 20),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            signUpHeadingText(),
            SizedBox(
              height: 10,
            ),
            signUpSubHeadingText(),
            SizedBox(
              height: 50,
            ),
            emailTextFieldWidget(),
            SizedBox(
              height: 20,
            ),
            passwordTextFieldWidget(),
            SizedBox(
              height: 20,
            ),
            confirmPasswordTextFieldWidget(),
            signUpButtonWidget(),

            showLoginButton()
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
        onFieldSubmitted: (value){
          controller.onSubmittedEmailTextField();
        },
        inputFormatter: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
        ],
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
        title: "",
        inputFormatter: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
        ],
        onPress: (){
          controller.onPressHideShowPasswordIcon();
        },
        onFieldSubmitted: (value){
          controller.onSubmittedPasswordTextField();
        },
        passwordVisible: controller.isShowPassword.value,
        onChanged: (value) {
          controller.onChangedPasswordTextField();
        }));
  }

  confirmPasswordTextFieldWidget() {
    return Obx(() => commonPasswordText(
        controller: controller.confirmPasswordController,
        focusNode: controller.confirmPasswordFocusNode.value,
        isError: controller.confirmPasswordError.value.isError,
        errorMsg: controller.confirmPasswordError.value.errorMessage,
        hint: AppStrings.confirmPassword.tr,
        leadingIcon: Icons.lock,
        title: "",
        inputFormatter: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
        ],
        onPress: (){
          controller.onPressHideShowConfirmPasswordIcon();
        },
        onFieldSubmitted: (value){
          controller.onSubmittedConfirmPasswordTextField();
        },
        passwordVisible: controller.isShowConfirmPassword.value,
        onChanged: (value) {
          controller.onChangedConfirmPasswordTextField();
        }));
  }

  signUpButtonWidget() {
    return CommonButton(
        commonButtonBottonText: AppStrings.signup.tr,
        onPress: () {
          controller.onPressSignUpButton();
        }).paddingOnly(top: 50.h);
  }

  showLoginButton() {
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
            controller.onPressLoginButton();
          },
          child: AppTextWidget(
            style: CustomTextTheme.normalText1(
                color: lightColorPalette.themeColor.shade900),
            text: AppStrings.login.tr,
          ),
        )
      ],
    ).paddingOnly(
      top: 28.h,
      bottom: 29.h,
    );
  }
}
