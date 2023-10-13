
import 'package:flutter/cupertino.dart';
import 'package:flutter_retail_pharmacies/core/local_library/scroll_to_index.dart';
import 'package:flutter_retail_pharmacies/core/models/local/dropdown_model.dart';

class AutoCompleteTextFieldModel<T extends DropDownModel>{
  TextEditingController textField;
  FocusNode focusNode;
  bool isShowLoader;
  List<T> autoCompleteList;
  T selectedValue;
  int currentIndex;
  AutoScrollController scrollController;
  //Below variables are used to implement the pagination functionality
  bool loadMore;
  bool isPaginationEnd;
  int offsetCount;
  int paginationLength;
  bool isEnableEditing;



  AutoCompleteTextFieldModel({required this.textField,required this.focusNode,
    required this.isShowLoader,
    required this.paginationLength,
    required this.isPaginationEnd,
    required this.offsetCount,
    required this.selectedValue,
    required this.scrollController,
    required this.currentIndex,
    required this.autoCompleteList,
    required this.loadMore,
    required this.isEnableEditing
  });
}




