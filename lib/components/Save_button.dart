import 'package:attendance_app/components/colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  final bool isLoading;

  const Button({
    Key? key,
    required this.text,
    required this.ontap,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: isLoading ? null : ontap, // Disable button when loading
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.blue,
          ),
          height: 50,
          width: double.infinity,
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    text,
                    style: const TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
