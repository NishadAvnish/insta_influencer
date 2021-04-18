import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final initialUrl;
  final int flag;
  CustomWebView({Key key, this.initialUrl, this.flag}) : super(key: key);

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: WebView(
        initialUrl: widget.initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          _controller.complete(webViewController);
        },
        gestureRecognizers: [
          Factory(() => VerticalDragGestureRecognizer()),
        ].toSet(),
        onPageFinished: (s) {
          // if (widget.flag != null)
          try {
            if (widget.flag == 1)
              _webViewController.evaluateJavascript("javascript:(function() { " +

                  ///remove bottom navigation

                  "document.getElementsByClassName('KGiwt')[0].style.display='none';" +

                  ///remove use the app

                  "document.getElementsByClassName('Z_Gl2')[0].style.display='none';" +

                  // remove the back button
                  "document.getElementsByClassName('mXkkY HOQT4')[0].style.display='none';" +
                  "})()");
            else
              _webViewController.evaluateJavascript("javascript:(function() { " +

                  ///remove bottom navigation

                  "document.getElementsByClassName('KGiwt')[0].style.display='none';" +

                  ///remove use the app

                  "document.getElementsByClassName('Z_Gl2')[0].style.display='none';" +
                  "})()");
          } catch (e) {
            debugPrint('$e');
          }
        },
      ),
    );
  }
}
