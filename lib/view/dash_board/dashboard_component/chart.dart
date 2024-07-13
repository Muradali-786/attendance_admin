import 'package:attendance_admin/constant/app_style/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class Chart extends StatelessWidget {
  final int totalStudents;
  final int presentStudents;
  final int absentStudents;
  final int leaveStudents;
  final int percentage;

  const Chart({
    Key? key,
    required this.totalStudents,
    required this.presentStudents,
    required this.absentStudents,
    required this.leaveStudents,
    required this.percentage
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: getPieChartSections(),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Text(
                  "$percentage%",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 0.5,
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getPieChartSections() {


    return [
      PieChartSectionData(
          color: Color(0xFF007EE5),
          value: presentStudents.toDouble(),
          radius: 28,
          showTitle: false),
      PieChartSectionData(
          color: AppColor.kPrimaryColor,
          value: percentage.toDouble(),
          radius: 24,
          showTitle: false),
      PieChartSectionData(
          color: Color(0xFF26E5FF),
          value: leaveStudents.toDouble(),
          radius: 20,
          showTitle: false),
      PieChartSectionData(
          color: Colors.red,
          value: absentStudents.toDouble(),
          radius: 16,
          showTitle: false),
    ];
  }
}