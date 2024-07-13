class OneStudentInfoModel {
  final String subjectName;
  final String classId;
  final String studentId;
  final String studentName;
  final String studentRollNo;
  final int totalClasses;
  int attendancePercentage;
  int totalPresent;
  int totalAbsent;
  int totalLeaves;

  OneStudentInfoModel({
    required this.subjectName,
    required this.classId,
    required this.studentId,
    required this.studentName,
    required this.studentRollNo,
    required this.totalClasses,
    required this.attendancePercentage,
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalLeaves,
  });

  @override
  String toString() {
    return 'Subject Name: $subjectName, '
        'Class ID: $classId, '
        'Student ID: $studentId, '
        'Student Name: $studentName, '
        'Student Roll No: $studentRollNo, '
        'Total Classes: $totalClasses, '
        'Attendance Percentage: $attendancePercentage, '
        'Total Present: $totalPresent, '
        'Total Absent: $totalAbsent, '
        'Total Leaves: $totalLeaves';
  }
}
