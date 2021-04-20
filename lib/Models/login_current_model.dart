class LoginCurrentModel {
  final int currentNo;
  final bool isLogin;
  final String dateTime;

  LoginCurrentModel({this.currentNo, this.isLogin = false, this.dateTime});

  factory LoginCurrentModel.fromJson(Map<String, dynamic> json) {
    return LoginCurrentModel(
      currentNo: json["currentNo"],
      isLogin: json["isLogin"],
      dateTime: json["dateTime"],
    );
  }
}
