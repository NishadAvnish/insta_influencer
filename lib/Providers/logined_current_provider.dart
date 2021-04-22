import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:instsinfu/Models/login_current_model.dart';
import 'package:instsinfu/Providers/notifier_provider.dart';

class LoginCurrentNoProvider with ChangeNotifier {
  int _count = 0;
  LoginCurrentModel _currentLoginInfo;

  int _currentRowNo = 1;

  int get currentRowNo {
    return _currentRowNo;
  }

  int get count {
    return _count;
  }

  LoginCurrentModel get currentLoginInfo {
    return _currentLoginInfo;
  }

  Future<bool> fetchLoginData() async {
    final url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbzx4BK_VgUPqLrZ0Ki87HOvtL9_yRQIOab0iJokvf02OqHbLb5OyZNdebDoVDNHql-m/exec");

    final response = await http.get(url);
    final _result = json.decode(response.body);

    if (response.statusCode == 200) {
      _currentLoginInfo = LoginCurrentModel(
          currentNo:
              _result[0]["currentNo"] == "" ? 1 : _result[0]["currentNo"],
          isLogin: _result[0]["isLogin"],
          dateTime: _result[0]["dateTime"]);
      _currentRowNo =
          _result[0]["currentNo"] == "" ? 1 : _result[0]["currentNo"];
      _count = 1;

      notifyListeners();
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<void> changeCurrentStatus({bool isLogin}) {
    // isLogin = false logout button clicked
    var _current;
    if (isLogin) {
      _current = _currentLoginInfo.currentNo + currentIndexValue.value + 1;
    } else {
      _current = _currentLoginInfo.currentNo + currentIndexValue.value;
    }
    var _url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbxsT4sNRUAN_UjFzuN-WlbJSiUpWOxyPF7FvvmYChxq18nUducNjMKALb4G7vx4v9Vcng/exec?current=${_current}&islogin=${isLogin}&datetime=${DateTime.now()}");

    http.get(_url).then((value) {
      if (!isLogin) {
        cron.close();
        _currentLoginInfo = LoginCurrentModel(
            currentNo: _currentLoginInfo.currentNo,
            isLogin: false,
            dateTime: _currentLoginInfo.dateTime);
      }

      notifyListeners();
    }).catchError((e) {
      return "Something went wrong!";
    });
  }

  Future<void> login() {
    var _url;
    _url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbxsT4sNRUAN_UjFzuN-WlbJSiUpWOxyPF7FvvmYChxq18nUducNjMKALb4G7vx4v9Vcng/exec?current=${currentLoginInfo.currentNo + currentIndexValue.value}&islogin=${true}&datetime=${DateTime.now()}");

    http.get(_url).then((value) {
      _currentLoginInfo = LoginCurrentModel(
          currentNo: _currentLoginInfo.currentNo,
          isLogin: true,
          dateTime: _currentLoginInfo.dateTime);

      notifyListeners();
    }).catchError((e) {
      return "Something went wrong!";
    });
  }
}
