import 'package:attendance_app/components/colors.dart';
import 'package:attendance_app/firebase_options.dart';
import 'package:attendance_app/provider/Authentication_provider.dart';
import 'package:attendance_app/provider/Get_User_Data.dart';
import 'package:attendance_app/provider/Login_provider.dart';
import 'package:attendance_app/provider/Mark_Leave_provider.dart';
import 'package:attendance_app/provider/signup_provider.dart';
import 'package:attendance_app/services/User_vIew_model.dart';
import 'package:attendance_app/utils/Routes.dart';
import 'package:attendance_app/utils/Routes_Names.dart';
import 'package:attendance_app/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> initialization = Firebase.initializeApp();
    return FutureBuilder(
        future: initialization,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            utils.Show_Flushbar_Error_Message("Something went wrong", context);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => signup()),
              ChangeNotifierProvider(create: (context) => Auth_Provider()),
              ChangeNotifierProvider(create: (context) => login()),
              ChangeNotifierProvider(create: (context) => User_view_Model()),
              ChangeNotifierProvider(create: (context) => UserDataProvider()),
              ChangeNotifierProvider(create: (context) => Mark_leave()),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
                useMaterial3: true,
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: Routesname.Splash_screen,
              onGenerateRoute: Routes.generateRoutes,
              localizationsDelegates: const [
                MonthYearPickerLocalizations.delegate
              ],
            ),
          );
        });
  }
}
