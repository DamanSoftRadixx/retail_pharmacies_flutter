
import 'package:flutter_retail_pharmacies/core/local_library/scroll_to_index.dart';
import 'package:flutter_retail_pharmacies/features/reports/model/network/stocks_response_model.dart';
import 'package:flutter_retail_pharmacies/features/reports/model/network/turnover_reports_response.dart';

class StockTabBarModel{
  String id;
  String name;
  var selectedRowIndex = -1;
  AutoScrollController scrollController;
  List<StockRowModel> sectionRowList;
  bool isShowDatePicker, isAvailableFilters;
  String? selectedDateFilterStartDate;
  String? selectedDateFilterEndDate;

  StockTabBarModel({required this.id,
    required this.scrollController,this.selectedDateFilterStartDate,
    this.selectedDateFilterEndDate,
    this.isShowDatePicker = false,this.isAvailableFilters = false,
    required this.name,this.sectionRowList = const []});
}

class StockTabGroupModel{
  String groupName;
  List<StockRowModel> rowList;
  int key;

  StockTabGroupModel({required this.groupName,required this.key,required this.rowList});
}

class StockRowModel{
  String? uuid;
  String? id;
  String? name;
  String? cost;
  int key;
  String? quantity;
  String groupName;
  bool isTableHeaderRow;
  bool isTurnOverTab;
  bool isShowNameColumn, isShowDateColumn, isShowQtyColumn;
  String? batchId;
  String? batchDate;


  TurnOverData? turnOverData;

  StockRowModel({this.isTableHeaderRow = false,
    this.groupName = "",this.uuid, this.id, this.name,this.isTurnOverTab = false,
    this.cost,
    this.isShowDateColumn = false,
    this.isShowNameColumn = true,
    this.isShowQtyColumn = true,
    this.turnOverData,
    this.batchId,
    this.batchDate,
    this.quantity, this.key = 0});
}



