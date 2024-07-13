import 'package:attendance_admin/model/student_model.dart';
import 'package:attendance_admin/utils/component/date_picker.dart';
import 'package:attendance_admin/view_model/add_students/students_controller.dart';
import 'package:attendance_admin/view_model/class_input/class_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constant/app_style/app_colors.dart';
import '../../../constant/app_style/app_styles.dart';
import '../../../model/attendance_model.dart';
import '../../../model/class_model.dart';
import '../../../utils/component/custom_button.dart';
import '../../../utils/component/dialoge_boxes/delete_confirmations.dart';
import '../../../utils/component/std_and_teacher_drop_down.dart';
import '../../../utils/component/time_picker.dart';
import '../../../utils/utils.dart';
import '../../../view_model/attendance/attendance_controller.dart';
import '../classes/import/import_dialog_box.dart';
import '../classes/update/updae_class_dialog.dart';
import 'components/attendance_record.dart';
import 'components/take_attendance.dart';

class AttendanceScreen extends StatefulWidget {
  static const String id = '\attendanceScreen';
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<String> _reports = ["Attendance", "Attendance Records"];
  String? _selectedReport = 'Attendance';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text('Attendance Information',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColor.kPrimaryColor)),
                  ),
                  DropdownButton<String>(
                    hint: Text(
                      "Select",
                      style: TextStyle(
                          color: AppColor.kPrimaryTextColor, fontSize: 18),
                    ),
                    value: _selectedReport,
                    dropdownColor: AppColor.kSubmarine,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedReport = newValue;
                      });
                    },
                    items: _reports.map((report) {
                      return DropdownMenuItem(
                        child: Text(report,
                            style: TextStyle(color: AppColor.kPrimaryColor)),
                        value: report,
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_selectedReport == "Attendance") ...[
                const TakeAttendance(),
              ] else if (_selectedReport == "Attendance Records") ...[
                const AttendanceRecord(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}



