import 'package:flutter_retail_pharmacies/core/constants/app_constants.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/binding/dashboard_binding.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/screen/dashboard_screen.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/binding/auth_dashboard_binding.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/screen/auth_dashboard.dart';
import 'package:flutter_retail_pharmacies/features/login_signup/screen/login_screen.dart';
import 'package:flutter_retail_pharmacies/features/splash/binding/splash_binding.dart';
import 'package:flutter_retail_pharmacies/features/splash/screens/splashScreen.dart';
import 'package:get/get.dart';

// Routes class is used for route management

class Routes {
  Routes._();

  static const String root = "/";
  static const String dashboard = "/dashboard";
  static const String authDashboard = "/authDashboard";
  static const String addNewTransferJournalScreen = "/addNewTransferJournalScreen";
}
List<GetPage> AppPages() => [
  GetPage(
    name: Routes.root,
    page: () => const SplashScreen(),
    fullscreenDialog: true,
    binding: SplashScreenBinding(),
    transition: AppConstants.transition,
    transitionDuration:
    const Duration(milliseconds: AppConstants.transitionDuration),
  ),
  GetPage(
    name: Routes.dashboard,
    page: () =>  DashboardScreen(),
    fullscreenDialog: true,
    binding: DashboardBinding(),
    transition: AppConstants.transition,
    transitionDuration:
    const Duration(milliseconds: AppConstants.transitionDuration),
  ),
  GetPage(
    name: Routes.authDashboard,
    page: () => const AuthDashboardScreen(),
    fullscreenDialog: true,
    binding: AuthDashboardBinding(),
    transition: AppConstants.transition,
    transitionDuration:
    const Duration(milliseconds: AppConstants.transitionDuration),
  ),

];