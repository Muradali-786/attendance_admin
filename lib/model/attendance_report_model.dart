import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceReportModel {
  final String studentId;
  final String studentName;
  final String studentRollNo;
  final int percentage;
  final List<String> attendanceList;
  final List<Timestamp> dates;

  AttendanceReportModel({
    required this.studentId,
    required this.studentName,
    required this.studentRollNo,
    required this.percentage,
    required this.attendanceList,
    required this.dates,
  });

  @override
  String toString() {
    return 'Student ID: $studentId, '
        'Student Name: $studentName, '
        'Student Roll No: $studentRollNo, '
        'Percentage: $percentage, '
        'Attendance List: $attendanceList, '
        'Dates: ${dates.map((date) => date.toDate().toIso8601String()).toList()}';
  }
}
