import 'package:flutter/material.dart';
import '../../constant/app_style/app_colors.dart';
import '../../constant/app_style/app_styles.dart';

Future<TimeOfDay> showTimePickerDialog(BuildContext context) async {
  final selectedTime = TimeOfDay.now();

  final timePickerTheme = TimePickerThemeData(
    backgroundColor: AppColor.kBgColor,
    dayPeriodColor: MaterialStateColor.resolveWith(
          (states) => states.contains(MaterialState.selected)
          ? AppColor.kSecondary54Color
          : AppColor.kSecondaryColor,
    ),
    dayPeriodTextColor: AppColor.kTextWhiteColor,
    hourMinuteColor: MaterialStateColor.resolveWith(
          (states) => states.contains(MaterialState.selected)
          ? AppColor.kSecondary54Color
          : AppColor.kSecondaryColor,
    ),
    hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected)
        ? AppColor.kTextWhiteColor
        : AppColor.kPrimaryColor),
    dialHandColor: AppColor.kSecondaryColor,
    dialBackgroundColor: AppColor.kGrey.withOpacity(0.4),
    hourMinuteTextStyle:
    AppStyles().defaultStyle(32, AppColor.kTextBlackColor, FontWeight.bold),
    dayPeriodTextStyle:
    AppStyles().defaultStyle(16, Colors.black, FontWeight.bold),
    helpTextStyle:
    AppStyles().defaultStyle(22, AppColor.kSecondaryColor, FontWeight.bold),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
    dialTextColor: MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected)
        ? AppColor.kWhite
        : AppColor.kBlack),
    entryModeIconColor: AppColor.kPrimaryColor,
  );
  TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: selectedTime,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          // This uses the _timePickerTheme defined above
          timePickerTheme: timePickerTheme,
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                      (states) => AppColor.kSecondaryColor),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  return pickedTime ?? selectedTime;
}