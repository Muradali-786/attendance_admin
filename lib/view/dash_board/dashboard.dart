import 'package:attendance_admin/constant/app_style/app_colors.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../responsive.dart';
import '../../view_model/dash_board/dash_board_controller.dart';
import 'dashboard_component/counts_file.dart';
import 'dashboard_component/graph_charts_statistic.dart';

class DashboardScreen extends StatefulWidget {
  static const String id = '\dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // DashBoardController().storeDepartmentStatsInAdmin();
  }

  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text('Dashboard',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColor.kPrimaryColor)),
            ),

            // SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      CountFiles(),
                      SizedBox(height: 16),
                      LineChartCard(),
                      SizedBox(height: 16),
                      // TeacherInformation(),
                      if (Responsive.isMobile(context)) SizedBox(height: 16),
                      if (Responsive.isMobile(context)) GraphChart(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context)) SizedBox(width: 16),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: GraphChart(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const CustomCard({super.key, this.color, this.padding, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: color ?? AppColor.kSubmarine,
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12.0),
          child: child,
        ));
  }
}

class LineChartCard extends StatelessWidget {
  const LineChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final data = LineData();

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Attendance Overview",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.kTextWhiteColor),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 16 / 6,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                ),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 3,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return data.bottomTitle[value.toInt()] != null
                            ? SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                    data.bottomTitle[value.toInt()].toString(),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                              )
                            : const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return data.leftTitle[value.toInt()] != null
                            ? Text(data.leftTitle[value.toInt()].toString(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white))
                            : const SizedBox();
                      },
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    color: AppColor.kGrey,
                    barWidth: 2.5,
                    belowBarData: BarAreaData(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColor.kPrimaryColor, Colors.transparent],
                      ),
                      show: true,
                    ),
                    dotData: FlDotData(show: false),
                    spots: data.spots,
                  )
                ],
                minX: 0,
                maxX: 31,
                maxY: 105,
                minY: -5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LineData {
  List<FlSpot> spots = [
    FlSpot(1, 75),
    FlSpot(2, 88),
    FlSpot(3, 62),
    FlSpot(4, 91),
    FlSpot(5, 69),
    FlSpot(6, 80),
    FlSpot(7, 95),
    FlSpot(8, 78),
    FlSpot(9, 83),
    FlSpot(10, 66),
    FlSpot(11, 72),
    FlSpot(12, 85),
    FlSpot(13, 90),
    FlSpot(14, 64),
    FlSpot(15, 99),
    FlSpot(16, 74),
    FlSpot(17, 81),
    FlSpot(18, 87),
    FlSpot(19, 68),
    FlSpot(20, 79),
    FlSpot(21, 92),
    FlSpot(22, 70),
    FlSpot(23, 82),
    FlSpot(24, 98),
    FlSpot(25, 67),
    FlSpot(26, 77),
    FlSpot(27, 84),
    FlSpot(28, 63),
    FlSpot(29, 96),
    FlSpot(30, 71),
    FlSpot(31, 89),
  ];
  Map<int, String> bottomTitle = {};
  Map<int, String> leftTitle = {};

  LineData() {
    // Mock data for demonstration
    for (int i = 0; i <= 31; i++) {
      bottomTitle[i] = i.toString();
    }

    for (int i = 0; i <= 100; i += 20) {
      leftTitle[i] = '$i%';
    }
  }
}
