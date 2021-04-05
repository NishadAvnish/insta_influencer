import 'package:flutter/cupertino.dart';
import 'package:instsinfu/Models/profile_model.dart';

class InstaProfileProvider with ChangeNotifier {
  List<ProfileModel> _instaUserList = [];

  void fetchData() {
    notifyListeners();
  }

  List<ProfileModel> get instaUserList {
    return [..._instaUserList];
  }
}
