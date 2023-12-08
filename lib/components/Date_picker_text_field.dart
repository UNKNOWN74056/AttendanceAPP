import 'package:flutter/material.dart';

class Date_picker_field extends StatelessWidget {
  final String formattedBirthDate;
  final IconData icon;

  const Date_picker_field(
      {Key? key, required this.formattedBirthDate, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(),
      padding: const EdgeInsets.only(),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(icon),
          ),
          const SizedBox(width: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(formattedBirthDate),
          ),
        ],
      ),
    );
  }
}
