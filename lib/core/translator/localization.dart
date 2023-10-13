import 'package:flutter_retail_pharmacies/core/constants/app_strings.dart';
import 'package:get/get.dart';

//Local string class is used for converting string to a specific language.

class LocalString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'ru': {
          AppStrings.pharmacy: "Аптека",
          AppStrings.fullnaming: "Полное наимование",
          AppStrings.qty: "Кол-во",
          AppStrings.price: "Цена",
          AppStrings.sum: "Сумма",
          AppStrings.termYear: "Срок год",
          AppStrings.series: "Серия",
          AppStrings.mx: "MX",
          AppStrings.ikpu: "ИКПУ",
          AppStrings.mark: "Марк",
          AppStrings.discount: "Скидка",
          AppStrings.forPayment: "К оплате",
          AppStrings.close: "Закрыть",
          AppStrings.newCheck: "Новый чек",
          AppStrings.search: "Поиск",
          AppStrings.up: "УП",
          AppStrings.remainder: "Остаток",
          AppStrings.promotion: "Акция",
          AppStrings.showmore: "Показать больше",
          AppStrings.cash: "Наличные",
          AppStrings.other: "Прочее",
          AppStrings.insurance: "Страховка",
          AppStrings.returnFromBuyer: "Возврат от покупателя",
          AppStrings.exit: "Выход",
          AppStrings.alert: "тревога!",
          AppStrings.doYouWantTodelete: "Вы хотите удалить эту запись.",
          AppStrings.cancel: "Отмена",
          AppStrings.delete: "Удалить",
          AppStrings.action: "Действие",
          AppStrings.series2: "Seriya",
          AppStrings.expiryDate: "Srok godnost",
          AppStrings.remainder2: "Остаток",
          AppStrings.quantity: "Кол-во",
          AppStrings.payment: "Оплата",
          AppStrings.totalPayableAmountIs: "Общая сумма к оплате составляет",
          AppStrings.totalAmountCantBeGreaterThan:
              "Общая сумма не может быть больше",
          AppStrings.pleaseEnterQuantity: "Пожалуйста, введите количество.",
          AppStrings.doneButton: "СДЕЛАННЫЙ",
          AppStrings.oKButton: "ХОРОШО",
          AppStrings.error: "Ошибка",
          AppStrings.youCantModifyItAsThisItemIsDeleted:
              "Вы не можете изменить его, потому что этот элемент был удален.",
          AppStrings.noDataFound: "Данные не найдены",
          AppStrings.paymentIsPartial: "Оплата не полностью завершена.",
          AppStrings.addQuantity: "Добавить количество",
          AppStrings.editQuantity: "Изменить количество",
          AppStrings.alert: "Тревога!",
          AppStrings.ok: "Хорошо",
          AppStrings.check: "Проверять",
          AppStrings.dateTime: "Дата Время",
          AppStrings.status: "Положение дел",
          AppStrings.amount: "Количество",
          AppStrings.dashboard: "Дом",
          AppStrings.partialQuantityMsg:
              "Частичное количество не может быть больше",
          AppStrings.somethingWentWrong: "Что-то пошло не так.",

          AppStrings.password: "Пароль",
          AppStrings.confirmPassword: "Подтвердите пароль",
          AppStrings.email: "Электронная почта",
          AppStrings.login: "Авторизоваться",
          AppStrings.welcomeBackCatchy: "С возвращением",
          AppStrings.createAccount: "Зарегистрироваться",
          AppStrings.pleaseEnterEmail: "Пожалуйста, введите адрес электронной почты.",
          AppStrings.pleaseEnterValidEmail: "Пожалуйста, введите действительный адрес электронной почты.",
          AppStrings.pleaseEnterPassword: "Пожалуйста введите пароль.",
          AppStrings.pleaseEnterConfirmPassword:
              "Пожалуйста, введите пароль для подтверждения.",
          AppStrings.yourPasswordMustBeAtleast8Char:
              "Ваш пароль должен состоять не менее чем из 8 символов, содержать хотя бы одну цифру и состоять из прописных и строчных букв.",
          AppStrings.invalidCredentials: "Недействительные учетные данные",
          AppStrings.dontHaveAccount: "У вас нет аккаунта? ",
          AppStrings.signup: "Зарегистрироваться",
          AppStrings.passwordAndConfirmPasswordshouldMatch:
              "Пароль и подтверждение пароля должны совпадать.",
          AppStrings.accountHasBeenCreatedSuccessfully:
              "Учетная запись успешно создана.",
          AppStrings.success: "Успех",
          AppStrings.areYouSureYouWantToLogout:
              "Вы действительно хотите выйти?",
          AppStrings.logout: "Выйти",

          AppStrings.transfer: "Передача",
          AppStrings.sender: "Отправитель",
          AppStrings.receiver: "Получатель",
          AppStrings.addNewTransfer: "Добавить новый перевод",
          AppStrings.addNew: "Добавить новое",
          AppStrings.doneButtonSmall: "Сделанный",

          AppStrings.transferDetail: "Детали передачи",
          AppStrings.pleaseEnterSenderAddress: "Пожалуйста, введите адрес отправителя.",
          AppStrings.pleaseEnterReceiverAddress:
              "Пожалуйста, введите адрес получателя.",
          AppStrings.pleaseAddMinimumOneEntryFirst:
              "Пожалуйста, добавьте минимум одну запись о лекарстве.",
          AppStrings.pleaseAddSenderReceiverAddressFirst:
              "Сначала добавьте адрес отправителя и получателя.",
          AppStrings.createCounterParty: "Создать организацию",
          AppStrings.name: "Имя",
          AppStrings.address: "Адрес",
          AppStrings.pleaseEnterName: "Пожалуйста, введите имя.",
          AppStrings.pleaseEnterAdress: "Пожалуйста, введите адрес.",

          AppStrings.transferIsAlreadySendYouCantEditThis:
              "Перевод уже отправлен, и вы не можете редактировать его сейчас.",

          // Reports
          AppStrings.reports: "Отчеты",
          AppStrings.reportName: "Имя",
          AppStrings.cost: "Расходы",
          AppStrings.openingDate: "Дата открытия",
          AppStrings.closingDate: "Дата закрытия",
          AppStrings.date: "Дата",
          AppStrings.unknown: "Неизвестный",
          AppStrings.turnOverReports: "Отчеты об обороте",

          AppStrings.openBalance: "Открытый баланс",
          AppStrings.closeBalance: "Закрыть баланс",
          AppStrings.received: "Полученный",
          AppStrings.issued: "Изданный",
          AppStrings.operation: "Операция",
          AppStrings.balance: "Баланс",
          AppStrings.document: "Документ",

          //Settings
          AppStrings.settings: "Настройки",
          AppStrings.selectLanguage: "Выберите язык",
        }
      };
}
