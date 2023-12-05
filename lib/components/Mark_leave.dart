import 'package:attendance_app/components/Text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MarkLeaveDialog extends StatefulWidget {
  const MarkLeaveDialog({Key? key}) : super(key: key);

  @override
  _MarkLeaveDialogState createState() => _MarkLeaveDialogState();
}

class _MarkLeaveDialogState extends State<MarkLeaveDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mark Leave'),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text_Form_Field(
              hintext: "Enter your from date",
              prefixicon: Icon(FontAwesomeIcons.calendar),
            ),
            Gutter(),
            Text_Form_Field(
              hintext: "Enter your to date",
              prefixicon: Icon(FontAwesomeIcons.calendar),
            ),
            Gutter(),
            Text_Form_Field(
              maxlines: 3,
              lebel: Text("Reason"),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Mark Leave'),
        ),
      ],
    );
  }
}
