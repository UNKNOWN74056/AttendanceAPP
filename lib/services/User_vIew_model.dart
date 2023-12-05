import 'package:flutter/material.dart';
import 'package:attendance_app/model/User_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User_view_Model extends ChangeNotifier {
  static const String tokenKey = 'token';
  static const String emailKey = 'email';

  Future<bool> saveUser(UserToken user) async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.setString(tokenKey, user.token.toString());
      await sp.setString(emailKey, user.email.toString());
      notifyListeners();
      return true;
    } catch (e) {
      // Handle the error appropriately (e.g., log it, show a message)
      print('Error saving user: $e');
      return false;
    }
  }

  Future<UserToken?> getUser() async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      final String? token = sp.getString(tokenKey);
      final String? email = sp.getString(emailKey);
      return token != null
          ? UserToken(token: token.toString(), email: email.toString())
          : null;
    } catch (e) {
      // Handle the error appropriately (e.g., log it, show a message)
      print('Error getting user: $e');
      return null;
    }
  }

  Future<bool> remove() async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.remove(tokenKey);
      await sp.remove(emailKey);
      return true;
    } catch (e) {
      // Handle the error appropriately (e.g., log it, show a message)
      print('Error removing user: $e');
      return false;
    }
  }
}
