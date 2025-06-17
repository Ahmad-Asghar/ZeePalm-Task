import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/auth/profile/model/user_model.dart';

class UserPrefUtils {
  static final UserPrefUtils _singleton = UserPrefUtils._internal();

  factory UserPrefUtils() {
    return _singleton;
  }

  UserPrefUtils._internal();

  static String get USER => "com.tiktok.app.user";
  static String get USER_ID => "com.tiktok.app.user_token";
  static String get IS_LOGGED_IN => "com.tiktok.app.is_logged_in";

  Future<void> saveUserToSharedPreferences(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userJson = json.encode(user.toJson());
    await prefs.setString(USER, userJson);
  }

  Future<UserModel?> getUserFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(USER);

    if (userJson != null) {
      final Map<String, dynamic> userMap = json.decode(userJson);
      return UserModel.fromJson(userMap);
    }

    return null;
  }

  Future<void> setUserLoggedInStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool done = await prefs.setBool(IS_LOGGED_IN, isLoggedIn);
    print("Logged in status saved $done - $isLoggedIn");
  }

  Future<bool> getUserLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_LOGGED_IN) ?? false;
  }

  Future<void> saveUserID(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool done = await prefs.setString(USER_ID, userId);
    print("User ID saved $done - $userId");
  }

  Future<String?> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_ID);
  }
}
