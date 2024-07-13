class AdminDataModel {
  final String id;
  final String totalStudent;
  final String totalClasses;
  final String totalTeacher;
  final String percentage;
  final String presentStudents;
  final String absentStudents;
  final String leavesStudents;

  AdminDataModel({
    required this.id,
    required this.totalStudent,
    required this.totalClasses,
    required this.totalTeacher,
    required this.percentage,
    required this.presentStudents,
    required this.absentStudents,
    required this.leavesStudents,
  });

  factory AdminDataModel.fromMap(Map<String, dynamic> map) {
    return AdminDataModel(
      id: map['id'] ?? '',
      totalStudent: map['totalStudent']?.toString() ?? '0',
      totalClasses: map['totalClasses']?.toString() ?? '0',
      totalTeacher: map['totalTeacher']?.toString() ?? '0',
      percentage: map['percentage']?.toString() ?? '0',
      presentStudents: map['presentStudents']?.toString() ?? '0',
      absentStudents: map['absentStudents']?.toString() ?? '0',
      leavesStudents: map['leavesStudents']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalStudent': totalStudent,
      'totalClasses': totalClasses,
      'totalTeacher': totalTeacher,
      'percentage': percentage,
      'presentStudents': presentStudents,
      'absentStudents': absentStudents,
      'leavesStudents': leavesStudents,
    };
  }
}
