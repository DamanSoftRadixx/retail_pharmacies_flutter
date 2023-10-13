import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_loader/common_loader.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/textfields/common_textfield.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/wrap_scroll_widget/common_auto_scrool_wrap_widget.dart';
import 'package:flutter_retail_pharmacies/core/models/local/auto_complete_textfield_model.dart';
import 'package:flutter_retail_pharmacies/core/models/local/dropdown_model.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/common_loader.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/widget/no_data_found_widget.dart';
import 'package:get/get.dart';

class AutoCompleteDropDownTextField extends StatefulWidget {
  Future<List<DropDownModel>> Function(String value) onChanged;
  Function() onTap;
   Function() onTapTrailingIcon;
  Future<dynamic> Function() onTapCloseIcon;
  Function(int index) onTapListItem;
  Function(int index) onDoubleTapListItem;
  Rx<AutoCompleteTextFieldModel> autoCompleteTextFieldModel;
  String textFieldLabel;
  String textFieldHint;
  static int animationTime = 200;

  static late AnimationController animationController;
  static late Animation<double> expandAnimation;
  static late Animation<double> rotateAnimation;
  static OverlayEntry? overlayEntry;

  AutoCompleteDropDownTextField({
    required this.onChanged,
    required this.autoCompleteTextFieldModel,
    required this.onTapTrailingIcon,
    required this.textFieldLabel,
    required this.textFieldHint,
    required this.onTapListItem,
    required this.onDoubleTapListItem,
    required this.onTapCloseIcon,
    required this.onTap
    }){
  }

  static removeOverlay() async{
    await AutoCompleteDropDownTextField.animationController.reverse();
    removeHighlightOverlay();
  }

  // Remove the OverlayEntry.
  static void removeHighlightOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  State<AutoCompleteDropDownTextField> createState() => _AutoCompleteDropDownTextFieldState();
}

class _AutoCompleteDropDownTextFieldState extends State<AutoCompleteDropDownTextField> with SingleTickerProviderStateMixin{
  final LayerLink _layerLink = LayerLink();

  var parentConstraints = BoxConstraints();
  var offset = Offset(0,0).obs;
  var size = Size(0, 0).obs;

  @override
  void initState() {
    animationControllerInitialization();
    super.initState();
  }

  animationControllerInitialization(){
    AutoCompleteDropDownTextField.animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: AutoCompleteDropDownTextField.animationTime));
    AutoCompleteDropDownTextField.expandAnimation = CurvedAnimation(
      parent: AutoCompleteDropDownTextField.animationController,
      curve: Curves.easeInOut,
    );
    AutoCompleteDropDownTextField.rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: AutoCompleteDropDownTextField.animationController,
      curve: Curves.easeInOut,
    ));
  }


  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: LayoutBuilder(
          builder: (context, constraints) {
            parentConstraints = constraints;
            print("width : ${constraints.maxWidth}");
            return Stack(
              clipBehavior: Clip.none,
              children: [
            Obx(() => commonSearchField(
                controller: widget.autoCompleteTextFieldModel.value.textField,
                focusNode: widget.autoCompleteTextFieldModel.value.focusNode,
                leadingIcon: Icons.search,
                label: widget.textFieldLabel,
                isSelected: widget.autoCompleteTextFieldModel.value.isEnableEditing,
                hint:  widget.textFieldHint,
                trailingIcon: Icons.add,
                onTapTrailingIcon: (){
                  AutoCompleteDropDownTextField.removeOverlay();
                  widget.onTapTrailingIcon();
                  widget.autoCompleteTextFieldModel.value.textField.text = widget.autoCompleteTextFieldModel.value.selectedValue.name;
                  Future.delayed(Duration(milliseconds: AutoCompleteDropDownTextField.animationTime)).then((value) {
                    widget.autoCompleteTextFieldModel.value.isEnableEditing = false;
                    widget.autoCompleteTextFieldModel.refresh();
                  });

                },
                onTapClose: () async{
                  await widget.onTapCloseIcon();
                  if(widget.autoCompleteTextFieldModel.value.isEnableEditing){
                    overlayPositionCoordinates();
                  }
                },
                onTap: (){
                  addOverlay();
                  widget.onTap();
                },
                onChanged: (value) async {
                  addOverlay();
                  await widget.onChanged(value);
                  overlayPositionCoordinates();
                })),
              ],
            );
          }),
    );
  }


  OverlayEntry _createOverlayEntry() {
    // Remove the existing OverlayEntry.
    AutoCompleteDropDownTextField.removeHighlightOverlay();

    assert(AutoCompleteDropDownTextField.overlayEntry == null);
    overlayPositionCoordinates();


    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => GestureDetector(
       /* onTap: () {
          AutoCompleteDropDownTextField.removeOverlay();
          widget.autoCompleteTextFieldModel.value.textField.text = widget.autoCompleteTextFieldModel.value.selectedValue.dropDownValue;
          Future.delayed(Duration(milliseconds: AutoCompleteDropDownTextField.animationTime)).then((value) {
            widget.autoCompleteTextFieldModel.value.isEnableEditing = false;
            widget.autoCompleteTextFieldModel.refresh();
          });
          },*/
        behavior: HitTestBehavior.translucent,
        // full screen container to register taps anywhere and close drop down
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Obx(() => Positioned(
                left: offset.value.dx,
                top: offset.value.dy + size.value.height + 0,
                width:parentConstraints.maxWidth,
                child: CompositedTransformFollower(
                  offset: Offset(0, size.value.height),
                  link: _layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: 0,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: AutoCompleteDropDownTextField.expandAnimation,
                      child: ConstrainedBox(
                        constraints:
                        BoxConstraints(
                          maxHeight: 200,
                        ),
                        child: widget.autoCompleteTextFieldModel.value.isShowLoader == true ? commonLoader() :widget.autoCompleteTextFieldModel.value.autoCompleteList.isEmpty
                            ? noDataFound()
                            : Container(
                          // padding: EdgeInsets.only(top: 10,bottom: 10),
                          decoration: BoxDecoration(
                              color: lightColorPalette.whiteColor.shade900,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6)
                              ),
                              shape: BoxShape.rectangle,
                              border:  Border.all(
                                  color: lightColorPalette.greyColor.shade900, width: 0.5)
                          ),
                          child: Column(
                            children: [
                              Expanded(child: ListView.separated(
                                  controller: widget.autoCompleteTextFieldModel.value.scrollController,
                                  separatorBuilder:(context, index){
                                    return Divider(height: 0,);
                                  },
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: widget.autoCompleteTextFieldModel.value.autoCompleteList.length,
                                  itemBuilder: (context, index) {
                                    return listItemWidget(index: index);
                                  })),

                              Visibility(
                                  visible:widget.autoCompleteTextFieldModel.value.loadMore == true,
                                  child: commonRefreshLoader(color: lightColorPalette.themeColor.shade900))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  overlayPositionCoordinates(){
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    size.value = renderBox.size;
    offset.value = renderBox.localToGlobal(Offset.zero);
    widget.autoCompleteTextFieldModel.refresh();
    offset.refresh();
    size.refresh();
  }


  listItemWidget({required int index}) {
    var listItem = widget.autoCompleteTextFieldModel.value.autoCompleteList[index];

    return wrapScrollTag(
        index: index,
        autoScrollController: widget.autoCompleteTextFieldModel.value.scrollController,
      child: GestureDetector(
        onTap: (){
          widget.onTapListItem(index);
          setState(() {
          });
        },
        onDoubleTap: (){
          widget.onDoubleTapListItem(index);
        },
        child: ColoredBox(
          color: widget.autoCompleteTextFieldModel.value.currentIndex == index
              ? lightColorPalette.greyColor.shade900
              : Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(left: 15.0, right: 15,top: 10,bottom: 10),
            child: Row(
              children: [Expanded(child: Text("${listItem.name}"))],
            ),
          ),
        ),
      )
    );
  }

    addOverlay(){
      AutoCompleteDropDownTextField.animationController.forward();
      AutoCompleteDropDownTextField.overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(AutoCompleteDropDownTextField.overlayEntry!);
      widget.autoCompleteTextFieldModel.value.focusNode.requestFocus();
    }



  @override
  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    AutoCompleteDropDownTextField.animationController.dispose();
    AutoCompleteDropDownTextField.removeHighlightOverlay();
    super.dispose();
  }
}

