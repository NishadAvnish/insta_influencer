import 'package:flutter/material.dart';
import 'package:instsinfu/Screens/home_page.dart';
import 'package:instsinfu/Screens/saved_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/home":
        return MaterialPageRoute(builder: (context) => HomePage());
      case "/savePage":
        return MaterialPageRoute(builder: (context) => SavedPage());
    }
  }
}
