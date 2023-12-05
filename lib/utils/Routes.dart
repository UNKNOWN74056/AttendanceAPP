import 'package:attendance_app/services/Splash_page.dart';
import 'package:attendance_app/utils/Routes_Names.dart';
import 'package:attendance_app/view/Admin_panel/Admin_Home_page.dart';
import 'package:attendance_app/view/User_Panel/Attendance_Screen.dart';
import 'package:attendance_app/view/User_Panel/Edit_profile_page.dart';
import 'package:attendance_app/view/User_Panel/Profile_page.dart';
import 'package:attendance_app/view/User_Panel/Login.dart';
import 'package:attendance_app/view/User_Panel/Sign_up.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routesname.attendance_screen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AttendanceScreen());
      case Routesname.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Login_page());
      case Routesname.signup:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Signup_Page());
      case Routesname.Profile_page:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Profile_page());
      case Routesname.Splash_screen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Splash_Screen());
      case Routesname.Edit_profile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Edit_Profile());
      case Routesname.Admin_page:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Admin_page());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("route doenot define")),
          );
        });
    }
  }
}
