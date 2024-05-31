import 'dart:convert';
import 'dart:developer';
import 'package:am_sys/model/login_response/user_decoded_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyUserDecodedData = 'user_decoded_data';
  static const String _keyIsLogin = 'isLogin';

  static Future<bool> setUserDecodedData(UserDecodedData userData) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = jsonEncode(userData.toJson());
    return await prefs.setString(_keyUserDecodedData, userDataJson);
  }

  static Future<void> setIsUserLogin(bool isLogin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLogin, isLogin);
  }

  static Future<bool> getIsUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLogin) ?? false;
  }

  static Future<UserDecodedData?> getUserDecodedData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userDataJson = prefs.getString(_keyUserDecodedData);
    if (userDataJson != null) {
      try {
        Map<String, dynamic> userDataMap = jsonDecode(userDataJson);
        log('userDecodedData: $userDataMap');

        return UserDecodedData.fromJson(userDataMap);
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }
}
