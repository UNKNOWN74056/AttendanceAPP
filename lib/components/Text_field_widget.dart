import 'package:flutter/material.dart';

class Text_Form_Field extends StatelessWidget {
  final onchange;
  final hintext;
  final errortext;
  final controller;
  final bool obsecuretext;
  final sufixicon;
  final maxlines;
  final lebel;
  final prefixicon;
  const Text_Form_Field(
      {super.key,
      this.onchange,
      this.errortext,
      this.hintext,
      this.controller,
      this.sufixicon,
      this.prefixicon,
      this.lebel,
      this.maxlines,
      this.obsecuretext = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecuretext,
      onChanged: onchange,
      maxLines: maxlines,
      decoration: InputDecoration(
          suffixIcon: sufixicon,
          hintText: hintext,
          prefixIcon: prefixicon,
          label: lebel,
          errorText: errortext,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}
