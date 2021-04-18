import 'package:flutter/material.dart';
import 'package:instsinfu/Providers/logined_current_provider.dart';
import 'package:instsinfu/Utils/routes.dart';
import 'package:instsinfu/Utils/theme_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Providers/insta_profile_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  int x = 5;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  int counter = 0;
  _sharedPreference() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    counter = _prefs.getInt('counter');
  }

  @override
  Widget build(BuildContext context) {
    _sharedPreference();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginCurrentNoProvider()),
        ChangeNotifierProvider.value(value: InstaProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        darkTheme: MyThemes.darkTheme,
        theme: MyThemes.lightTheme,
        initialRoute: counter == 0 ? "/login" : "/home",
        // initialRoute: "/secondScreen",
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
