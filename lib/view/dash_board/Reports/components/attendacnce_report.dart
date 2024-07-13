import 'package:attendance_admin/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../constant/app_style/app_colors.dart';
import '../../../../constant/app_style/app_styles.dart';
import '../../../../model/attendance_report_model.dart';
import '../../../../model/class_model.dart';
import '../../../../utils/component/custom_button.dart';
import '../../../../utils/component/dialoge_boxes/delete_confirmations.dart';
import '../../../../utils/component/std_and_teacher_drop_down.dart';
import '../../../../view_model/attendance/attendance_controller.dart';
import '../../../../view_model/class_input/class_controller.dart';
import '../../../../view_model/services/media/media_services.dart';
import '../../classes/import/import_dialog_box.dart';
import '../../classes/update/updae_class_dialog.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  final ClassController _classController = ClassController();
  String? onTeacherSelect;
  String? onSubjectSelect;

  int index = 0;
  String formatDate(DateTime dateTime) {
    final formatter = DateFormat('yMMMMd');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
                        onSubjectSelect = null;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SubjectDropdown(
                    value: onSubjectSelect,
                    onChanged: (String? newValue) {
                      setState(() {
                        onSubjectSelect = newValue;
                      });
                    },
                    teacherId: onTeacherSelect.toString(),
                  ),
                ),
                const SizedBox(width: 10),
                _saveAttendanceButton(),
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
                    Text(
                      'Subject Information',
                      style: kSubHead,
                    ),
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
                    Text(
                      'Enrolled Student Information',
                      style: kSubHead,
                    ),
                  ],
                );
              }
            },
          ),
          FutureBuilder<List<AttendanceReportModel>>(
            future: onSubjectSelect != null
                ? AttendanceController()
                    .getAllAttendanceReportBySubject(onSubjectSelect!)
                : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<AttendanceReportModel> students = snapshot.data!;
                return SingleChildScrollView(
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
                      _dataColumnText('Name'),
                      _dataColumnText('Roll No'),
                      ...List.generate(
                        students.isNotEmpty ? students.first.dates.length : 0,
                        (index) => DataColumn(
                          label: Text(
                              students.isNotEmpty
                                  ? formatDate(students.first.dates[index]
                                      .toDate()
                                      .toUtc())
                                  : 'Date ${index + 1}',
                              style: const TextStyle(
                                  color: AppColor.kWhite,
                                  overflow: TextOverflow.ellipsis)),
                        ),
                      ),
                      _dataColumnText('Std %'),
                    ],
                    rows: students.map((student) {
                      return DataRow(cells: [
                        _dataCellText(student.studentName),
                        _dataCellText(student.studentRollNo),
                        ...student.attendanceList.map((status) {
                          return _dataCellText(status);
                        }).toList(),
                        _dataCellText("${student.percentage.toString()}%"),
                      ]);
                    }).toList(),
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
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

  Widget _saveAttendanceButton() {
    return Consumer<MediaServices>(builder: (context, provider, _) {
      return CustomRoundButton(
        height: 35,
        title: 'EXPORT',
        loading: provider.loading,
        onPress: () async {
          if (onSubjectSelect != null) {
            await provider.exportAndShareAttendanceSheet(onSubjectSelect!);

          } else {
            Utils.toastMessage('Please select Any subject');
          }
        },
        buttonColor: AppColor.kPrimaryColor,
      );
    });
  }
}
