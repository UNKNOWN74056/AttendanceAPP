import 'dart:io';
import 'package:attendance_app/model/Edit_model.dart';
import 'package:attendance_app/model/Mark_leave_model.dart';
import 'package:attendance_app/model/Signup_model.dart';
import 'package:attendance_app/model/User_token.dart';
import 'package:attendance_app/utils/Routes_Names.dart';
import 'package:attendance_app/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../services/User_vIew_model.dart';

class Auth_Provider with ChangeNotifier {
  UserModel? _user; // Current user data, null if not logged in
  UserModel? get user => _user;
  final _auth = FirebaseAuth.instance;
  File? _selectedImage;
  bool _isLoading = false;
  final _googleSignIn = GoogleSignIn();
  final User_view_Model _userViewModel = User_view_Model();

  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;

  // Add isLoading property and setLoading function
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setImage(File? image) {
    _selectedImage = image;
    notifyListeners();
  }

  // Signup method
  Future<void> signUp(UserModel user, BuildContext context) async {
    try {
      setLoading(true);
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Use currentUser.email if available, otherwise use user.email
        final currentUser = _auth.currentUser;
        final email = currentUser?.email ?? user.email;

        // Store user information in Firestore
        await FirebaseFirestore.instance.collection("users").doc(email).set({
          "name": user.name,
          "email": email,
          "password": user.password.toString(),
        });

        Navigator.pushNamed(context, Routesname.login);
        utils.showToastMessage("Signup successfully");

        _user = UserModel(email: email, password: '');
        notifyListeners();

        final idTokenResult = await firebaseUser.getIdToken();
        final userViewModel = User_view_Model();

        // Include the name parameter when saving the user in SharedPreferences
        await userViewModel.saveUser(UserToken(
          token: idTokenResult,
        ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        utils.showToastMessage("Password is weak");
      } else if (e.code == 'email-already-in-use') {
        utils.showToastMessage("Email is already in use");
      }
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
    } finally {
      setLoading(false);
    }
  }

  // Login method
  Future<void> login(UserModel user, BuildContext context) async {
    try {
      setLoading(true);
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final idTokenResult = await firebaseUser.getIdToken();
        final UseremailResult = firebaseUser.email;
        final userViewModel = User_view_Model();
        await userViewModel
            .saveUser(UserToken(token: idTokenResult, email: UseremailResult));

        _user = UserModel(email: firebaseUser.email ?? '', password: '');
        notifyListeners();
        // Check if the user is an admin
        if (user.email == 'admin@gmail.com') {
          Navigator.pushNamed(context, Routesname.Admin_page);
        } else {
          Navigator.pushNamed(context, Routesname.attendance_screen);
        }

        utils.showToastMessage("Login successfully");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        utils.Show_Flushbar_Error_Message(
            "No user found, please create your account", context);
      } else if (e.code == 'wrong-password') {
        utils.Show_Flushbar_Error_Message("Your password is wrong", context);
      }
    } finally {
      // Set loading to false when login completes or encounters an error
      setLoading(false);
    }
  }

  // Logout method
  void logout() async {
    try {
      await _auth.signOut();
      print("User logged out");
      _user = null;
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  ////////////////////////////////////////////////////////////
  //addition of more profile data
  Future<void> Profile_Edit(Edit_Model user, BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser!.email;
    if (currentUser != null) {
      try {
        setLoading(true);
        final imageurl = await uploadImageToStorage(selectedImage);
        // Create a map of data to update in Firestore
        FirebaseFirestore.instance.collection("users").doc(currentUser).update({
          "name": user.name,
          "age": user.age,
          "location": user.location,
          "image": imageurl
        }).then(
            (value) => utils.showToastMessage("Profile updated successfully"));

        // Notify listeners if needed
        notifyListeners();

        // Close the edit profile page or perform any navigation as needed
        Navigator.pop(context);
      } catch (e) {
        print("Error updating profile: $e");
        utils.showToastMessage("Failed to update profile");
      } finally {
        setLoading(false);
      }
    }
  }

  Future<String?> uploadImageToStorage(File? imageFile) async {
    if (imageFile == null) {
      return null;
    }

    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_images/${DateTime.now().toIso8601String()}');

      final UploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() => null);

      final imageUrl = await storageReference.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print("Error uploading image to storage: $e");
      return null;
    }
  }

  // Sign in with Google method
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final idTokenResult = await firebaseUser.getIdToken();
        final UseremailResult = firebaseUser.email;

        // Save user token to SharedPreferences
        await _userViewModel
            .saveUser(UserToken(token: idTokenResult, email: UseremailResult));

        // Update Firestore with user information
        await FirebaseFirestore.instance
            .collection('users')
            .doc(UseremailResult)
            .set({
          'email': UseremailResult,
          // Add more fields as needed
        });

        // Handle the sign-in with Google success
        // You can update your UI or perform any other actions
        // ...

        // Notify listeners or navigate to the next screen
        Navigator.pushNamed(context, Routesname.attendance_screen);
        notifyListeners();
      }
    } catch (error) {
      print('Google Sign-In failed: $error');
    }
  }

  // Mark leave function
  Future<void> Mark_leave(BuildContext context, Markleave mark) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    try {
      final Date = DateFormat('dd MMMM yyyy').format(DateTime.now());
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.email)
          .collection("Markleave")
          .doc(Date)
          .set({
        "To_Date": mark.toDate,
        "From_Date": mark.fromDate,
        "Reasone": mark.reasone,
      }).then((_) {
        utils.showToastMessage("Your mark leave request has been sent");
        print("Markleave added to Firestore");
        notifyListeners();
      }).catchError((error) {
        utils.showToastMessage("Error while adding Markleave to Firestore");
        print("Error while adding Markleave to Firestore: $error");
      });
    } catch (e) {
      utils.showToastMessage("Error while requesting");
      print("Error while requesting: $e");
    }
  }

  ///////////////////////////////////////////////////
}
