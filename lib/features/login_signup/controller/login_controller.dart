
import 'package:flutter/cupertino.dart';
import 'package:flutter_retail_pharmacies/core/common_fucntionality/dismiss_keyboard/dismiss_keyboard.dart';
import 'package:flutter_retail_pharmacies/core/common_fucntionality/validations/validations.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/models/local/validation_model.dart';
import 'package:flutter_retail_pharmacies/core/routes/routes.dart';
import 'package:flutter_retail_pharmacies/core/service/feathers_services/feathers_auth_service.dart';
import 'package:flutter_retail_pharmacies/core/storage/local_storage.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/controller/auth_dashboard_controller.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/models/network/login_response_model.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{

  FeathersAuthService feathersAuthService = FeathersAuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var emailFocusNode = FocusNode().obs;
  var passwordFocusNode = FocusNode().obs;

  var emailError = ValidationModel().obs;
  var passwordError = ValidationModel().obs;

  var isShowPassword = false.obs;


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
  }

  disposeFocusListeners() {
    emailFocusNode.value.removeListener(() {});
    passwordFocusNode.value.removeListener(() {});
  }


  void onPressLoginButton() {
    if(isValidLoginForm()){
      hitLoginApi();
    }
  }

  hitLoginApi() async{
    if(!Get.isRegistered<AuthDashboardController>()) return;
    var authDashboardController = Get.find<AuthDashboardController>();
    authDashboardController.setShowPassword(value: true);

    LoginResponseModel? response = await feathersAuthService.login(email: emailController.text,password: passwordController.text);
    print("${response.toString()}");
    authDashboardController.setShowPassword(value: false);

    if(response?.code != null && response?.code == 200){
      var accessToken = response?.accessToken ?? "";
      var email = response?.user?.email ?? "";
      var id = response?.user?.id ?? "";

      if(accessToken != ""){
        LocalStorage.storeUserData(
          email: email,
          id: id,
          token: accessToken
        );
        dismissKeyboard();
        Get.toNamed(Routes.dashboard);
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


  bool isValidLoginForm(){

    var isValid = true;

    if(emailController.text.isEmpty && passwordController.text.isEmpty){
      emailError.value.isError = true;
      emailError.value.errorMessage = AppStrings.pleaseEnterEmail.tr;
      emailError.refresh();

      passwordError.value.isError = true;
      passwordError.value.errorMessage = AppStrings.pleaseEnterPassword.tr;
      passwordError.refresh();

      isValid = false;
    }
    else{

      if(!isValidEmailField()){
        isValid = false;
      }

      if(!isValidPasswordField()){
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

  onPressSignUpButton(){
    if(Get.isRegistered<AuthDashboardController>()){
      var authDashboardController = Get.find<AuthDashboardController>();
      authDashboardController.changeAuthScreen(nextScreen: AuthSectionEnum.signUp);
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

  changeTextFieldFocus() {
    print("focus : ${emailFocusNode.value.hasFocus}");
    if (emailFocusNode.value.hasFocus) {
      if(isValidEmailField()){
        passwordFocusNode.value.requestFocus();
      }
    } else if (passwordFocusNode.value.hasFocus) {
      if(isValidPasswordField()){
        onPressLoginButton();
      }
    }
  }


  @override
  void onClose() {
    disposeFocusListeners();
    super.onClose();
  }

  void onSubmittedEmailTextField() {
    changeTextFieldFocus();
  }

  void onSubmittedPasswordTextField() {
    changeTextFieldFocus();
  }


}