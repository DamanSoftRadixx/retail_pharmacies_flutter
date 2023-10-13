import 'package:intl/intl.dart';



var apiDateFormat = DateFormat("yyyy-MM-dd");
var localDateFormat = DateFormat("dd/MM/yyyy");

String getFormattedStringDate({required String date}){
  if(date == "") return "";
  var formattedDateString = "";
   var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
   var parsedDate = inputFormat.parse(date);
  var outputFormat = DateFormat('dd MMM yyyy HH:mm:ss');

  formattedDateString = outputFormat.format(parsedDate);

  return formattedDateString;

}

String extractDateFromDateTimeString({required String date}){
  if(date == "") return "";
  print("inputDate : ${date}");

  var formattedDateString = "";
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var parsedDate = inputFormat.parse(date);
  var outputFormat = DateFormat('dd MMM yyyy');

  formattedDateString = outputFormat.format(parsedDate);

  return formattedDateString;
}

String getDateForApi({required String date}){
  if(date == "") return "";
  print("inputDate : ${date}");

  var formattedDateString = "";
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var parsedDate = inputFormat.parse(date);
  var outputFormat = DateFormat('yyyy-MM-dd');

  formattedDateString = outputFormat.format(parsedDate);

  return formattedDateString;
}

String extractTimeFromDateTimeString({required String date}){
  if(date == "") return "";
  var formattedDateString = "";
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  var parsedDate = inputFormat.parse(date);
  var outputFormat = DateFormat('HH : mm');

  formattedDateString = outputFormat.format(parsedDate);

  return formattedDateString;
}

String convertToLocalFormat({required String dateTime}){
  if(dateTime == "") return "";
  DateTime date = apiDateFormat.parse(dateTime);
  return localDateFormat.format(date);
}

String convertToAPIFormat({required DateTime dateTime}){
  return apiDateFormat.format(dateTime);
}