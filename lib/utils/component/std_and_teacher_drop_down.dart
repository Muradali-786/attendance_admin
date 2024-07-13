import 'package:attendance_admin/model/attendance_model.dart';
import 'package:attendance_admin/model/class_model.dart';
import 'package:attendance_admin/view_model/attendance/attendance_controller.dart';
import 'package:attendance_admin/view_model/class_input/class_controller.dart';
import 'package:attendance_admin/view_model/teacher/teacher_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constant/app_style/app_colors.dart';
import '../../../model/sign_up_model.dart';

class TeacherDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const TeacherDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,

      decoration: BoxDecoration(
        border: Border.all(color: AppColor.kGrey),
      ),
      child: FutureBuilder<QuerySnapshot>(
        future: TeacherController().getTeacherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<SignUpModel> snap = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return SignUpModel.fromMap(data);
            }).toList();
            return DropdownButton<String>(
              dropdownColor: AppColor.kWhite,
              focusColor: AppColor.kSecondary54Color,
              items: snap.map((SignUpModel model) {
                return DropdownMenuItem<String>(
                  value: model.teacherId,
                  child: Text(model.name),
                );
              }).toList(),
              onChanged: onChanged,
              value: value,
              hint: Text('Select a Teacher',
                  style: TextStyle(color: AppColor.kTextGreyColor)),
              isExpanded: true,
              style: TextStyle(
                  color: AppColor.kPrimaryColor, fontWeight: FontWeight.w700),
            );
          }
        },
      ),
    );
  }
}

class SubjectDropdown extends StatelessWidget {
  String? value;
  final ValueChanged<String?> onChanged;
  final String teacherId;

  SubjectDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.teacherId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.kGrey),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: ClassController().streamClassesDataByTeacherId(teacherId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<ClassInputModel> snap = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return ClassInputModel.fromMap(data);
            }).toList();

            return DropdownButton<String>(
              dropdownColor: AppColor.kWhite,
              focusColor: AppColor.kSecondary54Color,
              items: snap.map((ClassInputModel model) {
                return DropdownMenuItem<String>(
                  value: model.subjectId,
                  child: Text(model.subjectName.toString()),
                );
              }).toList(),
              onChanged: onChanged,
              value: value,
              hint: Text('Select a subject',
                  style: TextStyle(color: AppColor.kBlack)),
              isExpanded: true,
              style: TextStyle(
                  color: AppColor.kPrimaryColor, fontWeight: FontWeight.w700),
            );
          } else {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  color: AppColor.kAlertColor,
                ),
                SizedBox(width: 7),
                Text(
                  'No Classes Available',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColor.kAlertColor),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class AttendanceDatesDropdown extends StatelessWidget {
  String? value;
  final ValueChanged<String?> onChanged;
  final String subjectId;

  AttendanceDatesDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.subjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime dateTime) {
      final formatter = DateFormat('yMMMMd');
      return formatter.format(dateTime);
    }
    return Container(
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.kGrey),
      ),
      child: FutureBuilder<QuerySnapshot>(
        future: AttendanceController().fetchAllAttendanceRecord(subjectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<AttendanceModel> snap = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return AttendanceModel.fromMap(data);
            }).toList();

            return DropdownButton<String>(
              dropdownColor: AppColor.kWhite,
              focusColor: AppColor.kSecondary54Color,
              items: snap.map((AttendanceModel model) {
                return DropdownMenuItem<String>(
                  value: model.attendanceId,
                  child: Text(formatDate(model.selectedDate)),
                );
              }).toList(),

              onChanged: onChanged,
              value: value,
              hint: Text('Select a Date',
                  style: TextStyle(color: AppColor.kBlack)),
              isExpanded: true,
              style: TextStyle(
                  color: AppColor.kPrimaryColor, fontWeight: FontWeight.w700),
            );
          } else {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  color: AppColor.kAlertColor,
                ),
                SizedBox(width: 7),
                Text(
                  'No Attendance Available',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColor.kAlertColor),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
