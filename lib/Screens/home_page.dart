import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instsinfu/Providers/insta_profile_provider.dart';
import 'package:instsinfu/Widgets/back_button.dart';
import 'package:instsinfu/Widgets/home_appbar_widget.dart';
import 'package:instsinfu/Widgets/show_model.dart';
import 'package:instsinfu/Widgets/webview_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int _currentPageIndex;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _webViewController;
  int _count;
  bool _isLoading;
  bool _isLoadingWebview;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
    _count = 0;
    _isLoading = true;
    _isLoadingWebview = false;
    _pageController = PageController(initialPage: 0);

    // if (mounted) _checkPermissionStatus();
    if (!mounted) return;
    _fetch();
  }

  Future<void> _fetch() async {
    final _provider = Provider.of<InstaProfileProvider>(context, listen: false);
    if (_provider.islast == false) {
      await _provider.fetchData();

      if (_count == 0)
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _homeProvider = Provider.of<InstaProfileProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () => onBackPressed(context),
        child: SafeArea(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                      Text(_homeProvider
                                          .instaUserList[_currentPageIndex]
                                          .engrate),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                      Text(_homeProvider
                                          .instaUserList[_currentPageIndex]
                                          .avgLike),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                                flex: 1,
                                child: IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () {}))
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
                        child: Stack(children: [
                          Container(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          Positioned.fill(
                            child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPageIndex = index;
                                  });

                                  if (index ==
                                      _homeProvider.instaUserList.length - 12) {
                                    _fetch();
                                  }
                                },
                                itemCount: _homeProvider.instaUserList.length,
                                itemBuilder: (context, index) {
                                  return customWebView(_homeProvider
                                      .instaUserList[index].userProfilelink);
                                }),
                          ),
                          Positioned(
                            bottom: 25,
                            left: 25,
                            right: 20,
                            // child: _webViewController.currentUrl().toString() ==
                            //         "https://www.instagram.com/accounts/login/"
                            //     ? Container()
                            //     :
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
                                  onPressed: () {
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 50),
                                        curve: Curves.easeIn);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget customWebView(String initialUrl) {
    return WebView(
      key: ValueKey(initialUrl),
      initialUrl: initialUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
        // _controller.complete(webViewController);
      },
      gestureRecognizers: [
        Factory(() => VerticalDragGestureRecognizer()),
      ].toSet(),
      onPageFinished: (s) {
        try {
          _webViewController.evaluateJavascript("javascript:(function() { " +
              // "document.getElementsByTagName('nav')[0].style.display='none';" +
              // "document.getElementsByClassName(' ffKix ')[0].style.display='none';" +
              "document.getElementsByClassName('KGiwt')[0].style.display='none';" +
              "})()");
        } catch (e) {
          debugPrint('$e');
        }
      },
    );
  }
}
