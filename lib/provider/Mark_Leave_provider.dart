import 'package:attendance_app/provider/Validation_items.dart';
import 'package:flutter/material.dart';

class Mark_leave extends ChangeNotifier {
  late validaitonitem _TO_DATE = validaitonitem(null, null);
  late validaitonitem _FROM_DATE = validaitonitem(null, null);
  late validaitonitem _REASONE = validaitonitem(null, null);

  //controllers
  final TO_DATE_CONTORLLER = TextEditingController();
  final FROM_DATE_CONTROLLER = TextEditingController();
  final REASONE_CONTROLLER = TextEditingController();

  //dispose functions
  void disposeControllers() {
    TO_DATE_CONTORLLER.dispose();
    FROM_DATE_CONTROLLER.dispose();
    REASONE_CONTROLLER.dispose();
  }

  //validator to get the error
  validaitonitem get To_date => _TO_DATE;
  validaitonitem get From_date => _FROM_DATE;
  validaitonitem get Reason => _REASONE;

  // Date validation function
  void validate_to_Date(DateTime? selectedDate) {
    if (selectedDate == null) {
      _TO_DATE = validaitonitem(null, 'Please select a date');
    } else {
      _TO_DATE = validaitonitem(selectedDate.toString(), null);
    }
    notifyListeners();
  }

  void validate_from_Date(DateTime? selectedDate) {
    if (selectedDate == null) {
      _FROM_DATE = validaitonitem(null, 'Please select a date');
    } else {
      _FROM_DATE = validaitonitem(selectedDate.toString(), null);
    }
    notifyListeners();
  }

  // Reason validation function
  void validateReason(String value) {
    if (value.isEmpty) {
      _REASONE = validaitonitem(value, "Please enter a reason for leave");
    } else {
      _REASONE = validaitonitem(value, null);
    }
    notifyListeners();
  }

  bool get isvalid {
    // Check if the fields are initially empty or not selected
    if ((_TO_DATE.Value == null && _FROM_DATE.Value == null) ||
        (_TO_DATE.error != null || _FROM_DATE.error != null)) {
      return false;
    }

    // Check for validation errors
    if (_REASONE.error == null || _REASONE.error!.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
