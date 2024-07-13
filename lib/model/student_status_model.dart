import 'package:cloud_firestore/cloud_firestore.dart';

class StudentStatusModel {
  String? studentId;
  final String studentName;
  final String studentRollNo;
  final String studentStatus;
  final Timestamp selectedDate;
  final String currentTime;

  StudentStatusModel({
    this.studentId,
    required this.studentName,
    required this.studentRollNo,
    required this.studentStatus,
    required this.selectedDate,
    required this.currentTime,
  });

  // Method to create a StudentModel from a map
  factory StudentStatusModel.fromMap(Map<String, dynamic> data) {
    return StudentStatusModel(
      studentId: data['studentId'],
      studentName: data['studentName'],
      studentRollNo: data['studentRollNo'],
      studentStatus: data['studentStatus'],
      selectedDate: (data['selectedDate'] as Timestamp),
      currentTime: data['currentTime'],
    );
  }

  // Method to convert a StudentModel to a map
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentRollNo': studentRollNo,
      'studentStatus': studentStatus,
      'selectedDate': selectedDate,
      'currentTime': currentTime,
    };
  }
}