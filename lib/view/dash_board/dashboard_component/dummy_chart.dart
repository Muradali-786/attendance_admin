
import 'package:attendance_admin/constant/app_style/app_colors.dart';

import 'package:flutter/material.dart';


import 'package:flutter_svg/svg.dart';

import 'chart.dart';

class DummyChart extends StatelessWidget {
  dynamic data;
  DummyChart ({Key? key, this.data = ''}) : super(key: key);

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
            totalStudents: 100,
            presentStudents: 100,
            absentStudents: 100,
            leaveStudents: 100,
            percentage:100,
          ),
          StudentInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Total Presents",
            stdStates: '##',
            outOftotal: '##',
          ),
          StudentInfoCard(
            svgSrc: "assets/icons/excel_file.svg",
            title: "Total Leaves",
            stdStates: '##',
            outOftotal: '##',
          ),
          StudentInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Total Absent",
            stdStates: '##',
            outOftotal: '##',
          ),
          StudentInfoCard(
            svgSrc: "assets/icons/drop_box.svg",
            title: "Summary",
            stdStates: '##',
            outOftotal: '##',
          ),
        ],
      ),
    );
  }
}

class StudentInfoCard extends StatelessWidget {
  const StudentInfoCard({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.stdStates,
    required this.outOftotal,
  }) : super(key: key);

  final String title, svgSrc, stdStates;
  final String outOftotal;

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
            child: SvgPicture.asset(svgSrc),
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
                    "Out of ## Students",
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



