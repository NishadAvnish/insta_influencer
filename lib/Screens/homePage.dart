import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instsinfu/Widgets/back_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isGranted;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebViewController _webViewController;
  @override
  void initState() {
    super.initState();
    _isGranted = false;
    _checkPermissionStatus();
  }

  void _showDialog(title, content, actionButton) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title, style: Theme.of(context).textTheme.headline6),
            content:
                Text(content, style: Theme.of(context).textTheme.bodyText1),
            actions: <Widget>[
              MaterialButton(
                child: Text(actionButton[0],
                    style: Theme.of(context).textTheme.bodyText1),
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ),
            ],
          );
        });
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.storage.status;

    if (status.isGranted) {
      //do nothing in this case
      setState(() {
        _isGranted = true;
      });
    } else if (status.isPermanentlyDenied) {
      _showDialog(
          "Open Phone Setting",
          "open phone setting to use the app by granting the required permission",
          ["Ok"]);
    } else {
      _askForPermission();
    }
  }

  Future<void> _askForPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();
    if (statuses[Permission.storage] == PermissionStatus.granted) {
      setState(() {
        _isGranted = true;
      });
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () => onBackPressed(context),
        child: SafeArea(
          child: Container(
            width: _size.width,
            height: _size.height,
            child: Column(
              children: [
                SizedBox(
                  height: kToolbarHeight,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Eng. Rate",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                ),
                                Text("2.8"),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Avg. Like",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                ),
                                Text("360098"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child: IconButton(
                              icon: Icon(Icons.more_vert), onPressed: () {}))
                    ],
                  ),
                ),
                Container(
                  width: _size.width,
                  height: _size.height -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                  constraints: BoxConstraints(minHeight: 150),
                  child: PageView(
                    children: [
                      Stack(
                        children: [
                          Positioned.fill(
                            child: WebView(
                              initialUrl: 'https://www.instagram.com/aimetix/',
                              javascriptMode: JavascriptMode.unrestricted,
                              onWebViewCreated:
                                  (WebViewController webViewController) {
                                _webViewController = webViewController;
                                _controller.complete(webViewController);
                              },
                              onPageFinished: (s) {
                                _webViewController
                                    .evaluateJavascript("javascript:(function() { " +
                                        "document.getElementsByTagName('nav')[0].style.display='none';" +
                                        "document.getElementsByClassName('sqdOP  L3NKy _4pI4F  y3zKF     ')[0].style.display='none';" +
                                        "document.getElementsByClassName('e-Ph9 ccgHY l9Ww0 ')[0].style.display='none';" +
                                        "document.getElementsByTagName('footer')[0].style.display='none';" +
                                        "document.getElementsByClassName('tCibT qq7_A  z4xUb w5S7h')[0].style.display='none';" +
                                        "})()")
                                    .catchError(
                                        (onError) => debugPrint('$onError'));
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 25,
                            left: 25,
                            right: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      primary: Colors.green),
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.done,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      primary: Colors.red),
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.close,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
