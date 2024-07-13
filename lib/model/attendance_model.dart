
class AttendanceModel {
  final String classId;
  String? attendanceId;
  final DateTime selectedDate;
  final DateTime createdAtDate;
  final String currentTime;
  final Map<dynamic, dynamic> attendanceList;

  AttendanceModel({
    required this.classId,
    this.attendanceId,
    required this.createdAtDate,
    required this.selectedDate,
    required this.currentTime,
    required this.attendanceList,
  });

  AttendanceModel.fromMap(Map<String, dynamic> res)
      : classId = res['classId'],
        attendanceId = res['attendanceId'],
        selectedDate = res['selectedDate'].toDate(),
        createdAtDate = res['createdAtDate'].toDate(),
        currentTime = res['currentTime'],
        attendanceList = Map<String, String>.from(res['attendanceList']);

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'attendanceId': attendanceId,
      'selectedDate': selectedDate,
      'createdAtDate': createdAtDate,
      'currentTime': currentTime,
      'attendanceList': attendanceList,
    };
  }
}


