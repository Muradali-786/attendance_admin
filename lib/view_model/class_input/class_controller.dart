import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../constant/app_style/app_styles.dart';
import '../../model/class_model.dart';
import '../../utils/utils.dart';

class ClassController with ChangeNotifier {
  final fireStore = FirebaseFirestore.instance;

  bool _loading = false;
  get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> createNewClass(ClassInputModel classInputModel) async {
    setLoading(true);
    try {
      String docId = fireStore.collection(CLASS).doc().id;
      classInputModel.subjectId = docId;

      await fireStore
          .collection(CLASS)
          .doc(docId)
          .set(classInputModel.toMap())
          .then(
        (value) {
          setLoading(false);
          updateCreditAndSubjectCount(classInputModel.teacherId.toString());
        },
      );

      setLoading(false);

      Utils.toastMessage('Class created successfully');
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error creating class');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateClassData(ClassInputModel classInputModel) async {
    setLoading(true);
    try {
      await fireStore
          .collection(CLASS)
          .doc(classInputModel.subjectId)
          .update(classInputModel.toMap());
      setLoading(false);

      Utils.toastMessage('Class Updated');
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error While Updating updating class data');
    }
  }

  Stream<QuerySnapshot> streamAllClassesData() {
    return fireStore.collection(CLASS).snapshots();
  }

  Stream<QuerySnapshot> streamClassesDataByTeacherId(String teacherID) {
    return fireStore
        .collection(CLASS)
        .where('teacherId', isEqualTo: teacherID)
        .snapshots();
  }

  Future<QuerySnapshot> getAllClassesData() {
    return fireStore.collection(CLASS).get();
  }

  Future<QuerySnapshot> getSingleClassesData(String subjectId) {
    return fireStore
        .collection(CLASS)
        .where('subjectId', isEqualTo: subjectId)
        .get();
  }

  Future<QuerySnapshot> getClassesDataByTeacherId(String? teacherId) {
    return fireStore
        .collection(CLASS)
        .where('teacherId', isEqualTo: teacherId)
        .get();
  }

  Future<List<int>> getCreditAndSubjectCount(String teacherId) async {
    int creditHour = 0;
    int courseLoad = 0;
    final subjectsCollection = fireStore.collection(CLASS);

    final querySnapshot =
        await subjectsCollection.where("teacherId", isEqualTo: teacherId).get();

    if (querySnapshot.docs.isNotEmpty) {
      final subjectList = querySnapshot.docs
          .map((doc) => ClassInputModel.fromMap(doc.data()))
          .toList();

      courseLoad = subjectList.length;

      subjectList.forEach((doc) {
        int c = int.parse(doc.creditHour);
        creditHour += c;
      });
    }

    return [creditHour, courseLoad];
  }

  Future<void> updateCreditAndSubjectCount(String teacherId) async {
    try {
      final List<int> counts = await getCreditAndSubjectCount(teacherId);
      final int creditCount = counts[0];
      final int courseLoad = counts[1];

      await fireStore.collection(TEACHER).doc(teacherId).update({
        'totalCreditHour': creditCount.toString(),
        'courseLoad': courseLoad.toString()
      });
      print('success');
    } catch (e) {
      print('Error while updating credit hour Count');
    }
  }

  // Future<void> deleteClass(String classId,String teacherId) async {
  //   try {
  //     await fireStore.collection(CLASS).doc(classId).delete().then((value) {
  //       updateCreditAndSubjectCount(teacherId);
  //     });
  //
  //     Utils.toastMessage('Class deleted successfully');
  //   } catch (e) {
  //     Utils.toastMessage('Error deleting class: ${e.toString()}');
  //   }
  // }
  Future<void> deleteClass(String classId, String teacherId) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    WriteBatch batch = fireStore.batch();
    EasyLoading.show(status: 'Deleting...');

    try {
      DocumentReference classDocRef = fireStore.collection(CLASS).doc(classId);

      // Fetch and delete documents from the 'Student' sub-collection
      QuerySnapshot studentSnapshot =
          await classDocRef.collection(STUDENT).get();
      if (studentSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in studentSnapshot.docs) {
          batch.delete(doc.reference);
        }
      }
      // Fetch and delete documents from the 'Attendance' sub-collection
      QuerySnapshot attendanceSnapshot =
          await classDocRef.collection(ATTENDANCE).get();
      if (attendanceSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in attendanceSnapshot.docs) {
          batch.delete(doc.reference);
        }
      }
      // Add the main document deletion to the batch
      batch.delete(classDocRef);

      // Commit the batch
      await batch.commit();

      updateCreditAndSubjectCount(teacherId);

      Utils.toastMessage('Class deleted successfully');
      EasyLoading.dismiss();
    } catch (e) {
      // Show error message
      EasyLoading.dismiss();
      EasyLoading.showError('Error deleting class',
          duration: const Duration(seconds: 2));
      Utils.toastMessage('Error deleting class: ${e.toString()}');
    }
  }
}
