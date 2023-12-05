import 'package:attendance_app/provider/Validation_items.dart';
import 'package:flutter/material.dart';

class signup extends ChangeNotifier {
  late validaitonitem _Name = validaitonitem(null, null);
  late validaitonitem _Email = validaitonitem(null, null);
  late validaitonitem _password = validaitonitem(null, null);
  late validaitonitem _confirmpassword = validaitonitem(null, null);
  //controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //dispsoe the controller
  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
  }

  // Getters for validation errors
  validaitonitem get name => _Name;
  validaitonitem get email => _Email;
  validaitonitem get password => _password;
  validaitonitem get confirmpassword => _confirmpassword;

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

  //name vlaidaiton
  void validateName(String value) {
    if (value.isEmpty) {
      _Name = validaitonitem(value, "Enter your name");
    } else if (!isOnlyText(value)) {
      _Name =
          validaitonitem(value, 'Enter a valid name (only letters allowed)');
    } else {
      _Name = validaitonitem(value, null);
    }
    notifyListeners();
  }

  bool isOnlyText(String text) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(text);
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

  // Confirm Password validation function
  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      _confirmpassword = validaitonitem(value, 'Confirm Password is required');
    } else if (value != password.Value) {
      _confirmpassword = validaitonitem(value, 'Passwords do not match');
    } else {
      _confirmpassword = validaitonitem(value, null);
    }
    notifyListeners();
  }

  // Helper function to check if the email is valid
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  bool get isvalid {
    if (_Name.Value != null &&
        _Email.Value != null &&
        _password.Value != null &&
        _confirmpassword.Value != null) {
      return true;
    } else {
      return false;
    }
  }

  void onsumbit() {
    print(
        "firstname: ${email.Value}, password: ${password.Value} ,confirmpassword: ${confirmpassword.Value}");
  }
}
