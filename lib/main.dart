import 'dart:io';
import 'package:attendance_admin/constant/app_style/app_colors.dart';
import 'package:attendance_admin/text_theme.dart';
import 'package:attendance_admin/view/side_menu/side_menu.dart';
import 'package:attendance_admin/view_model/add_students/students_controller.dart';
import 'package:attendance_admin/view_model/attendance/attendance_controller.dart';
import 'package:attendance_admin/view_model/class_input/class_controller.dart';
import 'package:attendance_admin/view_model/services/media/media_services.dart';
import 'package:attendance_admin/view_model/teacher/teacher_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? const FirebaseOptions(
              apiKey: "AIzaSyCGFzozTh1w79r1R2WJB79fg1f82ZJ-zOA",
              appId: "1:868175613153:android:6992370f24caf82278fba0",
              messagingSenderId: "868175613153",
              projectId: "attendance-manager-4e159",
            )
          : null);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TeacherController>(
          create: (_) => TeacherController(),
        ),
        ChangeNotifierProvider<ClassController>(
          create: (_) => ClassController(),
        ),
        ChangeNotifierProvider<AttendanceController>(
          create: (_) => AttendanceController(),
        ),
        ChangeNotifierProvider<StudentController>(
          create: (_) => StudentController(),
        ),
        ChangeNotifierProvider<MediaServices>(
          create: (_) => MediaServices(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CS Admin Panel',
        theme: ThemeData(
          textTheme: textTheme,
          canvasColor: AppColor.kBlueColor,
        ),
        home: const SideMenu(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
