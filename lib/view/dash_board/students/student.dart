import 'package:attendance_admin/model/class_model.dart';
import 'package:attendance_admin/model/student_model.dart';
import 'package:attendance_admin/utils/component/dialoge_boxes/delete_confirmations.dart';
import 'package:attendance_admin/utils/component/dialoge_boxes/update_std_dialog.dart';
import 'package:attendance_admin/view_model/add_students/students_controller.dart';
import 'package:attendance_admin/view_model/class_input/class_controller.dart';
import 'package:attendance_admin/view_model/teacher/teacher_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constant/app_style/app_colors.dart';
import '../../../constant/app_style/app_styles.dart';
import '../../../model/sign_up_model.dart';
import '../../../utils/component/custom_button.dart';
import '../../../utils/component/std_and_teacher_drop_down.dart';
import '../classes/import/import_dialog_box.dart';
import '../classes/update/updae_class_dialog.dart';

class StudentScreen extends StatefulWidget {
  static const String id = '\studentsScreen';
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  String? onTeacherSelect;
  String? onSubjectSelect;
  final ClassController _classController=ClassController();

  @override
  Widget build(BuildContext context) {
    int rowIndex = 0;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text('Students Information',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColor.kPrimaryColor)),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_circle,
                      color: AppColor.kSecondaryColor,
                    )),
              ],
            ),
           SizedBox(
              height: 35,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: TeacherDropdown(
                      value: onTeacherSelect,
                      onChanged: (String? newValue) {
                        setState(() {
                          onTeacherSelect = newValue;
                          onSubjectSelect=null;

                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: SubjectDropdown(
                    value: onSubjectSelect,
                    onChanged: (String? newVal) {
                      setState(() {
                        onSubjectSelect = newVal;
                      });
                    },
                    teacherId: onTeacherSelect.toString(),
                  ))
                ],
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: onSubjectSelect != null
                  ? _classController.getSingleClassesData(onSubjectSelect!)
                  : null,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else if (snapshot.hasError) {
                  return Container();
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container();
                } else {
                  List<ClassInputModel> snap = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                    doc.data() as Map<String, dynamic>;
                    return ClassInputModel.fromMap(data);
                  }).toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Subject Information',style: kSubHead,),
                      DataTable(
                        showCheckboxColumn: true,
                        headingRowColor: MaterialStateColor.resolveWith(
                              (states) => AppColor.kSecondaryColor,
                        ),
                        dataRowColor: MaterialStateColor.resolveWith(
                                (states) => AppColor.kWhite),
                        dividerThickness: 2.0,
                        border: TableBorder.all(color: AppColor.kGrey, width: 2),
                        columns: [
                          _dataColumnText('S.No'),
                          _dataColumnText('Name'),
                          _dataColumnText('Batch'),
                          _dataColumnText('Department'),
                          _dataColumnText('Class Sum'),
                          _dataColumnText('Credit-Hrs'),
                          _dataColumnText('Action'),

                        ],
                        rows: snap.map((course) {

                          return DataRow(
                            cells: [
                              _dataCellText('1'),
                              _dataCellText(course.subjectName.toString()),
                              _dataCellText(course.batchName.toString()),
                              _dataCellText(course.departmentName.toString()),
                              _dataCellText(course.totalClasses.toString()),
                              _dataCellText(course.creditHour.toString()),
                              DataCell(Row(
                                children: [
                                  CustomIconButton(
                                    icon: Icons.edit,
                                    tooltip: 'Click the button to edit class.',
                                    onTap: () {
                                      updateClassValueDialog(context, course);
                                    },
                                  ),
                                  CustomIconButton(
                                    icon: Icons.delete,
                                    tooltip: 'Click the button to delete class.',
                                    onTap: () {
                                      showDeleteClassConfirmationDialog(
                                          context, course);
                                    },
                                  ),
                                  CustomIconButton(
                                    icon: Icons.more_vert,
                                    tooltip: 'Click to open the import dialog',
                                    color: AppColor.kPrimaryColor,
                                    onTap: () {
                                      showImportDialog(
                                          context, course.subjectId.toString());
                                    },
                                  )
                                ],
                              ))

                            ],
                          );
                        }).toList(),
                      ),
                      Text('Enrolled Student Information',style: kSubHead,),
                    ],
                  );
                }
              },
            ),
            FutureBuilder<QuerySnapshot>(
              future: StudentController()
                  .getAllStudentDataByClassId(onSubjectSelect.toString()),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('loading');
                } else if (snapshot.hasError) {
                  return Text('Error');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Student has been added in the class.',
                    ),
                  );
                } else {
                  List<StudentModel> snap = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return StudentModel.fromMap(data);
                  }).toList();
        
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        showCheckboxColumn: true,
        
                        headingRowColor: MaterialStateColor.resolveWith(
                          (states) => AppColor.kSecondaryColor,
                        ),
                        dataRowColor: MaterialStateColor.resolveWith(
                            (states) => AppColor.kWhite),
                        dividerThickness: 2.0,
                        border: TableBorder.all(color: AppColor.kGrey, width: 2),
                        columns: [
                          _dataColumnText('S.No'),
                          _dataColumnText('Roll No'),
                          _dataColumnText('Name'),
                          _dataColumnText('Absent'),
                          _dataColumnText('Leaves'),
                          _dataColumnText('Present'),
                          _dataColumnText('%'),
                          _dataColumnText('Actions'),
                        ],
                        rows: snap.map((student) {
                          rowIndex++;
                          return DataRow(
                            cells: [
                              _dataCellText(rowIndex.toString()),
                              _dataCellText(student.studentRollNo),
                              _dataCellText(student.studentName),
                              _dataCellText(student.totalAbsent.toString()),
                              _dataCellText(student.totalLeaves.toString()),
                              _dataCellText(student.totalPresent.toString()),
                              _dataCellText("${student.attendancePercentage}%"),
                              DataCell(Row(
                                children: [
                                  CustomIconButton(
                                    icon: Icons.edit,
                                    tooltip: 'Click the button to edit student.',
                                    onTap: () {
                                      updateStudentDialog(
                                        context,
                                        onSubjectSelect.toString(),
                                        student,
                                      );


                                    },
                                  ),
                                  CustomIconButton(
                                    icon: Icons.delete,
                                    tooltip:
                                    'Click the button to delete student.',
                                    onTap: () {
                                      showDeleteStudentConfirmationDialog(context,
                                          student, onSubjectSelect.toString());
                                    },
                                  ),

                                ],
                              ))
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  DataCell _dataCellText(String title) {
    return DataCell(
      Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: AppColor.kPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  DataColumn _dataColumnText(String title) {
    return DataColumn(
      tooltip: title,
      label: Text(
        title,
        style: const TextStyle(
            color: AppColor.kWhite, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
