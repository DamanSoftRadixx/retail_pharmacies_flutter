import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/transfer_journal_controller.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/screens/extensions/medicine_receipt_table_ui_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/screens/extensions/transfer_list_table_ui_extension.dart';
import 'package:get/get.dart';

class TransferJournalScreen extends StatelessWidget {
  var controller = Get.put(TransferJournalController());

  TransferJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Flexible(
          flex: 4,
          child: checkPaymentPanelWidget(),
        ),
        Flexible(
          flex: 5,
          child: medicinePanelWidget(),
        ),
      ],
    ));
  }

}
