import 'package:attendance_admin/view_model/teacher/teacher_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constant/app_style/app_colors.dart';
import '../../../../model/sign_up_model.dart';
import '../../../../utils/component/custom_button.dart';
import '../../../../utils/component/dialog_text_field.dart';
import '../../../../utils/utils.dart';

Future<void> registerNewTeacherDialog(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  TextEditingController pasController = TextEditingController();
  FocusNode passFocus = FocusNode();
  TextEditingController confirmPassController = TextEditingController();
  FocusNode confirmPassFocus = FocusNode();

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: AppColor.kSecondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Text(
                      'Register Teacher',
                      style: TextStyle(fontSize: 22, color: AppColor.kWhite),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            DialogInputTextField(
                                labelText: 'Name',
                                myController: nameController,
                                focusNode: nameFocus,
                                onFieldSubmittedValue: (val) {
                                  Utils.onFocusChange(
                                      context, nameFocus, emailFocus);
                                },
                                hint: 'Name',
                                onValidator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Please enter your name';
                                  } else if (value.trim().length < 3) {
                                    return 'Name must be at least 3 characters long';
                                  } else if (!RegExp(r'^[a-zA-Z ]+$')
                                      .hasMatch(value)) {
                                    return 'Name cannot contain numbers or special characters';
                                  }

                                  return null;
                                },
                                keyBoardType: TextInputType.text),
                            DialogInputTextField(
                                labelText: 'Email',
                                myController: emailController,
                                focusNode: emailFocus,
                                onFieldSubmittedValue: (val) {
                                  Utils.onFocusChange(
                                      context, emailFocus, passFocus);
                                },
                                hint: 'Email',
                                onValidator: (value) {
                                  final RegExp emailRegExp = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (value.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!emailRegExp.hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }

                                  return null;
                                },
                                keyBoardType: TextInputType.emailAddress),
                            DialogInputTextField(
                                labelText: 'Password',
                                myController: pasController,
                                focusNode: passFocus,
                                onFieldSubmittedValue: (val) {
                                  Utils.onFocusChange(
                                      context, passFocus, confirmPassFocus);
                                },
                                hint: 'Password',
                                onValidator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Please enter your password';
                                  } else if (value.trim().length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }

                                  return null;
                                },
                                keyBoardType: TextInputType.visiblePassword),
                            DialogInputTextField(
                                labelText: 'Confirm Password',
                                myController: confirmPassController,
                                focusNode: confirmPassFocus,
                                onFieldSubmittedValue: (val) {},
                                hint: 'Confirm Password',
                                onValidator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Please confirm your password';
                                  } else if (value.trim() !=
                                      pasController.value.text.trim()) {
                                    return 'Please enter same Password';
                                  }

                                  return null;
                                },
                                keyBoardType: TextInputType.visiblePassword),
                          ],
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 22, 30, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: CustomRoundButton(
                          height: 32,
                          title: 'CLOSE',
                          onPress: () {
                            Navigator.pop(context);
                          },
                          buttonColor: AppColor.kSecondaryColor),
                    ),
                    const SizedBox(width: 5),
                    Consumer<TeacherController>(
                        builder: (context, provider, _) {
                      return Expanded(
                        child: CustomRoundButton(
                          height: 32,
                          title: 'REGISTER',
                          loading: provider.loading,
                          onPress: () async {
                            if (formKey.currentState!.validate()) {
                              SignUpModel signUpModel = SignUpModel(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: pasController.text.trim());

                              await provider
                                  .registerTeacher(signUpModel)
                                  .then((value) {
                                nameController.clear();
                                emailController.clear();
                                pasController.clear();
                                confirmPassController.clear();
                              });
                            }
                          },
                          buttonColor: AppColor.kSecondaryColor,
                        ),
                      );
                    })
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
