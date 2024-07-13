
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constant/app_style/app_colors.dart';
import '../../../../constant/app_style/app_styles.dart';
import '../../../../utils/component/custom_button.dart';
import '../../../../utils/utils.dart';
import '../../../../view_model/add_students/students_controller.dart';
import '../../../../view_model/services/media/media_services.dart';

Future<void> importExcelSheetDialog(
    BuildContext context,
    String currentClassId,
    ) async {
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
                      'Import From Excel',
                      style: AppStyles().defaultStyle(
                          21, AppColor.kTextWhiteColor, FontWeight.w400),
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
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 8, 25, 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '-> Expected format of Excel is Roll#, Student Name',
                      style:
                      TextStyle(color: AppColor.kTextGreyColor, height: 1.5),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '-> First row is consider as header',
                      style: TextStyle(color: AppColor.kTextGreyColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer<StudentController>(builder: (context, provider, _) {
                      return Expanded(
                        child: CustomRoundButton(
                            title: 'SELECT FILE',
                            height: 35,
                            loading: provider.loading,
                            onPress: () async {
                              await MediaServices()
                                  .getStudentDataFromExcel()
                                  .then((value) async {
                                if (value.isNotEmpty && value[0].isNotEmpty && value[1].isNotEmpty) {
                                  await provider
                                      .addListOfStudent(
                                    currentClassId,
                                    value[0],
                                    value[1],
                                  ).then((value) {
                                    Navigator.pop(context);
                                  });

                                } else {
                                  Navigator.pop(context);
                                  Utils.toastMessage(
                                      'Please ensure the Excel sheet is not empty and is in the correct format.');
                                }
                              });
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
