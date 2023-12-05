import 'package:flutter/material.dart';
import 'package:attendance_app/provider/Validation_items.dart';

class login extends ChangeNotifier {
  late validaitonitem _Email = validaitonitem(null, null);
  late validaitonitem _password = validaitonitem(null, null);
  //for edit profile
  late validaitonitem _name = validaitonitem(null, null);
  late validaitonitem _location = validaitonitem(null, null);
  /////////////////////////////////
  //controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //edit profile controller
  TextEditingController namecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  /////////////////////////////////////////////
  //dispsoe the controller
  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
    namecontroller.dispose();
    locationcontroller.dispose();
  }

  // Getters for validation errors
  validaitonitem get email => _Email;
  validaitonitem get password => _password;
  validaitonitem get name => _name;
  validaitonitem get location => _location;

  // Email validation function
  void validateEmail(String value) {
    if (value.isEmpty) {
      _Email = validaitonitem(value, "enter your email");
    } else if (!isValidEmail(value)) {
      _Email = validaitonitem(value, 'Enter a valid email address');
    } else {
      _Email = validaitonitem(value, null);
    }
    notifyListeners();
  }

  // Name validation function
  void validateName(String value) {
    if (value.isEmpty) {
      _name = validaitonitem(value, "enter your name");
    } else {
      _name = validaitonitem(value, null);
    }
    notifyListeners();
  }

  // location validation function
  void validatelocation(String value) {
    if (value.isEmpty) {
      _location = validaitonitem(value, "enter your location");
    } else {
      _location = validaitonitem(value, null);
    }
    notifyListeners();
  }

  // Password validation function
  void validatePassword(String value) {
    if (value.isEmpty) {
      _password = validaitonitem(value, 'Password is required');
    } else if (value.length < 6) {
      _password =
          validaitonitem(value, 'Password must be at least 6 characters long');
    } else {
      _password = validaitonitem(value, null);
    }
    notifyListeners();
  }

  // Helper function to check if the email is valid
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  bool get isvalid {
    if (_Email.Value != null && _password.Value != null) {
      return true;
    } else {
      return false;
    }
  }

  bool get iseditvalid {
    if (_name.Value != null && _location.Value != null) {
      return true;
    } else {
      return false;
    }
  }
}
