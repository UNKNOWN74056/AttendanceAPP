import 'package:attendance_app/components/Another_Account_Button.dart';
import 'package:attendance_app/components/Save_button.dart';
import 'package:attendance_app/components/Text_field_widget.dart';
import 'package:attendance_app/components/colors.dart';
import 'package:attendance_app/model/Signup_model.dart';
import 'package:attendance_app/provider/Authentication_provider.dart';
import 'package:attendance_app/provider/Login_provider.dart';
import 'package:attendance_app/utils/Routes_Names.dart';
import 'package:attendance_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  @override
  Widget build(BuildContext context) {
    final logincontroller = Provider.of<login>(context, listen: false);
    final loginuser = Provider.of<Auth_Provider>(context, listen: false);
    ValueNotifier<bool> obsecuretext = ValueNotifier<bool>(true);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Text(
                  "Log In",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Lottie.asset('assets/login.json', width: 300, height: 210),
                const Gutter(),
                Consumer<login>(
                  builder: (context, value, child) {
                    return Text_Form_Field(
                      controller: logincontroller.emailController,
                      hintext: "Enter your email",
                      prefixicon: const Icon(FontAwesomeIcons.solidEnvelope),
                      errortext: value.email.error,
                      maxlines: 1,
                      onchange: (String value) {
                        logincontroller.validateEmail(value);
                      },
                    );
                  },
                ),
                const Gutter(),
                ValueListenableBuilder(
                  valueListenable: obsecuretext,
                  builder: (context, value, child) {
                    return Consumer<login>(
                      builder: (context, val, child) {
                        return Text_Form_Field(
                          controller: logincontroller.passwordController,
                          hintext: "Enter your passwrod",
                          prefixicon: const Icon(FontAwesomeIcons.lock),
                          errortext: val.password.error,
                          obsecuretext: obsecuretext.value,
                          maxlines: 1,
                          onchange: (String value) {
                            logincontroller.validatePassword(value);
                          },
                          sufixicon: InkWell(
                              onTap: () {
                                obsecuretext.value = !obsecuretext.value;
                              },
                              child: Icon(obsecuretext.value
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                        );
                      },
                    );
                  },
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Forgot password",
                        style: TextStyle(color: AppColors.blue, fontSize: 13),
                      ),
                    )
                  ],
                ),
                const Gutter(),
                // Update the Button widget in your Login_page widget
                Consumer<Auth_Provider>(
                  builder: (context, authProvider, child) {
                    return Button(
                      text: "Login",
                      ontap: () {
                        if (!logincontroller.isvalid) {
                          utils.showToastMessage("Please enter your field");
                        } else {
                          loginuser.login(
                            UserModel(
                              email: logincontroller.emailController.text,
                              password: logincontroller.passwordController.text,
                            ),
                            context,
                          );
                        }
                      },
                      isLoading: authProvider.isLoading,
                    );
                  },
                ),
                const Gutter(),
                const Center(child: Text("Or Continue with")),
                const Gutter(),
                GestureDetector(
                  onTap: () async {
                    await loginuser.signInWithGoogle(context);
                  },
                  child: const AnotherAccountButton(
                    imagepath: "assets/google.png",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a member!"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routesname.signup);
                        },
                        child: const Text(
                          "Register Now",
                          style: TextStyle(color: AppColors.blue),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
