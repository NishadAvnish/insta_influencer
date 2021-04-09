import 'package:flutter/material.dart';

import 'package:instsinfu/Screens/home_page.dart';
import 'package:instsinfu/Screens/secondScreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/home":
        return MaterialPageRoute(builder: (context) => HomePage());
      case "/secondScreen":
        return MaterialPageRoute(builder: (context) => SecondScreen());
    }
  }
}
