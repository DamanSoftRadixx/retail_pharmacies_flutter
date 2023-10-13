import 'package:flutter_retail_pharmacies/core/routes/routes.dart';
import 'package:flutter_retail_pharmacies/core/storage/local_storage.dart';
import 'package:get/get.dart';


void logout() async{
  await LocalStorage.erase();
  Get.offAllNamed(Routes.authDashboard);
}