import 'package:flutter_retail_pharmacies/core/common_fucntionality/chage_language.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/constants/language_list.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/models/local/dropdown_model.dart';
import 'package:flutter_retail_pharmacies/core/storage/local_storage.dart';
import 'package:flutter_retail_pharmacies/features/settings/model/local/setting_tab_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


class SettingsController extends GetxController {
  //Language
  RxString languageErrorMessage = "".obs;
  RxBool languageError = false.obs;
  var selectedLanguageDropdownModel = DropDownModel().obs;
  var settingTabList = <SettingTabModel>[].obs;
  var selectedTabIndex = 0.obs;


  @override
  void onInit() {
    initSettingTabList();
    initLanguageList();
    super.onInit();
  }

  initSettingTabList(){
    settingTabList.value = [
      SettingTabModel(
          id: SettingTabsEnum.language.name,
          name: AppStrings.language.tr,
          icon: Icons.settings,
          isSelected: true),
      SettingTabModel(
          id: SettingTabsEnum.other.name,
          name: AppStrings.others.tr,
          icon: Icons.other_houses,
          isSelected: false)
    ];
  }

  initLanguageList() async{
    var selectedLang = await LocalStorage.read(LocalStorage.selectedLangId) ?? LanguageEnum.en.name;
    for(var object in languageList){
      if(object.dropDownId == selectedLang){
        selectedLanguageDropdownModel.value = object;
      }
    }
  }

  onTapSettingListItem({required int index}){
    print("onTap");
    selectedTabIndex.value = index;
    selectedTabIndex.refresh();
  }

  onSelectLanguageDropdown({required DropDownModel value}) async {
    selectedLanguageDropdownModel.value = value;
    await LocalStorage.write(
        LocalStorage.selectedLangId, selectedLanguageDropdownModel.value.dropDownId);
    changeLanguage();
  }

}
