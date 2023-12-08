import 'dart:async';
import 'package:attendance_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserDataProvider extends ChangeNotifier {
  String _userName = '';
  String _CheckinTime = '';
  String _CheckoutTime = '';
  final String _Date = '';
  late bool _isCheckedIn = false;
  Map<String, dynamic> data = {};
  final bool _isProfileComplete = false;
  bool _hasCheckedInToday = false;
  bool _hasCheckedOutToday = false;
  final bool _isDayCompleted = false;

  String get userName => _userName;
  String get checkintime => _CheckinTime;
  String get checkouttime => _CheckoutTime;
  String get date => _Date;
  bool get isCheckedIn => _isCheckedIn;
  bool get hasCheckedInToday => _hasCheckedInToday;
  bool get hasCheckedOutToday => _hasCheckedOutToday;
  bool get isProfileComplete => _isProfileComplete;
  bool get isDayCompleted => _isDayCompleted;

  late final StreamController<Map<String, dynamic>> _checkInOutStreamController;

  // Stream to expose check-in and check-out times
  Stream<Map<String, dynamic>> get checkInOutStream =>
      _checkInOutStreamController.stream;

  // Constructor
  UserDataProvider() {
    _checkInOutStreamController =
        StreamController<Map<String, dynamic>>.broadcast();
  }

  Future<void> fetchData() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Use the email of the current user to filter data
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Assuming only one document matches the query, retrieve the first one
          data = querySnapshot.docs.first.data() as Map<String, dynamic>;

          // Notify listeners that the data has been fetched
          notifyListeners();
        } else {
          print('No data found for the current user in Firestore collection.');
        }
      } else {
        print('No user is currently logged in.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  //update profile completion code
  Future<bool> updateProfileCompletion(Map<String, dynamic> data) async {
    // Implement your profile completeness check logic here
    bool isComplete =
        data['name'] != null && data['age'] != null && data['location'] != null;

    return isComplete; // Return the result as a Future<bool>
  }

  // Function to fetch check-in and check-out times
  Future<void> fetchCheckInOutTimes() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .get();

        if (userDoc.exists) {
          final recordsCollection = userDoc.reference.collection('records');
          final querySnapshot = await recordsCollection.get();

          if (querySnapshot.docs.isNotEmpty) {
            final latestRecord = querySnapshot.docs.last;
            _CheckinTime = latestRecord['checkInTime'];
            _CheckoutTime = latestRecord['checkOutTime'];
            DateTime? dateTime = (latestRecord['date'] as Timestamp).toDate();

            // Add the check-in and check-out times to the stream
            _checkInOutStreamController.add({
              'checkInTime': _CheckinTime,
              'checkOutTime': _CheckoutTime,
              'date': dateTime,
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching check-in/out times: $e');
    }
  }

  // Dispose of the StreamController when the provider is disposed
  @override
  void dispose() {
    _checkInOutStreamController.close();
    super.dispose();
  }

  // Function to fetch current user data from Firestore
  Future<void> fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.email;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;

          // Update _userName, _userEmail,
          _userName = userData['name'] ?? '';

          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> checkIn() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .get();

        if (userDoc.exists) {
          final recordsCollection = userDoc.reference.collection('records');
          final Date = DateFormat('dd MMMM yyyy').format(DateTime.now());
          final Time = DateFormat('hh:mm').format(DateTime.now());
          await recordsCollection.doc(Date).set({
            'checkInTime': Time,
            'date': Timestamp.now(),
          });
          utils.showToastMessage("Your day is started");
          _isCheckedIn = true;
          _hasCheckedInToday = true;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error during check-in: $e');
    }
  }

  Future<void> checkOut() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .get();

        if (userDoc.exists) {
          final recordsCollection = userDoc.reference.collection('records');
          final Date = DateFormat('dd MMMM yyyy').format(DateTime.now());
          final Time = DateFormat('hh:mm').format(DateTime.now());

          await recordsCollection.doc(Date).update({
            'checkOutTime': Time,
            'date': Timestamp.now(),
          });
          _isCheckedIn = false;
          _hasCheckedOutToday = true;
          utils.showToastMessage("Your day is completed");

          notifyListeners();
        }
      }
    } catch (e) {
      print('Error during check-out: $e');
    }
  }
  
}


