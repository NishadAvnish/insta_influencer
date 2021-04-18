import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:instsinfu/Models/profile_model.dart';
import 'package:http/http.dart' as http;

class InstaProfileProvider with ChangeNotifier {
  int startingRow = 1;
  List<ProfileModel> _instaUserList = [];

  bool _isLast = false;

  Future<void> fetchData({int currentRowNo}) async {
    if (startingRow == 1) {
      startingRow = currentRowNo;
    }

    final url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbzrYBl5982gjLUgwcVV12UKPsOKCUSRinySgghK7yfBz6_a1SDM/exec?id=$startingRow");

    final response = await http.get(url);
    final _result = await json.decode(response.body);
    if (response.statusCode == 200) {
      final _tempList =
          _result.map((json) => ProfileModel.fromJson(json)).toList();

      _instaUserList.addAll(List<ProfileModel>.from(_tempList));
      print(_instaUserList.length);

      _isLast = _tempList.length < 19;

      startingRow = _instaUserList[_instaUserList.length - 1].currentNo;

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
