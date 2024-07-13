import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constant/app_style/app_colors.dart';

class Utils {
  static void onFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColor.kBlack,
      textColor: AppColor.kWhite,
      fontSize: 16,
    );
  }
}