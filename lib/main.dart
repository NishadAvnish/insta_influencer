import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:instsinfu/Models/profile_model.dart';
import 'package:instsinfu/Utils/routes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'Providers/insta_profile_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory dir = await getApplicationSupportDirectory();
  Hive.init(dir.path);
  await Hive.openBox<ProfileModel>("SavedData");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: InstaProfileProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/home",
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
