import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../../constant/app_style/app_styles.dart';
import '../../model/attendance_model.dart';
import '../../model/single_std_info_model.dart';
import '../../model/student_model.dart';
import '../../utils/utils.dart';
import '../attendance/attendance_controller.dart';

class StudentController with ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final AttendanceController _attendanceController = AttendanceController();

  bool _loading = false;
  get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<dynamic>> getAttendanceDetailsToCalculate(String classId) async {
    dynamic attendanceSnapshot =
        await _attendanceController.getAllStudentAttendanceToExport(classId);

    final attendanceList = attendanceSnapshot.docs
        .map((doc) => AttendanceModel.fromMap(doc.data()))
        .toList();
    return attendanceList;
  }

  Future<void> calculateStudentAttendance(
    String classId,
    List<dynamic> stdIdList,
  ) async {
    WriteBatch batch = _fireStore.batch();

    try {
      final attendanceList = await getAttendanceDetailsToCalculate(classId);

      if (attendanceList.isEmpty) {
        for (int i = 0; i < stdIdList.length; i++) {
          int totalPresent = 0;
          int totalAbsent = 0;
          int totalLeaves = 0;
          int percentage = 0;

          DocumentReference stdDocRef = _fireStore
              .collection(CLASS)
              .doc(classId)
              .collection(STUDENT)
              .doc(stdIdList[i]);

          batch.update(stdDocRef, {
            'totalAbsent': totalAbsent,
            'totalLeaves': totalLeaves,
            'totalPresent': totalPresent,
            'attendancePercentage': percentage,
          });
        }
      } else {
        for (int i = 0; i < stdIdList.length; i++) {
          int totalPresent = 0;
          int totalAbsent = 0;
          int totalLeaves = 0;
          for (var attendance in attendanceList) {
            AttendanceModel e = attendance;
            if (e.attendanceList.containsKey(stdIdList[i])) {
              if (e.attendanceList[stdIdList[i]] == 'P') {
                totalPresent += 1;
              } else if (e.attendanceList[stdIdList[i]] == 'L') {
                totalLeaves += 1;
              } else {
                totalAbsent += 1;
              }
            } else {
              continue;
            }
          }
          int total = totalLeaves + totalPresent + totalAbsent;
          int stdAttend = totalLeaves + totalPresent;
          int percentage = ((stdAttend / total) * 100).toInt();

          DocumentReference stdDocRef = _fireStore
              .collection(CLASS)
              .doc(classId)
              .collection(STUDENT)
              .doc(stdIdList[i]);

          batch.update(stdDocRef, {
            'totalAbsent': totalAbsent,
            'totalLeaves': totalLeaves,
            'totalPresent': totalPresent,
            'attendancePercentage': percentage,
          });
        }
      }

      await batch.commit();
    } catch (e) {
      Utils.toastMessage('Student Details Update');
    }
  }

  Future<void> migrateStudentsToClass(
      String referenceClassId, String currentClassId) async {
    setLoading(true);
    try {
      // Retrieve student data from the original class
      List<StudentModel> currentClassStudents =
          await getAllStudentsFromClass(referenceClassId);

      // Create a batch to efficiently add multiple students
      if (currentClassStudents.isNotEmpty) {
        final batch = _fireStore.batch();

        // Add each student to the new class collection
        for (final student in currentClassStudents) {
          //before adding data to firebase need to set some parameters to zero that's why
          student.attendancePercentage = student.totalLeaves =
              student.totalAbsent = student.totalPresent = 0;
          batch.set(
            _fireStore
                .collection(CLASS)
                .doc(currentClassId)
                .collection(STUDENT)
                .doc(student.studentId),
            student.toMap(),
          );
        }

        // Commit the batch operation in a single write
        await batch.commit();
        setLoading(false);
        Utils.toastMessage('Students Added To Class Successfully!');
      } else {
        setLoading(false);
        Utils.toastMessage(
            'The class you are referencing has no enrolled students.');
      }
    } catch (error) {
      setLoading(false);
      Utils.toastMessage('Error Adding Students: ${error.toString()}');
    } finally {
      setLoading(false);
    }
  }

  Future<List<StudentModel>> getAllStudentsFromClass(String classId) async {
    try {
      QuerySnapshot querySnapshot = await _fireStore
          .collection(CLASS)
          .doc(classId)
          .collection(STUDENT)
          .get();

      List<StudentModel> students = [];
      for (var doc in querySnapshot.docs) {
        students.add(StudentModel.fromMap(doc.data() as Map));
      }

      return students;
    } catch (e) {
      Utils.toastMessage('Error getting Student');
      return [];
    }
  }

  Future<QuerySnapshot> getAllStudentCountOfOneClass(String classId) {
    return _fireStore.collection(CLASS).doc(classId).collection(STUDENT).get();
  }

  Future<List<OneStudentInfoModel>> getStudentsDetailsInAllSubject(
      String rollNo) async {
    List<OneStudentInfoModel> studentInfoList = [];

    QuerySnapshot classSnapshots = await _fireStore.collection(CLASS).get();

    for (QueryDocumentSnapshot classDoc in classSnapshots.docs) {
      QuerySnapshot studentSnapshots = await classDoc.reference
          .collection(STUDENT)
          .where('studentRollNo', isEqualTo: rollNo)
          .get();

      for (QueryDocumentSnapshot studentDoc in studentSnapshots.docs) {
        // Check if student data is present
        Map classData = classDoc.data() as Map;
        if (studentDoc.exists) {
          OneStudentInfoModel printModel = OneStudentInfoModel(
            subjectName: classData['subjectName'],
            classId: classDoc.id,
            studentId: studentDoc.id,
            studentName: studentDoc['studentName'],
            studentRollNo: studentDoc['studentRollNo'],
            totalClasses: classData['totalClasses'],
            attendancePercentage: studentDoc['attendancePercentage'],
            totalPresent: studentDoc['totalPresent'],
            totalAbsent: studentDoc['totalAbsent'],
            totalLeaves: studentDoc['totalLeaves'],
          );
          studentInfoList.add(printModel);
        }
      }
    }

    return studentInfoList;
  }

  Future<void> addListOfStudent(
    String classId,
    List stdRollNoList,
    List stdNamesList,
  ) async {
    setLoading(true);

    try {
      WriteBatch batch = _fireStore.batch();

      for (int i = 0; i < stdRollNoList.length; i++) {

        if (stdNamesList[i].toString().length < 3 ||
            stdRollNoList[i].toString().length < 2) {
          Utils.toastMessage(
              'Attention: Student ${stdNamesList[i]} (${stdRollNoList[i]}) is not added due to short details');

          continue;
        }
        String docId = _fireStore
            .collection(CLASS)
            .doc(classId)
            .collection(STUDENT)
            .doc()
            .id;

        batch.set(
          _fireStore
              .collection(CLASS)
              .doc(classId)
              .collection(STUDENT)
              .doc(docId),
          {
            'studentName': stdNamesList[i].toString(),
            'studentId': docId.toString(),
            'attendancePercentage': 0,
            'totalAbsent': 0,
            'totalLeaves': 0,
            'totalPresent': 0,
            'studentRollNo': stdRollNoList[i].toString()
          },
        );
      }

      await batch.commit().then((_) {
        setLoading(false);
        Utils.toastMessage('Students Added successfully');
      });
      setLoading(false);
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error during Students Added');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> doesStudentExist(String classId, String studentRollNo) async {
    final querySnapshot = await _fireStore
        .collection(CLASS)
        .doc(classId)
        .collection(STUDENT)
        .where('studentRollNo', isEqualTo: studentRollNo)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addNewStudent(StudentModel studentModel, String classId) async {
    setLoading(true);

    try {
      String docId = _fireStore
          .collection(CLASS)
          .doc(classId)
          .collection(STUDENT)
          .doc()
          .id;
      studentModel.studentId = docId;
      bool isExist =
          await doesStudentExist(classId, studentModel.studentRollNo);

      if (!isExist) {
        await _fireStore
            .collection(CLASS)
            .doc(classId)
            .collection(STUDENT)
            .doc(docId)
            .set(studentModel.toMap())
            .then((value) {
          setLoading(false);
          Utils.toastMessage('Student Added');
        });
      } else {
        setLoading(false);
        Utils.toastMessage(
            "Student with the same reg# (${studentModel.studentRollNo}) already exist");
      }

      setLoading(false);
    } catch (e) {
      Utils.toastMessage('Error during Student Added');
      setLoading(false);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateStudentData(StudentModel studentModel, classId) async {
    try {
      bool isExist =
      await doesStudentExist(classId, studentModel.studentRollNo);
      if (!isExist) {
        await _fireStore
            .collection(CLASS)
            .doc(classId)
            .collection(STUDENT)
            .doc(studentModel.studentId)
            .update({
          'studentName': studentModel.studentName,
          'studentRollNo': studentModel.studentRollNo,
        }).then((value) {
          Utils.toastMessage('Student data Updated');
        });
      } else {
        Utils.toastMessage(
            "Student with the same reg# (${studentModel.studentRollNo}) already exist");
      }

    } catch (e) {
      Utils.toastMessage('Error during Student data updation');
    }
  }

  Stream<QuerySnapshot> streamAllStudentDataByClassId(String classId) {
    return _fireStore
        .collection(CLASS)
        .doc(classId)
        .collection(STUDENT)
        .snapshots();
  }

  Future<QuerySnapshot> getAllStudentDataByClassId(String classId) {
    return _fireStore.collection(CLASS).doc(classId).collection(STUDENT).get();
  }

  Future<dynamic> getStudentDataToExport(String classId) {
    return _fireStore.collection(CLASS).doc(classId).collection(STUDENT).get();
  }

  Stream<DocumentSnapshot> getSingleStudentData(String classId, String stdId) {
    return _fireStore
        .collection(CLASS)
        .doc(classId)
        .collection(STUDENT)
        .doc(stdId)
        .snapshots();
  }

  Future<void> deleteStudent(String studentId, classId) async {
    try {
      await _fireStore
          .collection(CLASS)
          .doc(classId)
          .collection(STUDENT)
          .doc(studentId)
          .delete()
          .then((value) {
        Utils.toastMessage('Student deleted');
      });
    } catch (e) {
      Utils.toastMessage('Error during Student deletion');
    }
  }
}
