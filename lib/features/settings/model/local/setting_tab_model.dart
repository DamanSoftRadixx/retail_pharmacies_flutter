import 'package:flutter/cupertino.dart';

class SettingTabModel{
  String name;
  IconData icon;
  bool isSelected;
  String id;

  SettingTabModel({required this.id,required this.name,required this.icon,required this.isSelected});

}