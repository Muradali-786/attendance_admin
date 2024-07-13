import 'package:attendance_admin/utils/component/dialoge_boxes/add_student_dialog.dart';
import 'package:attendance_admin/view/dash_board/classes/import/import_excel_sheet_dialpg.dart';
import 'package:attendance_admin/view/dash_board/classes/import/import_student_from_classes_dialog.dart';
import 'package:flutter/material.dart';
import '../../../../constant/app_style/app_colors.dart';
import '../../../../constant/app_style/app_styles.dart';
import '../../../../utils/component/custom_button.dart';

Future<void> showImportDialog(
    BuildContext context, String currentClassId) async {
  double h = MediaQuery.of(context).size.height;
  double w = MediaQuery.of(context).size.width;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
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
                      'Import Students',
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
              SizedBox(
                height: h * 0.020,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomRoundButton(
                      height: 35,
                      width: w * 0.17,
                      title: 'IMPORT FROM EXCEL',
                      onPress: () async {
                        Navigator.pop(context);
                        importExcelSheetDialog(context, currentClassId);
                      },
                      buttonColor: AppColor.kSecondaryColor),
                  SizedBox(
                    width: w * 0.2,
                    child: const Divider(
                      color: AppColor.kSecondaryColor,
                      thickness: 1,
                    ),
                  ),
                  CustomRoundButton(
                      height: 35,
                      width: w * 0.17,
                      title: 'IMPORT FROM CLASS',
                      onPress: () async {
                        Navigator.pop(context);
                        importStudentFromClassesDialog(
                            context, null, currentClassId);
                      },
                      buttonColor: AppColor.kSecondaryColor),
                  SizedBox(
                    width: w * 0.2,
                    child: const Divider(
                      color: AppColor.kSecondaryColor,
                      thickness: 1,
                    ),
                  ),
                  CustomRoundButton(
                      height: 35,
                      width: w * 0.17,
                      title: 'ADD STUDENT',
                      onPress: () async {
                        Navigator.pop(context);
                        addStudentDialog(context, currentClassId);
                      },
                      buttonColor: AppColor.kSecondaryColor),
                  SizedBox(
                    height: h * 0.020,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
