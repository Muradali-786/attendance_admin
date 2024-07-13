import 'package:attendance_admin/constant/app_style/app_colors.dart';
import 'package:flutter/material.dart';



class DepartmentStates {
  final String? svgSrc, title, totalCount;

  final Color? color;

  DepartmentStates({
    this.svgSrc,
    this.title,

    this.totalCount,

    this.color,
  });
}

List departmentStatesList = [
  DepartmentStates(
    title: "Faculty Count",
    totalCount: '#6',
    svgSrc: "assets/icons/drop_box.svg",


    color:AppColor.kPrimaryColor,

  ),
  DepartmentStates(
    title: "Course Load",
    totalCount:'#16',
    svgSrc: "assets/icons/Documents.svg",

    color: Color(0xFF007EE5),

  ),
  DepartmentStates(
    title: "Student Count",
    totalCount: '#400',
    svgSrc: "assets/icons/one_drive.svg",

    color: Color(0xFFA4CDFF),

  ),
  DepartmentStates(
    title: "Departmental Total",
    totalCount: '#01',
    svgSrc: "assets/icons/Documents.svg",

    color: AppColor.kSecondaryColor,

  ),
];