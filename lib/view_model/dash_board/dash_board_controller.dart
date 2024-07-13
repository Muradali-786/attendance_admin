import 'package:attendance_admin/utils/utils.dart';
import 'package:attendance_admin/view_model/add_students/students_controller.dart';
import 'package:attendance_admin/view_model/attendance/attendance_controller.dart';
import 'package:attendance_admin/view_model/class_input/class_controller.dart';
import 'package:attendance_admin/view_model/teacher/teacher_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../constant/app_style/app_styles.dart';

String formatDate(DateTime dateTime) {
  final formatter = DateFormat('yMMMMd');
  return formatter.format(dateTime);
}
DateTime currentDate = DateTime.now();

class DashBoardController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TeacherController _teacherController = TeacherController();
  final AttendanceController _attendanceController = AttendanceController();
  final StudentController _studentController = StudentController();
  final ClassController _classController = ClassController();

  Future<String> getAllTeacherLength() async {
    QuerySnapshot data = await _teacherController.getTeacherData();

    if (data.size != 0) {
      return data.size.toString();
    }
    return '0';
  }

  Future<String> getAllSubjectLength() async {
    QuerySnapshot snapshot = await _classController.getAllClassesData();
    if (snapshot.size != 0) {
      return snapshot.size.toString();
    }
    return '0';
  }

  Future<String> getAllEnrolledStudentLength() async {
    QuerySnapshot snapshot = await _classController.getAllClassesData();
    int totalStudentCount = 0;

    if (snapshot.size != 0) {
      for (QueryDocumentSnapshot classDoc in snapshot.docs) {
        String classId = classDoc.id;
        QuerySnapshot stdSnap =
            await _studentController.getAllStudentCountOfOneClass(classId);

        if (stdSnap.size != 0) {
          int classStudentCount = stdSnap.size;
          totalStudentCount += classStudentCount;
        }
      }
      return totalStudentCount.toString();
    }
    return '0';
  }

  Future<Map<String, int>> getTodayAttendanceStats() async {

    Map<String, int> attendanceStats = {
      'present': 0,
      'absent': 0,
      'leave': 0,
    };

    QuerySnapshot classSnapshot = await _classController.getAllClassesData();



    if (classSnapshot.size != 0) {

      for (QueryDocumentSnapshot classDoc in classSnapshot.docs) {
        String classId = classDoc.id;

        QuerySnapshot attendanceDoc =
            await _attendanceController.getCurrentDateAttendanceRecord(classId);

        if (attendanceDoc.docs.isNotEmpty) {
          for (dynamic record in attendanceDoc.docs) {

            Map<String, dynamic> attendanceList =
                record['attendanceList'] as Map<String, dynamic>;

            attendanceList.forEach((key, status) {
              if (status == 'P') {
                attendanceStats['present'] = attendanceStats['present']! + 1;
              } else if (status == 'A') {
                attendanceStats['absent'] = attendanceStats['absent']! + 1;
              } else if (status == 'L') {
                attendanceStats['leave'] = attendanceStats['leave']! + 1;
              }
            });
          }
        }
      }
    }

    return attendanceStats;
  }

  String today = formatDate(DateTime.now());

  Future<void> storeDepartmentStatsInAdmin() async {
    try {
      String totalClasses = await getAllSubjectLength();
      String totalStudents = await getAllEnrolledStudentLength();
      String totalTeacher = await getAllTeacherLength();
      Map<String, int> atdncStats = await getTodayAttendanceStats();

      int percentage = (int.parse(atdncStats['present'].toString()) /
              int.parse(totalStudents) *
              100)
          .toInt();

      await _firestore.collection(ADMIN).doc(today).set({
        'totalStudent': totalStudents,
        'totalClasses': totalClasses,
        'totalTeacher': totalTeacher,
        'percentage': percentage.toString(),
        'depCount': '01',
        'presentStudents': atdncStats['present'].toString(),
        'absentStudents': atdncStats['absent'].toString(),
        'leavesStudents': atdncStats['leave'].toString(),
        'currentDate': DateTime.now()
      });
      Utils.toastMessage('Data Refresh');
    } catch (e) {

      Utils.toastMessage('Error Occurs While Refreshing States');
    }
  }

  Stream<DocumentSnapshot> getDepartmentStats() {
    return _firestore.collection(ADMIN).doc(today).snapshots();
  }


  DateTime startOfDay = DateTime(currentDate.year, currentDate.month, currentDate.day);
  DateTime endOfDay = DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);

  Future<QuerySnapshot> departmentStats() {
    return _firestore
        .collection(ADMIN)
        .where('currentDate', isGreaterThanOrEqualTo: startOfDay)
        .where('currentDate', isLessThanOrEqualTo: endOfDay)
        .get();
  }
}
