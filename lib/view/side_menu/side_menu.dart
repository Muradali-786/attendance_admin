import 'package:attendance_admin/constant/app_style/app_colors.dart';
import 'package:attendance_admin/view/dash_board/Reports/reports.dart';
import 'package:attendance_admin/view/dash_board/attendance/attendance.dart';
import 'package:attendance_admin/view/dash_board/classes/classes.dart';
import 'package:attendance_admin/view/dash_board/setting/setting.dart';
import 'package:attendance_admin/view/dash_board/students/student.dart';
import 'package:attendance_admin/view/dash_board/teachers/teachers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../dash_board/dashboard.dart';

class SideMenu extends StatefulWidget {
  static const String id = '\sideMenu';

  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Widget _selectedScreen = DashboardScreen();

  screenSelector(item) {
    switch (item.route) {

      case TeachersScreen.id:
        setState(() {
          _selectedScreen = TeachersScreen();
        });

        break;
      case StudentScreen.id:
        setState(() {
          _selectedScreen = StudentScreen();
        });

        break;
      case ClassesScreen.id:
        setState(() {
          _selectedScreen = ClassesScreen();
        });

        break;
      case DashboardScreen.id:
        setState(() {
          _selectedScreen = DashboardScreen();
        });

        break;

      case Reports.id:
        setState(() {
          _selectedScreen = Reports();
        });

        break;
      case AttendanceScreen.id:
        setState(() {
          _selectedScreen = AttendanceScreen();
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: AppColor.kBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.kPrimaryColor,
        iconTheme: IconThemeData(
          color: AppColor.kWhite
        ),

        title: const Text(
          'Attendance Manager Admin Control Panel',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      sideBar: SideBar(
         iconColor: AppColor.kPrimaryColor,
        textStyle: TextStyle(color: AppColor.kPrimaryColor),
        activeTextStyle:TextStyle(color: AppColor.kPrimaryColor),

        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            icon: Icons.dashboard_outlined,
            route: DashboardScreen.id,
          ),
          AdminMenuItem(
            title: 'Teachers',
            icon: Icons.person,
            route: TeachersScreen.id,
          ),

          AdminMenuItem(
            title: 'Classes',
            icon: Icons.class_outlined,
            route: ClassesScreen.id,
          ),


          AdminMenuItem(
            title: 'Students',
            icon: Icons.perm_contact_calendar_outlined,
            route: StudentScreen.id,
          ),

          AdminMenuItem(
            title: 'Attendance',
            icon: Icons.perm_contact_calendar_outlined,
            route: AttendanceScreen.id,
          ),

          AdminMenuItem(
            title: 'Reports',
            icon: Icons.manage_accounts,
            route: Reports.id,
          ),

        ],
        selectedRoute: DashboardScreen.id,
        onSelected: (item) {
          screenSelector(item);


        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: AppColor.kSecondary54Color,
          child: const Center(
            child: Text(
              'Attendance Manager',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: AppColor.kSecondaryColor,
          child: const Center(
            child: Text(
              'CS Attendance Management',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _selectedScreen,
    );
  }
}