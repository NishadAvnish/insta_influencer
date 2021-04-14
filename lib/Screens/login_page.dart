import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instsinfu/Screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: WebView(
        initialUrl: "https://www.instagram.com/accounts/login/",
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (s) async {
          if (s == "https://www.instagram.com/") {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
            try {
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              await _prefs.setInt('counter', 1);
            } catch (e) {
              print(e);
            }
          }
        },
      )),
    );
  }
}
