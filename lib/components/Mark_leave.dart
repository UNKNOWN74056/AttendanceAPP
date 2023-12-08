import 'package:attendance_app/components/Text_field_widget.dart';
import 'package:attendance_app/components/colors.dart';
import 'package:attendance_app/model/Mark_leave_model.dart';
import 'package:attendance_app/provider/Authentication_provider.dart';
import 'package:attendance_app/provider/Mark_Leave_provider.dart';
import 'package:attendance_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MarkLeaveDialog extends StatefulWidget {
  const MarkLeaveDialog({Key? key}) : super(key: key);

  @override
  _MarkLeaveDialogState createState() => _MarkLeaveDialogState();
}

class _MarkLeaveDialogState extends State<MarkLeaveDialog> {
  @override
  Widget build(BuildContext context) {
    final markLeaveprovider = Provider.of<Mark_leave>(context, listen: false);
    final MarkAuth = Provider.of<Auth_Provider>(context, listen: false);

    return AlertDialog(
      title: const Text('Mark Leave'),
      content: Container(
        constraints: const BoxConstraints(
            maxHeight: 400), // Adjust the maxHeight as needed
        child: SingleChildScrollView(
          child: Consumer<Mark_leave>(
            builder: (context, val, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text_Form_Field(
                    errortext: val.To_date.error,
                    maxlines: 1,
                    onchange: (String value) {
                      DateTime parsedDate = DateTime.parse(value);
                      markLeaveprovider.validate_to_Date(parsedDate);
                    },
                    controller: markLeaveprovider.FROM_DATE_CONTROLLER,
                    hintext: "Enter your from date",
                    prefixicon: GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null &&
                              pickedDate != DateTime.now()) {
                            // Format the picked date and update the controller
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);

                            markLeaveprovider.FROM_DATE_CONTROLLER.text =
                                formattedDate;
                          }
                        },
                        child: const Icon(
                          FontAwesomeIcons.calendar,
                          color: AppColors.red,
                        )),
                  ),
                  const Gutter(),
                  Text_Form_Field(
                    maxlines: 1,
                    onchange: (String value) {
                      DateTime parsedDate = DateTime.parse(value);
                      markLeaveprovider.validate_from_Date(parsedDate);
                    },
                    errortext: val.From_date.error,
                    controller: markLeaveprovider.TO_DATE_CONTORLLER,
                    hintext: "Enter your to date",
                    prefixicon: GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null &&
                              pickedDate != DateTime.now()) {
                            // Format the picked date and update the controller
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);

                            markLeaveprovider.TO_DATE_CONTORLLER.text =
                                formattedDate;
                          }
                        },
                        child: const Icon(
                          FontAwesomeIcons.calendar,
                          color: AppColors.green,
                        )),
                  ),
                  const Gutter(),
                  Text_Form_Field(
                    onchange: (String value) {
                      markLeaveprovider.validateReason(value);
                    },
                    errortext: val.Reason.error,
                    controller: markLeaveprovider.REASONE_CONTROLLER,
                    maxlines: 2,
                    lebel: const Text("Reason"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        
        //NOTE TODO: VALIDATION OF MARK LEAVE DAILOG
        Consumer<Mark_leave>(
          builder: (context, value, child) {
            return ElevatedButton(
              onPressed: () {
                if (!markLeaveprovider.isvalid) {
                  utils.showToastMessage("Please fill the fields!");
                } else {
                  MarkAuth.Mark_leave(
                    context,
                    Markleave(
                      toDate: markLeaveprovider.TO_DATE_CONTORLLER.text,
                      fromDate: markLeaveprovider.FROM_DATE_CONTROLLER.text,
                      reasone: markLeaveprovider.REASONE_CONTROLLER.text,
                    ),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Mark Leave'),
            );
          },
        ),
      ],
    );
  }
}
