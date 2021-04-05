import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

enum menul { menu1, menu2, menu3 }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
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
                          Text("data"),
                          Text("data5"),
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
                child: PageView(
                  children: [
                    Stack(
                      children: [
                        Positioned.fill(
                          child: WebView(
                            key: UniqueKey(),
                            initialUrl: 'https://www.instagram.com/aimetix/',
                            javascriptMode: JavascriptMode.unrestricted,
                            onPageFinished: (String s) {
                              print(s);
                              setState(() {
                                _isLoading = !_isLoading;
                              });
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
                                    shape: CircleBorder(), primary: Colors.red),
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
    );
  }
}
