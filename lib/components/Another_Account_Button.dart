import 'package:attendance_app/components/colors.dart';
import 'package:flutter/material.dart';

class AnotherAccountButton extends StatelessWidget {
  final imagepath;

  const AnotherAccountButton({
    Key? key,
    required this.imagepath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.white),
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 242, 241, 241)),
      child: Image.asset(imagepath, height: 40),
    );
  }
}
