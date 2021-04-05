import 'package:flutter/material.dart';
import 'package:instsinfu/Screens/homePage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/home":
        return MaterialPageRoute(builder: (context) => HomePage());
    }
  }
}
