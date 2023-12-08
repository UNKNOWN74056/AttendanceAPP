import 'dart:io';
import 'package:attendance_app/components/Date_picker_text_field.dart';
import 'package:attendance_app/components/Save_button.dart';
import 'package:attendance_app/components/Text_field_widget.dart';
import 'package:attendance_app/components/colors.dart';
import 'package:attendance_app/model/Edit_model.dart';
import 'package:attendance_app/provider/Authentication_provider.dart';
import 'package:attendance_app/provider/Login_provider.dart';
import 'package:attendance_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Edit_Profile extends StatefulWidget {
  const Edit_Profile({super.key});

  @override
  State<Edit_Profile> createState() => _Edit_ProfileState();
}

class _Edit_ProfileState extends State<Edit_Profile> {
  final picker = ImagePicker();
  double screenhight = 0;
  double screeenwidth = 0;
  DateTime? birthDate;

  @override
  Widget build(BuildContext context) {
    screenhight = MediaQuery.of(context).size.height;
    screeenwidth = MediaQuery.of(context).size.width;
    final logincontroller = Provider.of<login>(context, listen: false);
    final authprovider = Provider.of<Auth_Provider>(context, listen: false);

    String formattedBirthDate = birthDate != null
        ? DateFormat('dd/MM/yyyy').format(birthDate!)
        : "Enter your birth";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Edit proifle"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Consumer<Auth_Provider>(
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: () async {
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);

                          if (pickedFile != null) {
                            final image = File(pickedFile.path);
                            value.setImage(image);
                          }
                        },
                        child: Container(
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: AppColors.white,
                            child: value.selectedImage != null
                                ? Image.file(value.selectedImage!.absolute)
                                : Image.asset('assets/logo.png'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Consumer<login>(
                builder: (context, value, child) {
                  return Text_Form_Field(
                    onchange: (String value) {
                      logincontroller.validateName(value);
                    },
                    maxlines: 1,
                    prefixicon: const Icon(FontAwesomeIcons.person),
                    errortext: value.name.error,
                    hintext: "Enter your name",
                    controller: logincontroller.namecontroller,
                  );
                },
              ),
              const SizedBox(height: 10),
              GestureDetector(
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2101),
                    );

                    if (selectedDate != null && selectedDate != birthDate) {
                      setState(() {
                        birthDate = selectedDate;
                      });
                    }
                  },
                  child: Date_picker_field(
                    formattedBirthDate: formattedBirthDate,
                    icon: FontAwesomeIcons.cakeCandles,
                  )),
              const SizedBox(height: 10),
              Consumer<login>(
                builder: (context, value, child) {
                  return Text_Form_Field(
                    onchange: (String value) {
                      logincontroller.validatelocation(value);
                    },
                    maxlines: 1,
                    prefixicon: const Icon(FontAwesomeIcons.locationDot),
                    errortext: value.location.error,
                    hintext: "Enter your address",
                    controller: logincontroller.locationcontroller,
                  );
                },
              ),
              const SizedBox(height: 10),
              Consumer<Auth_Provider>(
                builder: (context, authProvider, child) {
                  return Button(
                    ontap: () async {
                      if (!logincontroller.iseditvalid) {
                        utils.Show_Flushbar_Error_Message(
                          "Please enter your field",
                          context,
                        );
                      } else {
                        authprovider.Profile_Edit(
                          Edit_Model(
                            name: logincontroller.namecontroller.text,
                            age: formattedBirthDate,
                            location: logincontroller.locationcontroller.text,
                            profileImageUrl:
                                authprovider.selectedImage!.toString(),
                          ),
                          context,
                        );
                      }
                    },
                    text: "change",
                    isLoading: authprovider.isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
