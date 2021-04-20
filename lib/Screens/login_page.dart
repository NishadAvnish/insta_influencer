import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:instsinfu/Screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
  bool _isGranted = false;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    super.initState();

    _checkPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SingleChildScrollView(
        child: SizedBox(
          height: _size.height,
          width: _size.width,
          child: WebView(
            initialUrl: "https://www.instagram.com/accounts/login/",
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (s) async {
              if (s == "https://www.instagram.com/") {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
                try {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  await _prefs.setInt('counter', 1);
                } catch (e) {
                  print(e);
                }
              }
            },
          ),
        ),
      )),
    );
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.storage.status;

    if (status.isGranted) {
      //do nothing in this case
      setState(() {});
    } else if (status.isPermanentlyDenied) {
      _showDialog(
        "Open Phone Setting",
        "open phone setting to use the app by granting the required permission",
      );
    } else {
      _askForPermission();
    }
  }

  void _showDialog(title, content) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title, style: Theme.of(context).textTheme.headline6),
            content:
                Text(content, style: Theme.of(context).textTheme.bodyText1),
          );
        });
  }

  Future<void> _askForPermission() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.storage].request();
      if (statuses[Permission.storage] == PermissionStatus.granted) {
        setState(() {});
      } else {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    } else if (Platform.isIOS) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.photos].request();
      if (statuses[Permission.photos] == PermissionStatus.granted) {
        setState(() {});
      } else {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }
  }
}
