enum PaymentMethod {
  cash,
  humo,
  uzCard,
  other,
  none
}

enum PaymentMethodFunctionKeys {
  f8,
  f9,
  f10,
  f12,
}

enum QuantityTypes {
  pkg,
  tablets,
}
enum AuthSectionEnum{login,signUp}

enum ShowImagePositionAt { right, left, none }

enum LeftPanelTabs {dashboard,checkJournal,transferJournal,inventoryReports}

enum RightPanelTabs {addNewTransferJournal,none}

enum TransferPartyEnum{sender,receiver}

enum ReportsCategories{storage,category,goods,batch,turnOver}

enum TurnOverReportStatus {
  receive("receive"),
  openBalance("open_balance"),
  closeBalance("close_balance"),
  issue("issue");

  final String value;

  // can use named parameters if you want
  const TurnOverReportStatus(this.value);
}

enum LanguageEnum{en,ru}


enum SettingTabsEnum{language,other}




