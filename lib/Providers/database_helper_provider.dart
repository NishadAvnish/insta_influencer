import 'package:flutter/cupertino.dart';
import 'package:instsinfu/Models/profile_model.dart';
import 'package:instsinfu/Utils/databasehelper.dart';

class DatabaseHelperProvider with ChangeNotifier {
  List<ProfileModel> _saveddata = [];

  List<ProfileModel> get savedDatabaselist {
    return [..._saveddata];
  }

  Future<List<ProfileModel>> fetchDatabaseData({int rating}) async {
    final _tempData = await DatabaseHelper().getTrans(rating: rating);
    _saveddata = _tempData;
    notifyListeners();
  }

  Future<void> deleteFromDatabase({userId, rating}) async {
    try {
      await DatabaseHelper().delete(userId: userId, rating: rating);
      _saveddata.removeWhere((element) => element.userid == userId);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteAllFromDatabase({rating}) async {
    try {
      await DatabaseHelper().deleteAll(rating: rating);
      _saveddata = [];

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
