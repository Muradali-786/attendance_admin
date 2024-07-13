
import 'package:flutter/material.dart';

import '../../constant/app_style/app_colors.dart';

class DialogInputTextField extends StatelessWidget {
  final TextEditingController myController;
  final FocusNode focusNode;
  final FormFieldSetter onFieldSubmittedValue;

  final FormFieldValidator onValidator;
  final TextInputType keyBoardType;
  final bool obsecureText;
  final String hint, labelText;
  final Color cursorColor;
  final bool enable, autoFocus;
  const DialogInputTextField({
    Key? key,
    this.cursorColor = AppColor.kSecondaryColor,
    required this.myController,
    required this.focusNode,
    required this.onFieldSubmittedValue,
    required this.hint,
    required this.labelText,
    required this.onValidator,
    required this.keyBoardType,
    this.obsecureText = false,
    this.enable = true,
    this.autoFocus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmittedValue,
      validator: onValidator,
      keyboardType: keyBoardType,
      cursorColor: cursorColor,
     cursorHeight: 5,
      enabled: enable,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      style:TextStyle(fontSize: 28,color: AppColor.kPrimaryTextColor),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.all(16),
        hintStyle:TextStyle(fontSize: 20,color: AppColor.kTextGreyColor),


        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.kFocusBorderColor, width: 1.5),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.kAlertColor),
        ),
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 14,color: AppColor.kSecondaryTextColor)


      ),
    );
  }
}
