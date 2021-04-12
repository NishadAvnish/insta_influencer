import 'package:flutter/material.dart';

import 'package:instsinfu/Screens/home_page.dart';
import 'package:instsinfu/Screens/login_page.dart';
import 'package:instsinfu/Screens/secondScreen.dart';
import 'package:instsinfu/Screens/single_user_webview.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/home":
        return MaterialPageRoute(builder: (context) => HomePage());
      case "/secondScreen":
        return MaterialPageRoute(builder: (context) => SecondScreen());
      case "/login":
        return MaterialPageRoute(builder: (context) => LoginPage());
      case "/singleUserWeb":
        final _initialUrl = settings.arguments;
        return MaterialPageRoute(
            builder: (context) => SingleUserWebView(initialUrl: _initialUrl));
    }
  }
}
