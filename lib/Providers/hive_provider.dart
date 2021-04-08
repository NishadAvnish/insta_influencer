import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:instsinfu/Models/profile_model.dart';

class HiveProvider with ChangeNotifier {
  List<ProfileModel> _savedList = [];

  List<ProfileModel> get savedList {
    return [..._savedList];
  }

  Future<void> getSavedData() async {
    final _hiveBox = await Hive.openBox("savedData");
  }
}
