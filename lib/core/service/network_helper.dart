import 'dart:convert';

String removeJsonAndArray(String text) {
  if (text.startsWith('[') || text.startsWith('{')) {
    text = text.substring(1, text.length - 1);
    if (text.startsWith('[') || text.startsWith('{')) {
      text = removeJsonAndArray(text);
    }
  }

  return text;
}

Map<String,dynamic> getJsonFromString({required String message}){
  var stringJson = removeJsonAndArray(message);
  var dataSp = stringJson.split(',');
  Map<String, String> mapData = {};
  for (var element in dataSp) {
    mapData[element.split(':')[0].trim()] = element.split(':')[1].trim();
  }

  return mapData;
}

responseLog({required Object response, required String methodName}){
  String jsonUser = jsonEncode(response);
  print("********************** ${methodName} response start **********************");
  print(jsonUser);
  print("********************** ${methodName} response end **********************");
}

