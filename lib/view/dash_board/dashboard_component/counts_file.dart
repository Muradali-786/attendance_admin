import 'package:attendance_admin/constant/app_style/app_colors.dart';
import 'package:attendance_admin/view_model/dash_board/dash_board_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../model/dep_states_model.dart';
import '../../../responsive.dart';

class CountFiles extends StatelessWidget {
  const CountFiles({super.key});

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    DashBoardController _c = DashBoardController();
    Map<String, dynamic> data1 = {
      'totalClasses': '##',
      'totalStudent': '##',
      'totalTeacher': ' ##',
      'depCount': '##',
    };

    return Column(
      children: [
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: StreamBuilder<DocumentSnapshot>(
            stream: _c.getDepartmentStats(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Responsive(
                  mobile: FileInfoCardGridView(
                    crossAxisCount: _size.width < 650 ? 2 : 4,
                    childAspectRatio: _size.width < 650 ? 1.3 : 1,
                    data: data1,
                  ),
                  tablet: FileInfoCardGridView(
                    data: data1,
                  ),
                  desktop: FileInfoCardGridView(
                    childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
                    data: data1,
                  ),
                );
              }
              else if (snapshot.hasError) {
                return Responsive(
                  mobile: FileInfoCardGridView(
                    crossAxisCount: _size.width < 650 ? 2 : 4,
                    childAspectRatio: _size.width < 650 ? 1.3 : 1,
                    data: data1,
                  ),
                  tablet: FileInfoCardGridView(
                    data: data1,
                  ),
                  desktop: FileInfoCardGridView(
                    childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
                    data: data1,
                  ),
                );
              } else if(snapshot.hasData && snapshot.data!.exists){
                dynamic data = snapshot.data!.data();

                return Responsive(
                  mobile: FileInfoCardGridView(
                    crossAxisCount: _size.width < 650 ? 2 : 4,
                    childAspectRatio: _size.width < 650 ? 1.3 : 1,
                    data: data,
                  ),
                  tablet: FileInfoCardGridView(
                    data: data,
                  ),
                  desktop: FileInfoCardGridView(
                    childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
                    data: data,
                  ),
                );
              }
              else  {
                return Responsive(
                  mobile: FileInfoCardGridView(
                    crossAxisCount: _size.width < 650 ? 2 : 4,
                    childAspectRatio: _size.width < 650 ? 1.3 : 1,
                    data: data1,
                  ),
                  tablet: FileInfoCardGridView(
                    data: data1,
                  ),
                  desktop: FileInfoCardGridView(
                    childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
                    data: data1,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  dynamic data;
  FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    this.data = '',
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: departmentStatesList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          if (index == 0) {
            String teacher = data['totalTeacher'].toString();
            return FileInfoCard(
              info: departmentStatesList[index],
              data: teacher,
            );
          } else if (index == 1) {
            String totalClasses = data['totalClasses'].toString();
            return FileInfoCard(
              info: departmentStatesList[index],
              data: totalClasses,
            );
          } else if (index == 2) {
            String std = data['totalStudent'].toString();
            return FileInfoCard(
              info: departmentStatesList[index],
              data: std,
            );
          } else {
            String dep = data['depCount'].toString();
            return FileInfoCard(
              info: departmentStatesList[index],
              data: dep,
            );
          }
        });
  }
}

class FileInfoCard extends StatelessWidget {
  dynamic data;
  FileInfoCard({
    Key? key,
    this.data = '',
    required this.info,
  }) : super(key: key);

  final DepartmentStates info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.kSubmarine,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(16 * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: info.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SvgPicture.asset(
                  info.svgSrc!,
                  colorFilter: ColorFilter.mode(
                      info.color ?? Colors.black, BlendMode.srcIn),
                ),
              ),
              Icon(Icons.more_vert, color: Colors.white)
            ],
          ),
          Text(
            info.title!.toString(),
            maxLines: 1,
            style: TextStyle(color: AppColor.kWhite),
            overflow: TextOverflow.ellipsis,
          ),
          ProgressLine(
            color: info.color,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "#$data",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = AppColor.kPrimaryColor,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (100 / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
