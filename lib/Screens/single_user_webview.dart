import 'package:flutter/material.dart';
import 'package:instsinfu/Widgets/custom_webview.dart';

class SingleUserWebView extends StatelessWidget {
  String initialUrl;
  SingleUserWebView({Key key, this.initialUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomWebView(
        initialUrl: initialUrl,
      )),
    );
  }
}
