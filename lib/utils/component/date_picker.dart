import 'package:flutter/material.dart';
import '../../constant/app_style/app_colors.dart';

Future<DateTime> showDatePickerDialog(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    onDatePickerModeChange: (val){

    },
    builder: (context, Widget? child) {
      return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.kPrimaryColor,
            ),
          ),
          child: child!);
    },
  );
  if(pickedDate!=null){

    return pickedDate;
  }
  return DateTime.now();
}