import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../model/attendance_model.dart';
import '../../../model/student_model.dart';
import '../../../utils/utils.dart';
import '../../add_students/students_controller.dart';
import '../../attendance/attendance_controller.dart';
import 'dart:html' as html;

class MediaServices with ChangeNotifier {
  final StudentController _studentController = StudentController();
  final AttendanceController _attendanceController = AttendanceController();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<dynamic> pickExcelSheetFromLibrary() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['xls', 'xlsx']);

    if (pickedFile != null) {
      if (kIsWeb) {
        return pickedFile.files.first.bytes;
      }
      return pickedFile.files[0];
    }
    return null;
  }

  Future<List<List<dynamic>>> getStudentDataFromExcel() async {
    List<dynamic> stdNameList = [];
    List<dynamic> stdRollNoList = [];

    var path = await pickExcelSheetFromLibrary();
    if (path != null) {
      if (kIsWeb) {
        var excel = Excel.decodeBytes(path);

        for (var table in excel.tables.keys) {
          for (var row in excel[table].rows.skip(1)) {
            if (row.isEmpty || row.first == null || row[1] == null) {
              // this condition is to check wether a row is not null or one of value in row is not missing
              continue;
            }

            stdRollNoList.add(row.first!.value.toString());
            stdNameList.add(row[1]!.value.toString());
          }
        }
      } else {
        Uint8List bytes = File(path.path.toString()).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        for (var table in excel.tables.keys) {
          for (var row in excel[table].rows.skip(1)) {
            if (row.isEmpty || row.first == null || row[1] == null) {
              // this condition is to check wether a row is not null or one of value in row is not missing
              continue;
            }

            stdRollNoList.add(row.first!.value.toString());
            stdNameList.add(row[1]!.value.toString());
          }
        }
      }
    }
    return [stdNameList, stdRollNoList];
  }

  Future<List<dynamic>> getStudentDetails(String classId) async {
    dynamic studentSnapshot =
        await _studentController.getStudentDataToExport(classId);
    final studentList = studentSnapshot.docs
        .map((doc) => StudentModel.fromMap(doc.data()))
        .toList();
    return studentList;
  }

  Future<List<dynamic>> getAttendanceDetails(String classId) async {
    dynamic attendanceSnapshot =
        await _attendanceController.getAllStudentAttendanceToExport(classId);

    final attendanceList = attendanceSnapshot.docs
        .map((doc) => AttendanceModel.fromMap(doc.data()))
        .toList();
    return attendanceList;
  }

  void addSheetHeader(Sheet sheet, attendanceList) {
    List<CellValue> headerList = [];
    CellStyle headerStyle = CellStyle(
      // backgroundColorHex: '#808080',
      // fontColorHex: "#FFFFFF",
      fontFamily: getFontFamily(FontFamily.Calibri),
    );
    var cell1 =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    cell1.cellStyle = headerStyle;
    cell1.value = const TextCellValue('Registration No');
    headerList.add(cell1.value!);
    var cell2 =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
    cell2.cellStyle = headerStyle;
    cell2.value = const TextCellValue('Student Name');
    headerList.add(cell2.value!);

    for (int i = 0; i < attendanceList.length; i++) {
      AttendanceModel model = attendanceList[i];
      final formatter = DateFormat('yMMMMd');
      String formattedDate = formatter.format(model.selectedDate);
      headerList.add(TextCellValue(formattedDate));

      var cell = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: i + 2, rowIndex: 0));
      cell.cellStyle = headerStyle;
      cell.value = TextCellValue(formattedDate);
    }
    if (headerList.length > attendanceList.length) {
      var totalPresentCell = sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: attendanceList.length + 3, rowIndex: 0));
      totalPresentCell.cellStyle = headerStyle;
      totalPresentCell.value = const TextCellValue('Total Absent');
      headerList.add(totalPresentCell.value!);

      var totalLeavesCell = sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: attendanceList.length + 4, rowIndex: 0));
      totalLeavesCell.cellStyle = headerStyle;
      totalLeavesCell.value = const TextCellValue('Total Leaves');
      headerList.add(totalLeavesCell.value!);

      var totalAbsentCell = sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: attendanceList.length + 5, rowIndex: 0));
      totalAbsentCell.cellStyle = headerStyle;
      totalAbsentCell.value = const TextCellValue('Total Present');
      headerList.add(totalAbsentCell.value!);

      var totalPercentageCell = sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: attendanceList.length + 7, rowIndex: 0));
      totalPercentageCell.cellStyle = headerStyle;
      totalPercentageCell.value = const TextCellValue('Percentage');
      headerList.add(totalPercentageCell.value!);
    }
  }

  void addStudentAttendanceDetailsToSheet(
      Sheet sheet, studentList, attendanceList) {
    for (int i = 0; i < studentList.length; i++) {
      StudentModel std = studentList[i];
      // Set student roll number and name
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
          .value = TextCellValue(std.studentRollNo);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
          .value = TextCellValue(std.studentName);

      // Set attendance status for each student
      for (int j = 0; j < attendanceList.length; j++) {
        AttendanceModel model = attendanceList[j];
        if (model.attendanceList.containsKey(std.studentId)) {
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: j + 2, rowIndex: i + 1))
              .value = TextCellValue(model.attendanceList[std.studentId]);
        } else {
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: j + 2, rowIndex: i + 1))
              .value = const TextCellValue('--');
        }
        // write total leaves present and absent leaves,percentage
        int columnIndex = attendanceList.length + 2;
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: columnIndex + 1, rowIndex: i + 1))
            .value = TextCellValue(std.totalAbsent.toString());
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: columnIndex + 2, rowIndex: i + 1))
            .value = TextCellValue(std.totalLeaves.toString());
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: columnIndex + 3, rowIndex: i + 1))
            .value = TextCellValue(std.totalPresent.toString());
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: columnIndex + 5, rowIndex: i + 1))
            .value = TextCellValue("${std.attendancePercentage.toString()}%");
      }
    }
  }

  // Future<void> shareExcelFile(excel) async {
  //   String name = 'Student-Attendance-';
  //   final fileName = '$name${DateTime.now().millisecondsSinceEpoch}.xlsx';
  //
  //   final fileBytes = excel.save();
  //   var directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/$fileName');
  //
  //   file
  //     ..createSync(recursive: true)
  //     ..writeAsBytesSync(fileBytes!);
  //
  //   await Share.shareXFiles([XFile(file.path)], text: 'Student-attendance');
  // }

  void _downloadFile(List<int> bytes, String fileName) {
    final Uint8List file = Uint8List.fromList(bytes);

    final blob = html.Blob([file.single]);

    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> exportAndShareAttendanceSheet(String classId) async {
    setLoading(true);
    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];


      final studentList = await getStudentDetails(classId);
      final attendanceList = await getAttendanceDetails(classId);
      if (attendanceList.isNotEmpty) {
        addSheetHeader(sheet, attendanceList);
        addStudentAttendanceDetailsToSheet(sheet, studentList, attendanceList);
        if (kIsWeb) {
          String fileName='Student-Attendance-${DateTime.now().millisecondsSinceEpoch}.xlsx';
          final fileBytes = excel.save(fileName: fileName)!;

          _downloadFile(fileBytes,fileName);
        } else {
          // await shareExcelFile(excel);
        }
      } else {
        Utils.toastMessage('No attendance records to export');
      }
      setLoading(false);
    } catch (e) {
      Utils.toastMessage('Some thing went wrong while Exporting Sheet');
      setLoading(false);
    } finally {
      setLoading(false);
    }
  }
}
