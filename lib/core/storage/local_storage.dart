import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static const String accessToken = "accessToken";
  static const String userEmail = "userEmail";
  static const String userId = "userId";
  static const String selectedLangId = "languageType";
  static var box = GetStorage();


  static read(String key) {
      return box.read(key);
  }

  static write(String key, value) async{
      box.write(key, value);
  }

  static readObj(String key) {
    var box = GetStorage();
    var data = box.read(key);
    return data != null ? json.decode(data) : null;
  }

  static writeObj(String key, value) {
    var box = GetStorage();
    box.write(key, json.encode(value));
  }

  static erase() async{
      var box = GetStorage();
      box.erase();
  }

  static storeUserData({required String id, required String token, required String email}) {
    write(accessToken, token);
    write(userEmail, email);
    write(userId, id);
  }
}
