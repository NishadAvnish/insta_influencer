import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instsinfu/Providers/currentindex_notifier.dart';
import 'package:instsinfu/Providers/insta_profile_provider.dart';
import 'package:instsinfu/Utils/databasehelper.dart';
import 'package:instsinfu/Widgets/back_button.dart';
import 'package:instsinfu/Widgets/home_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databasehelper;
  PageController _pageController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _webViewController;
  int _count;
  bool _isLoading;
  @override
  void initState() {
    super.initState();
    databasehelper = DatabaseHelper();
    _count = 0;
    _isLoading = true;
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

    return Scaffold(
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
                      HomeAppBar(),
                      Container(
                        width: _size.width,
                        height: _size.height -
                            kToolbarHeight -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom,
                        constraints: BoxConstraints(minHeight: 150),
                        child: Stack(children: [
                          Positioned.fill(
                            child: Consumer<InstaProfileProvider>(
                                builder: (context, homeProvider, child) {
                              return PageView.builder(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    currentIndexValue.value = index;
                                    if (index ==
                                        homeProvider.instaUserList.length -
                                            12) {
                                      _fetch();
                                    }
                                  },
                                  itemCount: homeProvider.instaUserList.length,
                                  itemBuilder: (context, index) {
                                    return customWebView(homeProvider
                                        .instaUserList[index].userProfilelink);
                                  });
                            }),
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
                                  onPressed: () {
                                    databasehelper.addTransToDatabase(
                                        Provider.of<InstaProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .instaUserList[
                                            currentIndexValue.value]);
                                  },
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
              //"document.getElementsByClassName(' ffKix ')[0].style.display='none';" +
              "document.getElementsByClassName('KGiwt')[0].style.display='none';" +
              "})()");
        } catch (e) {
          debugPrint('$e');
        }
      },
    );
  }
}