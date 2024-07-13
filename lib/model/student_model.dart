class StudentModel {
  String? studentId;
  final String studentName;
  final String studentRollNo;

  int attendancePercentage;
  int totalPresent;
  int totalAbsent;
  int totalLeaves;

  StudentModel({
    this.studentId,
    required this.studentName,
    required this.studentRollNo,
    this.attendancePercentage = 0,
    this.totalPresent = 0,
    this.totalAbsent = 0,
    this.totalLeaves = 0,
  });

  StudentModel.fromMap(Map<dynamic, dynamic> res)
      : studentId = res['studentId'],
        studentName = res['studentName'],
        studentRollNo = res['studentRollNo'],
        attendancePercentage = res['attendancePercentage'] ?? 0,
        totalPresent = res['totalPresent'] ?? 0,
        totalAbsent = res['totalAbsent'] ?? 0,
        totalLeaves = res['totalLeaves'] ?? 0;

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentRollNo': studentRollNo,
      'attendancePercentage': attendancePercentage,
      'totalPresent': totalPresent,
      'totalAbsent': totalAbsent,
      'totalLeaves': totalLeaves,
    };
  }
}



