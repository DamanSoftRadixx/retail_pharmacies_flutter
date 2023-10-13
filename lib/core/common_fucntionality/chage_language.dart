import 'dart:ui';

import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/storage/local_storage.dart';
import 'package:get/get.dart';

changeLanguage() async{
  var selectedLang = await LocalStorage.read(LocalStorage.selectedLangId) ?? LanguageEnum.en.name;
  var locale = Locale(selectedLang);
  Get.updateLocale(locale);
}
