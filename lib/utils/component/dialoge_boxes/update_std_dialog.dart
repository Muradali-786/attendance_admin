
import 'package:flutter/material.dart';

import '../../../constant/app_style/app_colors.dart';
import '../../../constant/app_style/app_styles.dart';
import '../../../model/student_model.dart';
import '../../../view_model/add_students/students_controller.dart';
import '../../utils.dart';
import '../custom_button.dart';
import '../dialog_text_field.dart';


Future<void> updateStudentDialog(
  BuildContext context,
  String classId,
  StudentModel model,
) async {
  final _formKey = GlobalKey<FormState>();
  TextEditingController stdNameController =
      TextEditingController(text: model.studentName);
  FocusNode stdNameFocus = FocusNode();
  TextEditingController rollNController =
      TextEditingController(text: model.studentRollNo);
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
                      'Edit Student',
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
                        if (val.isEmpty) {
                          return 'Please enter Student Name';
                        } else if (val.length < 3) {
                          return 'Student Name  at least 3 characters long';
                        } else if (!RegExp(r'^[a-zA-Z0-9 -]+$').hasMatch(val)) {
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
                          return 'Please enter Roll No';
                        } else if (val.length < 2) {
                          return 'Roll No  at least 2 characters long';
                        } else if (!RegExp(r'^[a-zA-Z0-9 -]+$').hasMatch(val)) {
                          return 'Roll No cannot contain special characters';
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
                        title: 'SAVE',
                        height: 32,
                        onPress: () async {
                          if(_formKey.currentState!.validate()){
                            Navigator.pop(context);
                            StudentModel studentModel = StudentModel(
                              studentId: model.studentId,
                              studentName: stdNameController.text,
                              studentRollNo: rollNController.text,
                            );
                            await StudentController().updateStudentData(
                              studentModel,
                              classId,
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

