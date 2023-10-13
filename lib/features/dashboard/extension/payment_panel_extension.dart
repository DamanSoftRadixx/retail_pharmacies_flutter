import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_fucntionality/logout/logout.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_asset/common_image.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/constants/image_resources.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/payment_method_functionality.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/screen/dashboard_screen.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_dialog.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/payment_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/*
This class extends the DashboardScreen class.
All the properties of DashboardScreen are accessible to this extension.
Extension is the way to add functionalities to existing class.
*/

extension PaymentPanel on DashboardScreen {
  //Payment panel widget is used for payment section which handle different different types of payments.
  paymentPanelWidget() {
    return Container(
      ///
      decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: Colors.black))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if(controller.selectedLeftPanelTab.value == LeftPanelTabs.dashboard) Column(
            children: [
              paymentButton(
                  imagePath: ImageResource.cash,
                  hotKeyText: AppStrings.f8.tr,
                  buttonText: AppStrings.cash.tr,
                  onTap: () {
                    controller.onPressPaymentMethods(paymentMethod : PaymentMethod.cash,);
                  }),
              paymentButton(
                  imagePath: ImageResource.humo,
                  hotKeyText: AppStrings.f9.tr,
                  buttonText: AppStrings.humo.tr,
                  onTap: () {
                    controller.onPressPaymentMethods(paymentMethod : PaymentMethod.humo);
                  }),
              paymentButton(
                  imagePath: ImageResource.uzCard,
                  hotKeyText: AppStrings.f10.tr,
                  buttonText: AppStrings.uzCard.tr,
                  onTap: () {
                    controller.onPressPaymentMethods(paymentMethod : PaymentMethod.uzCard);
                  }),
              paymentButton(
                  imagePath: ImageResource.phonelink,
                  hotKeyText: AppStrings.f12.tr,
                  buttonText: AppStrings.other.tr,
                  onTap: () {
                    controller.onPressPaymentMethods(paymentMethod : PaymentMethod.other);
                  }),
              /* paymentButton(
            imagePath: ImageResource.info,
            hotKeyText: AppStrings.f12,
            buttonText: AppStrings.insurance.tr,
          ),*/
            ],
          ),
          if(controller.selectedLeftPanelTab.value == LeftPanelTabs.transferJournal && controller.selectedRightPanelTab.value != RightPanelTabs.addNewTransferJournal) Column(
            children: [
              rightTabButtonWidget(
                  imagePath: ImageResource.addIcon,
                  hoverText: AppStrings.addNewTransfer.tr,
                  buttonText: AppStrings.addNew.tr,
                  onTap: () {
                    controller.onPressAddNewTransferButton();
                  }),
            ],
          ),
          if(controller.selectedLeftPanelTab.value == LeftPanelTabs.transferJournal && controller.selectedRightPanelTab.value == RightPanelTabs.addNewTransferJournal) Column(
            children: [
              rightTabButtonWidget(
                  imagePath: ImageResource.checkButton,
                  hoverText: AppStrings.doneButtonSmall.tr,
                  buttonText: AppStrings.doneButtonSmall.tr,
                  onTap: () {
                    controller.onPressTransferDoneButton();
                  }),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              /*paymentButton(
                  imagePath: ImageResource.vozvrat,
                  buttonText: AppStrings.returnFromBuyer.tr,
                  onTap: () {}),*/
              paymentButton(
                  imagePath: ImageResource.settings,
                  buttonText: AppStrings.settings.tr,
                  onTap: () {
                    controller.onPressSettingsButton();
                  }),
              paymentButton(
                  imagePath: ImageResource.exit,
                  buttonText: AppStrings.exit.tr,
                  onTap: () {
                    commonDialogWidget(
                        onPressOkayButton: (){
                          logout();
                        },
                        isHideCancel: false,
                        onPressCancelButton: (){
                          Get.back();
                        },
                        message: AppStrings.areYouSureYouWantToLogout.tr,
                      title: AppStrings.logout.tr
                    );
                  }),
            ],
          )
        ],
      ),
    );
  }

  //Payment button is a common button which handle ui and onclick action of payment section
  paymentButton(
      {required String imagePath,
      String hotKeyText = "",
      required Function() onTap,
      required String buttonText}) {
    return SizedBox(
      height: 70,
      child: Tooltip(
        message: buttonText,
        height: 20,
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
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
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: AssetWidget(
                      asset: Asset(type: AssetType.png, path: imagePath),
                      width: 30.w,
                      height: 30.h,
                    )),
                hotKeyText.isNotEmpty
                    ? Text(
                        hotKeyText,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  rightTabButtonWidget(
      {required String imagePath,
        String hoverText = "",
        required Function() onTap,
        required String buttonText}) {
    return SizedBox(
      height: 70,
      child: Tooltip(
        message: hoverText,
        height: 20,
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
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
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: AssetWidget(
                      asset: Asset(type: AssetType.png, path: imagePath),
                      width: 40,
                      height: 40,
                    )),
                buttonText.isNotEmpty
                    ? Text(
                  buttonText,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11.sp,
                    ),
                )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

}

