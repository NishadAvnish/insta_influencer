import 'package:flutter/material.dart';
import 'package:instsinfu/Providers/logined_current_provider.dart';
import 'package:instsinfu/Utils/routes.dart';
import 'package:instsinfu/Utils/theme_helper.dart';
import 'package:provider/provider.dart';
import 'Providers/database_helper_provider.dart';
import 'Providers/insta_profile_provider.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginCurrentNoProvider()),
        ChangeNotifierProvider.value(value: InstaProfileProvider()),
        ChangeNotifierProvider.value(value: DatabaseHelperProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        darkTheme: MyThemes.darkTheme,
        theme: MyThemes.lightTheme,
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
