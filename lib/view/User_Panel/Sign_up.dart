import 'package:attendance_app/components/Save_button.dart';
import 'package:attendance_app/components/Text_field_widget.dart';
import 'package:attendance_app/model/Signup_model.dart';
import 'package:attendance_app/provider/Authentication_provider.dart';
import 'package:attendance_app/provider/signup_provider.dart';
import 'package:attendance_app/utils/Routes_Names.dart';
import 'package:attendance_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Signup_Page extends StatefulWidget {
  const Signup_Page({super.key});

  @override
  State<Signup_Page> createState() => _Signup_PageState();
}

class _Signup_PageState extends State<Signup_Page> {
  @override
  Widget build(BuildContext context) {
    final signupcontroller = Provider.of<signup>(context, listen: false);
    final signupuser = Provider.of<Auth_Provider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Lottie.asset('assets/signup.json', width: 300, height: 210),
                const Gutter(),
                Consumer<signup>(
                  builder: (context, value, child) {
                    return Text_Form_Field(
                      controller: signupcontroller.nameController,
                      hintext: "Enter your fullname",
                      errortext: value.name.error,
                      maxlines: 1,
                      prefixicon: const Icon(FontAwesomeIcons.person),
                      onchange: (String value) {
                        signupcontroller.validateName(value);
                      },
                    );
                  },
                ),
                const Gutter(),
                Consumer<signup>(
                  builder: (context, value, child) {
                    return Text_Form_Field(
                      controller: signupcontroller.emailController,
                      hintext: "Enter your email",
                      errortext: value.email.error,
                      maxlines: 1,
                      prefixicon: const Icon(FontAwesomeIcons.envelope),
                      onchange: (String value) {
                        signupcontroller.validateEmail(value);
                      },
                    );
                  },
                ),
                const Gutter(),
                Consumer<signup>(
                  builder: (context, value, child) {
                    return Text_Form_Field(
                      controller: signupcontroller.passwordController,
                      hintext: "Enter your password",
                      prefixicon: const Icon(FontAwesomeIcons.lock),
                      errortext: value.password.error,
                      obsecuretext: true,
                      maxlines: 1,
                      onchange: (String value) {
                        signupcontroller.validatePassword(value);
                      },
                    );
                  },
                ),
                const Gutter(),
                Consumer<signup>(
                  builder: (context, value, child) {
                    return Text_Form_Field(
                      controller: signupcontroller.confirmPasswordController,
                      hintext: "Confirm password",
                      obsecuretext: true,
                      maxlines: 1,
                      prefixicon: const Icon(FontAwesomeIcons.lock),
                      errortext: value.confirmpassword.error,
                      onchange: (String value) {
                        signupcontroller.validateConfirmPassword(value);
                      },
                    );
                  },
                ),
                Consumer<Auth_Provider>(
                    builder: (context, authProvider, child) {
                  return Button(
                    text: "Signup",
                    ontap: () async {
                      if (!signupcontroller.isvalid) {
                        utils.Show_Flushbar_Error_Message(
                            "Please fill the fields", context);
                      } else {
                        signupuser.signUp(
                            UserModel(
                                name: signupcontroller.nameController.text,
                                email: signupcontroller.emailController.text,
                                password:
                                    signupcontroller.passwordController.text),
                            context);
                      }
                    },
                    isLoading: signupuser.isLoading,
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already Have An Account!"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routesname.login);
                        },
                        child: const Text("Login"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
