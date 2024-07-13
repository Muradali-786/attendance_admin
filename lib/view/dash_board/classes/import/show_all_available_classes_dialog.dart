
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../constant/app_style/app_colors.dart';
import '../../../../model/class_model.dart';
import '../../../../view_model/class_input/class_controller.dart';
import 'import_student_from_classes_dialog.dart';

Future<void> showAllAvailableClassesDialog(BuildContext context,currentClassId) async {
  final ClassController classController = ClassController();

  double h=MediaQuery.of(context).size.height;
  double  w=MediaQuery.of(context).size.width;
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: SizedBox(
          width: 320,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    FutureBuilder<QuerySnapshot>(
                      future: classController.getAllClassesData(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: AppColor.kSecondaryColor,
                          ));
                        }else {
                          List<ClassInputModel> snap =
                              snapshot.data!.docs.map((doc) {
                            Map<String, dynamic> data =
                                doc.data() as Map<String, dynamic>;
                            return ClassInputModel.fromMap(data);
                          }).toList();
            
                          return ListView.builder(
                            itemCount: snap.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              // this will not show  the current register class
            
                              if(snap[index].subjectId!=currentClassId){
                                return GestureDetector(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    await importStudentFromClassesDialog(
                                        context, snap[index],currentClassId);
                                  },
            
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${snap[index].subjectName}(${snap[index].departmentName}-${snap[index].batchName})",
                                            style: const TextStyle(fontSize: 20),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),),
                                );
                              }else{
                                return const SizedBox();
                              }
            
                            },
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
