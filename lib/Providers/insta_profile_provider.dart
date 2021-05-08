import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:instsinfu/Models/profile_model.dart';
import 'package:http/http.dart' as http;

class InstaProfileProvider with ChangeNotifier {
  int startingRow = 1;
  List<ProfileModel> _instaUserList = [];

  bool _isLast = false;
  // String _mainSheetDataUrl =
  //     "https://script.google.com/macros/s/AKfycbwZFw2For7VfT45xpJ1EhzGuJ3K36PWY6cjL0-WNWOseErqJdi4s_nYGeEQI5luetYP/exec";
  String _mainSheetDataUrl =
      "https://script.google.com/macros/s/AKfycbzrYBl5982gjLUgwcVV12UKPsOKCUSRinySgghK7yfBz6_a1SDM/exec";

  Future<void> fetchMainSheetData({int currentRowNo}) async {
    if (startingRow == 1) {
      startingRow = currentRowNo;
    }
    try {
      final url = Uri.parse("$_mainSheetDataUrl?id=$startingRow");

      final response = await http.get(url);
      final _result = await json.decode(response.body);
      if (response.statusCode == 200) {
        final _tempList =
            _result.map((json) => ProfileModel.fromJson(json)).toList();

        _instaUserList.addAll(List<ProfileModel>.from(_tempList));

        _isLast = _tempList.length < 19;

        startingRow = _instaUserList[_instaUserList.length - 1].currentNo;

        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  void clearList() {
    _instaUserList.clear();
    startingRow = 1;
  }

  bool get islast {
    return _isLast;
  }

  List<ProfileModel> get instaUserList {
    return [..._instaUserList];
  }
}
