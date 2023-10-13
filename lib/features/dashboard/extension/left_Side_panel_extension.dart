import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_asset/common_image.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/constants/image_resources.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/top_table_functionality.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/screen/dashboard_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/*
This class extends the DashboardScreen class.
All the properties of DashboardScreen are accessible to this extension.
Extension is the way to add functionalities to existing class.
*/

extension LeftSidePanel on DashboardScreen {
  //Payment panel widget is used for payment section which handle different different types of payments.
  leftSidePanelWidget() {
    return Container(
      ///
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Colors.black))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          paymentButton(
              imagePath: ImageResource.homeIcon,
              hotKeyText: AppStrings.dashboard.tr,
              assetType: AssetType.svg,
              buttonText: AppStrings.dashboard.tr,
              backGroundColor: controller.selectedLeftPanelTab.value == LeftPanelTabs.dashboard ? lightColorPalette.greyColor.shade900 : Colors.transparent,
              onTap: () {
                controller.setCurrentLeftPanelTab(currentTab: LeftPanelTabs.dashboard);
              }),
          paymentButton(
              imagePath: ImageResource.iconReceipt,
              hotKeyText: AppStrings.check.tr,
              buttonText: AppStrings.check.tr,
              backGroundColor: controller.selectedLeftPanelTab.value == LeftPanelTabs.checkJournal ? lightColorPalette.greyColor.shade900 : Colors.transparent,
              onTap: () {
                controller.setCurrentLeftPanelTab(currentTab: LeftPanelTabs.checkJournal);
              }),

          paymentButton(
              imagePath: ImageResource.transferJournalIcon,
              hotKeyText: AppStrings.transfer.tr,
              buttonText: AppStrings.transfer.tr,
              backGroundColor: controller.selectedLeftPanelTab.value == LeftPanelTabs.transferJournal ? lightColorPalette.greyColor.shade900 : Colors.transparent,
              onTap: () {
                controller.setCurrentLeftPanelTab(currentTab: LeftPanelTabs.transferJournal);
              }),

          paymentButton(
              imagePath: ImageResource.reports,
              hotKeyText: AppStrings.reports.tr,
              buttonText: AppStrings.reports.tr,
              backGroundColor: controller.selectedLeftPanelTab.value == LeftPanelTabs.inventoryReports ? lightColorPalette.greyColor.shade900 : Colors.transparent,
              onTap: () {
                controller.setCurrentLeftPanelTab(currentTab: LeftPanelTabs.inventoryReports);
              }),
        ],
      ),
    );
  }

  //Payment button is a common button which handle ui and onclick action of payment section
  paymentButton(
      {required String imagePath,
      String hotKeyText = "",
      required Function() onTap,
        AssetType assetType = AssetType.png,
      required String buttonText,Color? backGroundColor}) {
    return SizedBox(
      height: 74,
      child: Tooltip(
        message: buttonText,
        height: 20,
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: backGroundColor ?? Colors.transparent,
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: AssetWidget(
                      asset: Asset(type: assetType, path: imagePath),
                      width: 30.w,
                      height: 30.h,
                    )),
                hotKeyText.isNotEmpty
                    ? Flexible(
                      child: Text(
                          hotKeyText,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.sp,
                          ),
                        ),
                    )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
