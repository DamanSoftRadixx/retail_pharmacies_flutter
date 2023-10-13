import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/common_textfield.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/constants/language_list.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/models/local/dropdown_model.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/settings/controller/settings_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  var controller = Get.put(SettingsController());

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.3),
      body: Center(
        child: Container(
          width: 0.60.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: lightColorPalette.whiteColor.shade900,
          ),
          margin: EdgeInsets.symmetric(vertical: 40.h),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Obx(() => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color:
                    lightColorPalette.greyColor.shade900.withOpacity(0.7),
                    child: Column(
                      children: [
                        profileWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.separated(
                              itemCount: controller.settingTabList.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 10,
                                );
                              },
                              itemBuilder: (context, index) {
                                return settingListItem(index: index);
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: lightColorPalette.greyColor.shade900,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color:
                    lightColorPalette.greyColor.shade900.withOpacity(0.3),
                    padding: EdgeInsets.only(left: 30, bottom: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.cancel_outlined, size: 18),
                              ],
                            ),
                          ),
                        ),
                       rightSideSectionUi()
                      ],
                    ),
                  ),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget rightSideSectionUi(){
    var selectedTab = controller.settingTabList[controller.selectedTabIndex.value];

    if(selectedTab.id == SettingTabsEnum.language.name){
      return Container(
        padding: EdgeInsets.only(top: 30, right: 30),
        width: 250,
        child: Obx(() => dropdownField(
            isError: controller.languageError.value,
            errorMsg:
            controller.languageErrorMessage.value,
            hint: AppStrings.selectLanguage.tr,
            title: AppStrings.selectLanguage.tr,
            selectedValue: controller
                .selectedLanguageDropdownModel.value,
            onClick: (DropDownModel value) {
              controller.onSelectLanguageDropdown(
                  value: value);
              controller.languageError.value = false;
            },
            list: languageList,
            isExpanded: true)),
      );
    }

    return Container();
  }

  profileWidget(){
    return Row(
      children: [
        Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                lightColorPalette.greyColor.shade900),
            child: Icon(
              Icons.person,
              size: 40,
            )),
        SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ramandeep Kaur",
              style: CustomTextTheme.normalText1(
                  color: lightColorPalette
                      .blackColor.shade900),
            ),
            SizedBox(
              height: 2,
            ),
            Text("Drug Store"),
          ],
        )
      ],
    );
  }

  settingListItem({required int index}) {
    var data = controller.settingTabList[index];
    return GestureDetector(
      onTap: (){
        controller.onTapSettingListItem(index: index);
      },
      child: Obx(() => Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: index == controller.selectedTabIndex.value ?
            lightColorPalette.themeColor.shade900.withOpacity(0.6) :
            Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(data.icon),
            SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text('${data.name}',
                style: CustomTextTheme.settingTabsText(
                    color: index == controller.selectedTabIndex.value ?
                    lightColorPalette.whiteColor.shade900 :
                    lightColorPalette.blackColor.shade900),),
            ),
          ],
        ),
      )),
    );
  }
}
