import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenSelectorScreen extends StatelessWidget {
  ScreenSelectorScreen({Key key}) : super(key: key);

  int counter = 0;
  _sharedPreference(BuildContext context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    counter = _prefs.getInt('counter');
    counter == 0 || counter == null
        ? Navigator.of(context).pushReplacementNamed("/login")
        : Navigator.of(context).pushReplacementNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    _sharedPreference(context);
    return Scaffold();
  }
}
