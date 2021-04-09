import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instsinfu/Providers/insta_profile_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatelessWidget {
  final int index;
  InstaProfileProvider profileProvider;
  WebViewWidget({this.index, this.profileProvider});
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: profileProvider.instaUserList[index].userProfilelink,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
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
            .catchError((onError) => debugPrint('$onError'));
      },
    );
  }
}
