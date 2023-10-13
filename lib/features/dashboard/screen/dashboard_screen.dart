import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/enums/enums.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/add_new_Transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/screens/add_new_transfer_journal_screen.dart';
import 'package:flutter_retail_pharmacies/features/check_details/controller/check_details_controller.dart';
import 'package:flutter_retail_pharmacies/features/check_details/screens/check_details_screen.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/dashboard_contoller.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/extension/bottom_panel_extension.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/extension/left_Side_panel_extension.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/extension/payment_panel_extension.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/extension/search_panel_extension.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/extension/top_panel_extension.dart';
import 'package:flutter_retail_pharmacies/features/reports/controller/inventory_reports_controller.dart';
import 'package:flutter_retail_pharmacies/features/reports/screens/inventory_reports_screen.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/screens/transfer_journal_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/*
Dashboard screen is our main screen which carry different - different panel like
top panel, search panel , bottom panel , payment panel.
*/

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        controller.onTapAnywhereOnTheScreen();
      },
      child: Scaffold(
        body: Obx(
          () => Row(
            children: [
              SizedBox(
                width: 65,
                child: leftSidePanelWidget(),
              ),
              Expanded(
                child: getMiddleScreen(),
              ),
              SizedBox(
                width: 60,
                child: paymentPanelWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  getMiddleScreen() {
    if (controller.selectedLeftPanelTab.value == LeftPanelTabs.checkJournal){

      if(Get.isRegistered<TransferJournalController>()){
        Get.delete<TransferJournalController>();
      }
      if(Get.isRegistered<AddNewTransferJournalController>()){
        Get.delete<AddNewTransferJournalController>();
      }
      if(Get.isRegistered<InventoryReportsController>()){
        Get.delete<InventoryReportsController>();
      }

      Get.put(CheckDetailsController());
      return CheckDetailsScreen();
    }
    else if (controller.selectedLeftPanelTab.value ==
        LeftPanelTabs.transferJournal) {
      if(Get.isRegistered<CheckDetailsController>()){
        Get.delete<CheckDetailsController>();
      }
      if(Get.isRegistered<InventoryReportsController>()){
        Get.delete<InventoryReportsController>();
      }

      if (controller.selectedRightPanelTab.value ==
          RightPanelTabs.addNewTransferJournal) {
        if(Get.isRegistered<TransferJournalController>()){
          Get.delete<TransferJournalController>();
        }

        Get.put(AddNewTransferJournalController());
        return AddNewTransferJournalScreen();
      } else {
        if(Get.isRegistered<AddNewTransferJournalController>()){
          Get.delete<AddNewTransferJournalController>();
        }

        Get.put(TransferJournalController());
        return TransferJournalScreen();
      }
    }
    else if (controller.selectedLeftPanelTab.value ==
        LeftPanelTabs.inventoryReports){
      if(Get.isRegistered<TransferJournalController>()){
        Get.delete<TransferJournalController>();
      }
      if(Get.isRegistered<AddNewTransferJournalController>()){
        Get.delete<AddNewTransferJournalController>();
      }
      if(Get.isRegistered<CheckDetailsScreen>()){
        Get.delete<CheckDetailsScreen>();
      }

      Get.put(InventoryReportsController());
      return InventoryReportsScreen();
    }
    else {
      if(Get.isRegistered<AddNewTransferJournalController>()){
        Get.delete<AddNewTransferJournalController>();
      }
      if(Get.isRegistered<CheckDetailsController>()){
        Get.delete<CheckDetailsController>();
      }
      if(Get.isRegistered<TransferJournalController>()){
        Get.delete<TransferJournalController>();
      }
      if(Get.isRegistered<InventoryReportsController>()){
        Get.delete<InventoryReportsController>();
      }

      return Column(
        children: [
          Flexible(
            flex: 5,
            child: topPanelWidget(),
          ),
          SizedBox(
            height: 40.h,
            child: searchPanelWidget(),
          ),
          Flexible(
            flex: 4,
            child: bottomPanelWidget(),
          )
        ],
      );
    }
  }
}
