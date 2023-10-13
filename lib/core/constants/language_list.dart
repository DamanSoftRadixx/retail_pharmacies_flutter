import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/models/local/dropdown_model.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

var languageList = [
DropDownModel(dropDownId: LanguageEnum.en.name,name: AppStrings.english.tr),
DropDownModel(dropDownId: LanguageEnum.ru.name,name: AppStrings.russian.tr)
];