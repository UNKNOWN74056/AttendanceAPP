import 'package:attendance_app/model/User_token.dart';
import 'package:attendance_app/services/User_vIew_model.dart';
import 'package:attendance_app/utils/Routes_Names.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashServices {
  Future<UserToken?> getUserData() => User_view_Model().getUser();

  void Check_Authentication_User(BuildContext context) {
    // If a user is authenticated, retrieve user data and navigate to the appropriate page.
    getUserData().then((value) {
      if (value != null) {
        if (value.token == "null" || value.token == " ") {
          // User is not authenticated, navigate to login screen
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pushNamed(context, Routesname.login);
          });
        } else if (value.email == "admin@gmail.com") {
          // Admin user, navigate to admin screen
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pushNamed(context, Routesname.Admin_page);
          });
        } else {
          // Normal user, navigate to attendance screen
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pushNamed(context, Routesname.attendance_screen);
          });
        }
      } else {
        // User is not authenticated, navigate to login screen
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushNamed(context, Routesname.login);
        });
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
