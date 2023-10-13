import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/*class DropDownModel extends Equatable {
  @mustCallSuper
  String dropDownValue;

  @mustCallSuper
  String dropDownId;

  DropDownModel({required this.dropDownId, required this.dropDownValue});

  @override
  // TODO: implement props
  List<Object?> get props => [dropDownId, dropDownValue];
}*/

class DropDownModel extends Equatable {
  String name;
  String dropDownId;

 DropDownModel({ this.dropDownId = "", this.name = ""});

  @override
  // TODO: implement props
  List<Object?> get props => [dropDownId, name];
}
