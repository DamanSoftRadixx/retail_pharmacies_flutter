import 'package:flutter_retail_pharmacies/features/dashboard/controller/dashboard_contoller.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/add_quantity_popup_functionality.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/top_table_functionality.dart';

// This extension contains the logical part related to bottom table.
extension BottomTableFunctionality on DashboardController{

  onTapBottomTableItem({required int index}){
    changeItemStatusToSelected(index: index);
  }

  changeItemStatusToSelected({required int index}){
    unselectTopTableRow();
    selectedIndexBottom.value=index;
    selectedIndexTop.value = -1;
    bottomTableFocusBool = true;
    bottomTableList.refresh();
  }

  onDoubleTapBottomTableItem({required int index}){
    changeItemStatusToSelected(index: index);
    openQuantityPopUp();
  }


  unselectBottomTableRow(){
    bottomTableFocusBool = false;
    selectedIndexBottom.value = -1;
    bottomTableList.refresh();
  }

}