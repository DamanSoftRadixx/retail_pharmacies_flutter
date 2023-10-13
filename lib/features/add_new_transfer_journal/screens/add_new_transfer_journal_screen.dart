import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/autocomplete_textfield.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/controller/add_new_Transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/screens/extensions/medicine_receipt_table_ui_extension.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/screens/extensions/search_table_ui_extension.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddNewTransferJournalScreen extends StatelessWidget {
  var controller = Get.put(AddNewTransferJournalController());

  AddNewTransferJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
    alignment: Alignment.center,
      children: [
        Column(
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
        ),
        if(controller.isShowLoader.isTrue) commonLoader(color: lightColorPalette.addNewTransferJournalColor.topTableLoaderColor)
      ],
    ));
  }




}
