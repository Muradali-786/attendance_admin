class SignUpModel {
  String? teacherId;
  final String name;
  final String email;
  final String password;
  final bool status;
  final bool control;
  final String courseLoad;
  final String totalCreditHour;

  SignUpModel({
    this.teacherId,
    required this.name,
    required this.email,
    required this.password,

    this.status=false,
    this.control=false,
    this.courseLoad = '0',
    this.totalCreditHour = '0',
  });

  SignUpModel.fromMap(Map<String, dynamic> res)
      : teacherId = res['teacherId'],
        name = res['name'],
        email = res['email'],
        password = res['password'],
        status=res['status'],
        control=res['control'],
        courseLoad = res['courseLoad'],
        totalCreditHour = res['totalCreditHour'];

  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'name': name,
      'email': email,
      'password':password,
      'status':status,
      'control':control,
      'courseLoad': courseLoad,
      'totalCreditHour': totalCreditHour,
    };
  }
}
