import 'package:attendance_admin/constant/app_style/app_colors.dart';
import 'package:attendance_admin/view/dash_board/dashboard_component/dummy_chart.dart';
import 'package:attendance_admin/view_model/dash_board/dash_board_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'chart.dart';

class GraphChart extends StatefulWidget {
  const GraphChart({super.key});

  @override
  State<GraphChart> createState() => _GraphChartState();
}

class _GraphChartState extends State<GraphChart> {
  final DashBoardController _boardController = DashBoardController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder<DocumentSnapshot>(
        stream: _boardController.getDepartmentStats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return DummyChart();
          } else if (snapshot.hasError) {
            return DummyChart();
          } else if (snapshot.hasData && snapshot.data!.exists) {
            dynamic data = snapshot.data!.data();
            return GraphChartsStatistic(
              data: data,
            );
          } else {
            return DummyChart();
          }
        },
      ),
    );
  }
}

class GraphChartsStatistic extends StatelessWidget {
  dynamic data;
  GraphChartsStatistic({Key? key, this.data = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.kSubmarine,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Student Attendance Overview",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Chart(
            totalStudents: int.parse(data['totalStudent']),
            presentStudents: int.parse(data['presentStudents']),
            absentStudents: int.parse(data['absentStudents']),
            leaveStudents: int.parse(data['leavesStudents']),
            percentage: int.parse(data['percentage']),
          ),
          StudentInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Total Presents",
            kcolor: Color(0xFF007EE5),
            stdStates: data['presentStudents'].toString(),
            outOftotal: data['totalStudent'].toString(),
          ),
          StudentInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Total Leaves",
            kcolor: Color(0xFF26E5FF),
            stdStates: data['leavesStudents'].toString(),
            outOftotal: data['totalStudent'].toString(),
          ),
          StudentInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Total Absent",
            kcolor: Colors.red,
            stdStates: data['absentStudents'].toString(),
            outOftotal: data['totalStudent'].toString(),
          ),
          StudentInfoCard(
            svgSrc: "assets/icons/drop_box.svg",
            title: "Summary",
            kcolor: AppColor.kPrimaryColor,
            stdStates: "${data['percentage'].toString()}%",
            outOftotal: data['totalStudent'].toString(),
          ),
        ],
      ),
    );
  }
}

class StudentInfoCard extends StatelessWidget {
  const StudentInfoCard(
      {Key? key,
      required this.title,
      required this.svgSrc,
      required this.stdStates,
      required this.outOftotal,
      required this.kcolor})
      : super(key: key);

  final String title, svgSrc, stdStates;
  final String outOftotal;
  final Color kcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColor.kPrimaryColor),
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: SvgPicture.asset(
              svgSrc,
              colorFilter: ColorFilter.mode(kcolor, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Out of $outOftotal Students",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Text(
            stdStates,
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
