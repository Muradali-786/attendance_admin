import 'package:attendance_admin/view_model/teacher/teacher_controller.dart';
import 'package:flutter/material.dart';
import '../../../constant/app_style/app_colors.dart';
import '../../../constant/app_style/app_styles.dart';
import '../custom_button.dart';
import '../dialog_text_field.dart';

Future<void> updateTeacherProfileDialog(
    BuildContext context, String id, String name) async {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController(text: name);
  FocusNode nameFocus = FocusNode();

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColor.kSecondaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Text(
                      'Update Profile',
                      style: AppStyles().defaultStyle(
                          22, AppColor.kTextWhiteColor, FontWeight.w400),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: AppColor.kWhite,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DialogInputTextField(
                          labelText: 'Profile Name',
                          myController: nameController,
                          focusNode: nameFocus,
                          onFieldSubmittedValue: (val) {},
                          hint: 'Profile Name',
                          onValidator: (val) {
                            if (val.trim().isEmpty) {
                              return 'Please enter Name';
                            } else if (val.trim().length < 3) {
                              return 'Name  at least 3 characters long';
                            } else if (!RegExp(r'^[a-zA-Z0-9 -]+$')
                                .hasMatch(val)) {
                              return 'Student Name cannot contain special characters';
                            }
                            return null;
                          },
                          keyBoardType: TextInputType.text,
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 22, 25, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: CustomRoundButton(
                          title: 'CLOSE',
                          height: 32,
                          onPress: () {
                            Navigator.pop(context);
                          },
                          buttonColor: AppColor.kSecondaryColor),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: CustomRoundButton(
                        title: 'UPDATE',
                        height: 32,
                        onPress: () async {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            TeacherController().updateTeacherProfile(
                              id,
                              nameController.text.trim(),
                            );
                          }
                        },
                        buttonColor: AppColor.kSecondaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}