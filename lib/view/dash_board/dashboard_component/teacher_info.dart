import 'package:attendance_admin/constant/app_style/app_colors.dart';
import 'package:attendance_admin/constant/app_style/app_styles.dart';
import 'package:attendance_admin/model/sign_up_model.dart';
import 'package:attendance_admin/model/teacher_info_dummy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TeacherInformation extends StatefulWidget {
  const TeacherInformation({Key? key}) : super(key: key);

  @override
  State<TeacherInformation> createState() => _TeacherInformationState();
}

class _TeacherInformationState extends State<TeacherInformation> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColor.kSubmarine,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Teachers Information",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: AppColor.kPrimaryColor),
          ),
          SizedBox(
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection(TEACHER).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  EasyLoading.show();
                  return _dataTable();
                } else if (snapshot.hasError) {
                  EasyLoading.show(
                    status: 'Something went wrong',
                  );
                  return _dataTable();
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  EasyLoading.dismiss();
                  List<SignUpModel> snap = snapshot.data!.docs
                      .map((doc) => SignUpModel.fromMap(
                          doc.data() as Map<String, dynamic>))
                      .toList();

                  return DataTable(
                    columnSpacing: 16,
                    columns: [
                      DataColumn(
                        label: Text(
                          "Name",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Email",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "C-Load",
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    rows: snap.map((model) => teacherInfoRow(model)).toList(),
                  );
                } else {
                  EasyLoading.show(
                    status: 'Something went wrong',
                  );
                  return _dataTable();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _dataTable() {
    return DataTable(
      columnSpacing: 16,
      columns: [
        DataColumn(
          label: Text(
            "Name",
            style: TextStyle(color: Colors.white),
          ),
        ),
        DataColumn(
          label: Text(
            "Email",
            style: TextStyle(color: Colors.white),
          ),
        ),
        DataColumn(
          label: Text(
            "C-Load",
            style: TextStyle(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
      rows: List.generate(
        teacherInfoDummy.length,
        (index) => TeacherInfoFake(teacherInfoDummy[index]),
      ),
    );
  }
}

DataRow TeacherInfoFake(TeacherInfoDummy e) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Text(
              e.title!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(color: AppColor.kWhite),
            ),
          ],
        ),
      ),
      DataCell(Text(
        e.email!,
        style: TextStyle(color: AppColor.kWhite),
      )),
      DataCell(Text(
        e.lastActive!,
        style: TextStyle(color: AppColor.kWhite),
      )),
    ],
  );
}

DataRow teacherInfoRow(SignUpModel model) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                model.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: AppColor.kWhite),
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(
        model.email,
        style: TextStyle(color: AppColor.kWhite),
      )),
      DataCell(

          Text(
                  "0${model.courseLoad}",
                  style: TextStyle(color: AppColor.kWhite),
                )),
    ],
  );
}
