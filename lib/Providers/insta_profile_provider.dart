import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:instsinfu/Models/profile_model.dart';
import 'package:http/http.dart' as http;

class InstaProfileProvider with ChangeNotifier {
  List<ProfileModel> _instaUserList = [];
  int _startingRow = 1;
  bool _isLast = false;

  Future<void> fetchData() async {
    final url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbzrYBl5982gjLUgwcVV12UKPsOKCUSRinySgghK7yfBz6_a1SDM/exec?id=$_startingRow");

    final response = await http.get(url);
    final _result = json.decode(response.body);

    if (response.statusCode == 200) {
      final _tempList =
          _result.toList().map((json) => ProfileModel.fromJson(json)).toList();

      _instaUserList.addAll(List<ProfileModel>.from(_tempList));

      if (_startingRow == 1) {
        // api related work to get rid of first row on first call
        _instaUserList.removeAt(0);
      }

      _isLast = _tempList.length < 9;

      _startingRow = _instaUserList[_instaUserList.length - 1].currentNo;
      print(_startingRow);

      notifyListeners();
    } else {
      throw Exception('Failed to load album');
    }
  }

  bool get islast {
    return _isLast;
  }

  List<ProfileModel> get instaUserList {
    return [..._instaUserList];
  }
}
