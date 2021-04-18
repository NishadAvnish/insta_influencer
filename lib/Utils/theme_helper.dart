import 'package:flutter/material.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(primary: Colors.black),
    snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey.shade500,
        contentTextStyle: TextStyle(color: Colors.white)),
  );

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(),
      snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(color: Colors.black)));
}
