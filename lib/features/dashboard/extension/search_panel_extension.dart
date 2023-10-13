import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/common_ui/common_asset/common_image.dart';
import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:flutter_retail_pharmacies/core/constants/image_resources.dart';
import 'package:flutter_retail_pharmacies/core/theme/app_color_palette.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/search_field_fucntionailty.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/extension/top_table_functionality.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/screen/dashboard_screen.dart';
import 'package:get/get.dart';

/*
This class extends the DashboardScreen class.
All the properties of DashboardScreen are accessible to this extension.
Extension is the way to add functionalities to existing class.
*/

extension SearchPanelExtension on DashboardScreen {
  //This widget returns the search ui, and used for search purpose.
  searchPanelWidget() {

    var backgroundColor = lightColorPalette.addNewChecksColor.searchFieldBgColor;
    var foregroundColor = lightColorPalette.addNewChecksColor.searchFieldTextColor;


    return Container(
      padding: const EdgeInsets.only(left: 10, right: 3, top: 3, bottom: 3),
      decoration: BoxDecoration(
          color: backgroundColor),
      child: Row(
        children: [
          AssetWidget(
            asset: Asset(
              type: AssetType.svg,
              path: ImageResource.searchIcon,
            ),
            height: 23,
            color: lightColorPalette.whiteColor.shade900,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: lightColorPalette.whiteColor.shade900,
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              child: TextField(
                controller: controller.searchTextEditingController,
                focusNode: controller.searchFocusNode,
                onChanged: controller.searchOnChange,
                onTap: () {
                  controller.unselectTopTableRow();
                },
                style: TextStyle(
                    color: foregroundColor,
                   fontWeight: FontWeight.w500
                ),
                decoration: InputDecoration(
                    hintText: AppStrings.search.tr,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    border: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
