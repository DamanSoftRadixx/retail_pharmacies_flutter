import 'package:flutter/cupertino.dart';
import 'package:flutter_retail_pharmacies/core/common_fucntionality/validations/validations.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/models/local/validation_model.dart';
import 'package:flutter_retail_pharmacies/core/service/feathers_services/feathers_auth_service.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/controller/auth_dashboard_controller.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/models/network/signup_response_model.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{

  FeathersAuthService feathersAuthService = FeathersAuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var emailFocusNode = FocusNode().obs;
  var passwordFocusNode = FocusNode().obs;
  var confirmPasswordFocusNode = FocusNode().obs;

  var emailError = ValidationModel().obs;
  var passwordError = ValidationModel().obs;
  var confirmPasswordError = ValidationModel().obs;

  var isShowPassword = false.obs;
  var isShowConfirmPassword = false.obs;

  @override
  void onInit() {
    addFocusListeners();
    super.onInit();
  }

  addFocusListeners() {
    emailFocusNode.value.addListener(() {
      emailFocusNode.refresh();
    });
    passwordFocusNode.value.addListener(() {
      passwordFocusNode.refresh();
    });
    confirmPasswordFocusNode.value.addListener(() {
      passwordFocusNode.refresh();
    });
  }

  disposeFocusListeners() {
    emailFocusNode.value.removeListener(() {});
    passwordFocusNode.value.removeListener(() {});
    confirmPasswordFocusNode.value.removeListener(() {});
  }


  void onPressSignUpButton() {
    if(isValidSignUpForm()){
      hitRegisterApi();
    }
  }

  hitRegisterApi() async{
    if(!Get.isRegistered<AuthDashboardController>()) return;
    var authDashboardController = Get.find<AuthDashboardController>();
    authDashboardController.setShowPassword(value: true);

    SignUpResponseModel? response = await feathersAuthService.register(email: emailController.text,password: passwordController.text);
    print("${response.toString()}");
    authDashboardController.setShowPassword(value: false);

    if(response?.code != null && response?.code == 200){
      var accessToken = response?.accessToken ?? "";

      if(accessToken != ""){
        commonDialogWidget(
          title: AppStrings.success.tr,
            onPressOkayButton: () {
              authDashboardController.changeAuthScreen(nextScreen: AuthSectionEnum.login);
              Get.back();
            },
            isHideCancel: true,
            message: AppStrings.accountHasBeenCreatedSuccessfully.tr);
      }else{
        commonDialogWidget(
            onPressOkayButton: () {
              Get.back();
              /*dismissKeyboard();
            Get.toNamed(Routes.dashboard);*/
            },
            isHideCancel: true,
            message: response?.message ?? AppStrings.somethingWentWrong.tr);
      }
    }else{
      commonDialogWidget(
          onPressOkayButton: () {
            Get.back();
            /*dismissKeyboard();
            Get.toNamed(Routes.dashboard);*/
          },
          isHideCancel: true,
          message: response?.message ?? AppStrings.somethingWentWrong.tr);

    }

  }


  bool isValidSignUpForm(){

    var isValid = true;

    if(emailController.text.isEmpty && passwordController.text.isEmpty && confirmPasswordController.text.isEmpty){
      emailError.value.isError = true;
      emailError.value.errorMessage = AppStrings.pleaseEnterEmail.tr;
      emailError.refresh();

      passwordError.value.isError = true;
      passwordError.value.errorMessage = AppStrings.pleaseEnterPassword.tr;
      passwordError.refresh();

      confirmPasswordError.value.isError = true;
      confirmPasswordError.value.errorMessage = AppStrings.pleaseEnterConfirmPassword.tr;
      confirmPasswordError.refresh();

      isValid = false;
    }
    else{
      if(!isValidEmailField()){
        isValid = false;
      }

      if(!isValidPasswordField()){
        isValid = false;
      }

      if(!isValidConfirmPassword()){
        isValid = false;
      }
    }
    return isValid;
  }

  void onChangedPasswordTextField() {
    if(isValidPassword(passwordController.text)){
      passwordError.value.isError = false;
      passwordError.value.errorMessage = "";
      passwordError.refresh();
    }
  }

  void onChangedConfirmPasswordTextField() {
    if(passwordController.text == confirmPasswordController.text){
      confirmPasswordError.value.isError = false;
      confirmPasswordError.value.errorMessage = "";
      confirmPasswordError.refresh();
    }
  }

  void onChangedEmailTextField() {
    if(isValidateEmail(emailController.text)){
      emailError.value.isError = false;
      emailError.value.errorMessage = "";
      emailError.refresh();
    }
  }

  onPressHideShowPasswordIcon(){
    isShowPassword.value = !(isShowPassword.value);
    isShowPassword.refresh();
  }

  onPressHideShowConfirmPasswordIcon(){
    isShowConfirmPassword.value = !(isShowConfirmPassword.value);
    isShowConfirmPassword.refresh();
  }

  onPressLoginButton(){
    if(Get.isRegistered<AuthDashboardController>()){
      var authDashboardController = Get.find<AuthDashboardController>();
      authDashboardController.changeAuthScreen(nextScreen: AuthSectionEnum.login);

    }
  }


  bool isValidEmailField(){
    var isValid = true;
    if (emailController.text.isEmpty) {
      emailError.value.isError = true;
      emailError.value.errorMessage = AppStrings.pleaseEnterEmail.tr;
      emailError.refresh();
      isValid = false;
    } else if (!isValidateEmail(emailController.text)) {
      emailError.value.isError = true;
      emailError.value.errorMessage = AppStrings.pleaseEnterValidEmail.tr;
      emailError.refresh();
      isValid = false;
    } else {
      emailError.value.isError = false;
      emailError.refresh();
    }

    return isValid;
  }

  bool isValidPasswordField(){
    var isValid = true;
    if (passwordController.text.isEmpty) {
      passwordError.value.isError = true;
      passwordError.value.errorMessage = AppStrings.pleaseEnterPassword.tr;
      passwordError.refresh();
      isValid = false;
    } else if (!isValidPassword(passwordController.text)) {
      passwordError.value.isError = true;
      passwordError.value.errorMessage =
          AppStrings.yourPasswordMustBeAtleast8Char.tr;
      passwordError.refresh();
      isValid = false;
    } else {
      passwordError.value.isError = false;
      passwordError.refresh();
    }

    return isValid;
  }

  bool isValidConfirmPassword(){
    var isValid = true;
    if(confirmPasswordController.text.isEmpty){
      confirmPasswordError.value.isError = true;
      confirmPasswordError.value.errorMessage = AppStrings.pleaseEnterPassword.tr;
      confirmPasswordError.refresh();
      isValid = false;
    }else if(confirmPasswordController.text != passwordController.text){
      confirmPasswordError.value.isError = true;
      confirmPasswordError.value.errorMessage = AppStrings.passwordAndConfirmPasswordshouldMatch.tr;
      confirmPasswordError.refresh();
      isValid = false;
    }else{
      confirmPasswordError.value.isError = false;
      confirmPasswordError.refresh();
    }

    return isValid;
  }

  changeTextFieldFocus() {
    print("focus : ${emailFocusNode.value.hasFocus}");
    if (emailFocusNode.value.hasFocus) {
      if(isValidEmailField()){
        passwordFocusNode.value.requestFocus();
      }
    } else if (passwordFocusNode.value.hasFocus) {
      if(isValidPasswordField()){
        confirmPasswordFocusNode.value.requestFocus();
      }
    } else if (confirmPasswordFocusNode.value.hasFocus) {
      if(isValidConfirmPassword()){
        onPressSignUpButton();
      }
    }
  }

  void onSubmittedEmailTextField() {
    changeTextFieldFocus();
  }

  void onSubmittedPasswordTextField() {
    changeTextFieldFocus();
  }

  void onSubmittedConfirmPasswordTextField() {
    changeTextFieldFocus();
  }

  @override
  void onClose() {
    disposeFocusListeners();
    super.onClose();
  }

}