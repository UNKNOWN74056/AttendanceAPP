import 'package:attendance_app/services/Splash_service.dart';
import 'package:flutter/material.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  SplashServices splashservice = SplashServices();
  @override
  void initState() {
    super.initState();
    splashservice.Check_Authentication_User(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/Attendance.jpg', // Replace with the path to your image
                  fit: BoxFit.contain, // Adjust the fit as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
