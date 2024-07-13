

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/app_style/app_colors.dart';
import '../../../constant/app_style/app_styles.dart';
import '../../../model/student_model.dart';
import '../../../view_model/add_students/students_controller.dart';
import '../../utils.dart';
import '../custom_button.dart';
import '../dialog_text_field.dart';

Future<void> addStudentDialog(BuildContext context, String classId) async {
  final _formKey = GlobalKey<FormState>();
  TextEditingController stdNameController = TextEditingController();
  FocusNode stdNameFocus = FocusNode();
  TextEditingController rollNController = TextEditingController();
  FocusNode rollNoFocus = FocusNode();
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
                      'Add Student',
                      style: AppStyles().defaultStyle(
                          22, AppColor.kTextWhiteColor, FontWeight.w400),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (){
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
                        labelText: 'Student Name',
                        myController: stdNameController,
                        focusNode: stdNameFocus,
                        onFieldSubmittedValue: (val) {
                          Utils.onFocusChange(context, stdNameFocus, rollNoFocus);
                        },
                        hint: 'Student Name',
                        onValidator: (val) {
                          if (val.trim().isEmpty) {
                            return 'Please enter Student Name';
                          } else if (val.trim().length < 3) {
                            return 'Student Name  at least 3 characters long';
                          } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val)) {
                            return 'Student Name cannot contain special characters';
                          }
                          return null;
                        },
                        keyBoardType: TextInputType.text,
                      ),
                      DialogInputTextField(
                        labelText: 'Roll Number / Registration#',
                        myController: rollNController,
                        focusNode: rollNoFocus,
                        onFieldSubmittedValue: (val) {},
                        hint: 'Roll Number / Registration#',
                        onValidator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter student Roll No';
                          } else if (val.trim().length < 2) {
                            return 'Roll No  at least 2 characters long';
                          } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val)) {
                            return 'Roll No cannot contain special characters';
                          }
                          return null;
                        },
                        keyBoardType: TextInputType.text,
                      ),

                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: CustomRoundButton(
                          title: 'SAVE & CLOSE',
                          height: 32,
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              StudentModel studentModel = StudentModel(
                                  studentName: stdNameController.text.trim(),
                                  studentRollNo: rollNController.text.trim().toString());

                              StudentController()
                                  .addNewStudent(studentModel, classId);
                            }
                          },
                          buttonColor: AppColor.kSecondaryColor),
                    ),
                    const SizedBox(width: 5),
                    Consumer<StudentController>(builder: (context, provider, _) {
                      return Expanded(
                        child: CustomRoundButton(
                            title: 'ADD ANOTHER',
                            loading: provider.loading,
                            height: 32,
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                StudentModel studentModel = StudentModel(
                                    studentName: stdNameController.text.trim(),
                                    studentRollNo:
                                        rollNController.text.trim().toString());

                                provider
                                    .addNewStudent(studentModel, classId)
                                    .then((value) {
                                  stdNameController.clear();
                                  rollNController.clear();
                                });
                              }
                            },
                            buttonColor: AppColor.kSecondaryColor),
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


