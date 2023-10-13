import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_retail_pharmacies/core/date_time/date_time_utility.dart';
import 'package:flutter_retail_pharmacies/core/local_library/scroll_to_index.dart';
import 'package:flutter_retail_pharmacies/core/models/request/check_creation_request_model.dart';
import 'package:flutter_retail_pharmacies/core/models/response/top_table_response_model.dart';
import 'package:flutter_retail_pharmacies/core/service/feathers_services/feathers_transfer_service.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/model/transfer_check_creation_model.dart';
import 'package:flutter_retail_pharmacies/features/add_new_transfer_journal/model/transfer_list_response_model.dart';
import 'package:flutter_retail_pharmacies/features/check_details/models/local/check_summary_for_selected_date_model.dart';
import 'package:flutter_retail_pharmacies/features/dashboard/controller/dashboard_contoller.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/keyboard_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/transfer_details_table_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/pagination_functionality_extension.dart';
import 'package:flutter_retail_pharmacies/features/transfer_journal/controller/extensions/transfer_list_table_functionality_extension.dart';
import 'package:get/get.dart';

class TransferJournalController extends GetxController {

  //feathers is a service class which we have use for api integration
  FeathersTransferService feathersTransferService = FeathersTransferService();

  //AutoScrollController - used to scroll the table at particular index
  AutoScrollController topCheckListScrollController = AutoScrollController();
  AutoScrollController bottomListScrollController = AutoScrollController();



  //Below variables are used tp hold the selected index of listviews
  RxInt selectedIndexBottom = (-1).obs;
  RxInt selectedIndexTop = (-1).obs;

  //Below list variables holds the data from the feather apis
  RxList<TransferData> topTableTableList = <TransferData>[].obs;
  RxList<TopTableData> bottomTableList = <TopTableData>[].obs;

  //Below variables are used to track the currently focused table
  bool topTableFocusBool = false;
  bool bottomTableFocusBool = false;

  //docsId is used for api integration of top table
  RxString docsId = "".obs;

  //Below variables are used to show data on the receipt
  RxInt totalAmount = 0.obs; //Used for showing amount of receipt

  RxString transferCreatedDate =
      DateTime.now().toString().obs; //Used for showing grandTotal amount of card receipt
  var transferSender = "-".obs;
  var transferReceiver = "-".obs;

  //isEnabledUpDownKey variable used to create the delay, between the up,down and left, right arrow keys.
  bool isEnabledUpDownKey = true;

  //loaders to wait the socket data
  var showBottomTableLoader = false.obs;
  var showTopTableLoaderCheck = false.obs;


  //Below variables are used to implement the pagination functionality
  RxBool loadMoreTop = false.obs;
  RxInt totalNumberOfRecordTop = 0.obs;
  RxInt offsetCountTop = 0.obs;
  final paginationLengthTop = 10;

  //Below variables are used to implement the pagination functionality
  RxBool loadMoreBottom = false.obs;
  RxBool isEndOfThePagination = false.obs;
  RxInt offsetCountBottom = 0.obs;
  final paginationLengthBottom = 10;
  var selectedDate = DateTime.now().obs;
  var checkSummaryForSelectedDateModel = CheckSummaryForSelectedDateModel().obs;
  var dashboardController = Get.find<DashboardController>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("TransferJournalController onInit");

    initAutoScrollControllers();

    //getTimeListingApiIntegration function is used for api integration of time table
    hitTransferListApi();
  }

  hitTransferListApi(){
    getTransferList().then((value) {
      if(topTableTableList.isNotEmpty){
        getBottomCheckTableData(docId: docsId.value);
      }else{
        selectedIndexTop.value = -1;
        selectedIndexBottom.value = -1;
        bottomTableList.clear();
        clearReceiptData();
        topTableTableList.refresh();
      }
    });
  }


  initAutoScrollControllers() {
    bottomListScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, Get.mediaQuery.padding.bottom),
        axis: Axis.vertical);
    topCheckListScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, Get.mediaQuery.padding.bottom),
        axis: Axis.vertical);

    topCheckListScrollController.addListener(() {
      topTablePagination();
    });

    bottomListScrollController.addListener(() {
      bottomTablePagination();
    });


  }


  void topTablePagination() {
    if ((topCheckListScrollController.position.pixels ==
        topCheckListScrollController.position.maxScrollExtent)) {
      print("end of the table");
      if (totalNumberOfRecordTop.value > offsetCountTop.value && !(loadMoreTop.value)) {
        loadMoreTop.value = true;
        offsetCountTop.value += paginationLengthTop;
        print("offsetCount.value<<<<${offsetCountTop.value}");
        getTransferList(isClearListFirst: false,isShowLoader: false);
      }
    }
  }

  Future scrollToIndex(
      {required int index, required AutoScrollController controller}) async {
    isEnabledUpDownKey = false;
    await controller.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);
    isEnabledUpDownKey = true;
  }

  void releaseResources() {
     print("TransferJournalController dispose");
  }

  @override
  void onClose() {
    releaseResources();
    super.onClose();
  }

  @override
  void dispose() {
    releaseResources();
    super.dispose();
  }

}
