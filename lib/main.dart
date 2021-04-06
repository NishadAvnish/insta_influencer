import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:instsinfu/Models/profile_model.dart';
import 'package:instsinfu/Utils/routes.dart';
import 'package:provider/provider.dart';

import 'Providers/insta_profile_provider.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // Directory dir = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
  // Hive.init(dir.path);
  // await Hive.openBox<ProfileModel>("SavedData");
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
