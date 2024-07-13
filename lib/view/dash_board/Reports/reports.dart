import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constant/app_style/app_colors.dart';
import '../../../view_model/class_input/class_controller.dart';
import 'components/attendacnce_report.dart';
import 'components/student_report.dart';

class Reports extends StatefulWidget {
  static const String id = '\Reports';
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  int index = 0;
  String formatDate(DateTime dateTime) {
    final formatter = DateFormat('yMMMMd');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Reports',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.kPrimaryColor,
                  ),
                ),
              ),
              ReportDropdown(),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportDropdown extends StatefulWidget {
  @override
  _ReportDropdownState createState() => _ReportDropdownState();
}

class _ReportDropdownState extends State<ReportDropdown> {
  String? _selectedReport='Attendance Report';
  List<String> _reports = ["Attendance Report", "Student Report"];
  
  String? onTeacherSelect;
  String? onSubjectSelect;

  String roll = '20';

  int index = 0;
  String formatDate(DateTime dateTime) {
    final formatter = DateFormat('yMMMMd');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DropdownButton<String>(
          hint: Text("Select Report",style: TextStyle(color: AppColor.kPrimaryTextColor),),
          value: _selectedReport,
          dropdownColor: AppColor.kSubmarine,


          onChanged: (newValue) {
            setState(() {
              _selectedReport = newValue;
            });
          },
          items: _reports.map((report) {
            return DropdownMenuItem(
              child: Text(report,style:TextStyle(color: AppColor.kPrimaryColor)),
              value: report,
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        if (_selectedReport == "Attendance Report") ...[
          const AttendanceReport(),
        ] else if (_selectedReport == "Student Report") ...[
          const StudentReport(),
        ],
      ],
    );
  }



}

