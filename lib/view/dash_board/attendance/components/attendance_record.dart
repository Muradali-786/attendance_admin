import 'package:attendance_admin/model/student_model.dart';
import 'package:attendance_admin/utils/component/date_picker.dart';
import 'package:attendance_admin/view_model/add_students/students_controller.dart';
import 'package:attendance_admin/view_model/class_input/class_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../constant/app_style/app_colors.dart';
import '../../../../constant/app_style/app_styles.dart';
import '../../../../model/attendance_model.dart';
import '../../../../model/class_model.dart';
import '../../../../model/student_status_model.dart';
import '../../../../utils/component/custom_button.dart';
import '../../../../utils/component/dialoge_boxes/delete_confirmations.dart';
import '../../../../utils/component/std_and_teacher_drop_down.dart';
import '../../../../utils/component/time_picker.dart';
import '../../../../utils/utils.dart';
import '../../../../view_model/attendance/attendance_controller.dart';
import '../../classes/import/import_dialog_box.dart';
import '../../classes/update/updae_class_dialog.dart';
import 'package:intl/intl.dart';

class AttendanceRecord extends StatefulWidget {
  const AttendanceRecord({super.key});

  @override
  State<AttendanceRecord> createState() => _AttendanceRecordState();
}

class _AttendanceRecordState extends State<AttendanceRecord> {
  final ClassController _classController = ClassController();
  String? onTeacherSelect;
  String? onSubjectSelect;
  String? onAttendSelect;
  List<String> stdIdList = [];
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime currentDate = DateTime.now();
  bool timeChange = false;
  bool dateChange = false;

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay pickedTime = await showTimePickerDialog(context);

    if (pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        timeChange = true;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime pickedDate = await showDatePickerDialog(context);

    if (pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        dateChange = true;
      });
    }
  }

  Timestamp? _previousDate;

  String formatDate(DateTime dateTime) {
    final formatter = DateFormat('yMMMMd');
    return formatter.format(dateTime);
  }

  List<StudentModel>? stdModel;
  List<StudentStatusModel> studentStatuses = [];
  late bool isChange;

  @override
  Widget build(BuildContext context) {
    isChange = false;
    stdModel = [];
    studentStatuses = [];
    stdIdList = [];
    String period = selectedTime.hour < 12 ? 'AM' : 'PM';
    String hour = selectedTime.hourOfPeriod.toString().padLeft(2, '0');
    String minute = selectedTime.minute.toString().padLeft(2, '0');
    String currentTime = '$hour:$minute $period';
    if (onSubjectSelect != null) {
      StudentController()
          .getAllStudentDataByClassId(onSubjectSelect.toString())
          .then((value) {
        stdModel = value.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return StudentModel.fromMap(data);
        }).toList();
      });
    }

    return Column(
      children: [
        SizedBox(
          height: 35,
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
                      onAttendSelect = null;
                    });
                  },
                  teacherId: onTeacherSelect.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AttendanceDatesDropdown(
                    value: onAttendSelect,
                    onChanged: (String? newV) {
                      setState(() {
                        onAttendSelect = newV;
                      });
                    },
                    subjectId: onSubjectSelect.toString()),
              ),
              const SizedBox(width: 8),
              _saveAttendanceButton(currentTime),
              const SizedBox(width: 8),
              _delAttendanceButton(currentTime),
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
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
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
                    'Enrolled Student Attendance Information',
                    style: kSubHead,
                  ),
                ],
              );
            }
          },
        ),
        FutureBuilder<DocumentSnapshot>(
          future: (onSubjectSelect != null && onAttendSelect != null)
              ? AttendanceController().getAttendanceById(
                  onSubjectSelect.toString(), onAttendSelect.toString())
              : null,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading');
            } else if (snapshot.hasError) {
              return Text('Error');
            } else if (!snapshot.hasData || snapshot.data!.data() == null) {
              return const Center(
                child: Text(
                  'No Attendance has been taken yet.',
                ),
              );
            } else {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              StudentStatusModel stdStatuses;

              Map<String, dynamic> attendanceList = data['attendanceList'];

              stdModel!.forEach((element) {
                if (attendanceList.containsKey(element.studentId)) {
                  _previousDate = data['selectedDate'];
                  stdIdList.add(element.studentId.toString());
                  var stdStatus = StudentStatusModel(
                    studentId: element.studentId,
                    studentName: element.studentName,
                    studentRollNo: element.studentRollNo,
                    studentStatus: attendanceList[element.studentId].toString(),
                    selectedDate: data['selectedDate'],
                    currentTime: data['currentTime'],
                  );
                  studentStatuses.add(stdStatus);
                }
              });

              return Consumer<AttendanceController>(
                  builder: (context, provider, child) {
                List<DataRow> dataRows = List<DataRow>.generate(
                  studentStatuses.length,
                  (index) => DataRow(
                    cells: [
                      _dataCellText("${index + 1}"),
                      _dataCellText(studentStatuses[index].studentRollNo),
                      _dataCellText(studentStatuses[index].studentName),
                      DataCell(
                        Tooltip(
                          message: 'Click the button to Change the date',
                          child: TextButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            child: Text(
                              dateChange
                                  ? _formatDate(currentDate)
                                  : _formatDate(_previousDate!.toDate()),
                              style: AppStyles().defaultStyle(
                                18,
                                AppColor.kPrimaryColor,
                                FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: 'Click the button to Change time',
                          child: TextButton(
                            onPressed: () {
                              _selectTime(context);
                            },
                            child: Text(
                              currentTime.toString(),
                              style: AppStyles().defaultStyle(
                                18,
                                AppColor.kPrimaryColor,
                                FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        CustomStatusChangerButton(
                          attendanceStatus: attendanceList[
                              studentStatuses[index].studentId.toString()],
                          onTap: () {
                            if (!isChange) {
                              provider.setStatusMap(attendanceList);
                              isChange = true;
                            }
                            provider.updateStatusListBasedOnKey(
                              studentStatuses[index].studentId!,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );

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
                        (states) => AppColor.kWhite,
                      ),
                      dividerThickness: 2.0,
                      border: TableBorder.all(color: AppColor.kGrey, width: 2),
                      columns: [
                        _dataColumnText('S.No'),
                        _dataColumnText('Roll No'),
                        _dataColumnText('Name'),
                        _dataColumnText('current Date'),
                        _dataColumnText('current Time'),
                        _dataColumnText('Status'),
                      ],
                      rows: dataRows,
                    ),
                  ),
                );
              });
            }
          },
        )

      ],
    );
  }

  Widget _saveAttendanceButton(currentTime) {
    return Consumer<AttendanceController>(builder: (context, provider, child) {
      return CustomRoundButton(
        height: 35,
        title: 'UPDATE',
        loading: provider.loading,
        onPress: () async {
          if (isChange && stdIdList.isNotEmpty && onAttendSelect != null) {
            AttendanceModel model = AttendanceModel(
              classId: onSubjectSelect.toString(),
              attendanceId: onAttendSelect.toString(),
              createdAtDate: _previousDate!.toDate(),
              selectedDate: dateChange
                  ? currentDate.subtract(Duration(days: 1))
                  : _previousDate!.toDate(),
              currentTime: currentTime,
              attendanceList: provider.updatedStatusMap!,
            );

            await provider.updateStudentAttendance(model);

            await StudentController().calculateStudentAttendance(
                onSubjectSelect.toString(), stdIdList);
          } else {
            Utils.toastMessage('Please select attendance or update any status');
          }
        },
        buttonColor: AppColor.kPrimaryColor,
      );
    });
  }

  String _formatDate(DateTime dateTime) {
    final formatter = DateFormat('yMMMMd');
    return formatter.format(dateTime);
  }

  Widget _delAttendanceButton(currentTime) {
    return CustomRoundButton(
      height: 35,
      title: 'DELETE',
      onPress: () async {
        if (onAttendSelect != null) {
          showDeleteAttendanceConfirmationDialog(
                  context,
                  onSubjectSelect.toString(),
                  onAttendSelect.toString(),
                  currentDate,
                  currentTime,
                  stdIdList)
              .then((value) {
            setState(() {
              onAttendSelect = null;
            });
          });
        } else {
          Utils.toastMessage('Please select the attendance first');
        }
      },
      buttonColor: AppColor.kSecondaryColor,
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
