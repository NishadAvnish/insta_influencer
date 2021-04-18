import 'dart:async';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:instsinfu/Providers/currentindex_notifier.dart';
import 'package:instsinfu/Providers/insta_profile_provider.dart';
import 'package:instsinfu/Providers/logined_current_provider.dart';
import 'package:instsinfu/Utils/databasehelper.dart';
import 'package:instsinfu/Widgets/back_button.dart';
import 'package:instsinfu/Widgets/custom_webview.dart';
import 'package:instsinfu/Widgets/home_app_bar.dart';
import 'package:instsinfu/Widgets/rating_bar_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databasehelper;
  PageController _pageController;
  bool _isLoading;
  bool _isLogin;
  LoginCurrentNoProvider _loginProvider;
  @override
  void initState() {
    super.initState();
    databasehelper = DatabaseHelper();
    _isLogin = false;
    _pageController = PageController(initialPage: currentIndexValue.value);

    if (!mounted) return;
    _fetch();
  }

  Future<void> _fetch() async {
    _loginProvider =
        Provider.of<LoginCurrentNoProvider>(context, listen: false);
    _isLoading = true;
    // count is to avoid fetch call every time user moves to Home
    if (_loginProvider.count == 0) {
      await _refresh();
    }
  }

  Future<void> _refresh() async {
    await Provider.of<LoginCurrentNoProvider>(context, listen: false)
        .fetchLoginData();
    if (!_isLogin) {
      if (_loginProvider.loginCurrentdata.isLogin == false ||
          _loginProvider.loginCurrentdata.isLogin == true &&
              DateTime.now()
                      .difference(_loginProvider.loginCurrentdata.dateTime)
                      .inMinutes >=
                  4) {
        final _provider =
            Provider.of<InstaProfileProvider>(context, listen: false);

        _loginProvider.login(); // to change the current status of loginData.

        if (_provider.islast == false) {
          await _provider.fetchData(
              currentRowNo: _loginProvider.loginCurrentdata.currentNo.toInt());
        }
        setState(() {
          _isLogin = true;
        });
      }
      setState(() {
        _isLoading = false;
      });

      if (_isLogin)

        //start periodic timer to call api every time
        Cron().schedule(Schedule.parse('*/3 * * * *'), () async {
          Provider.of<LoginCurrentNoProvider>(context, listen: false)
              .changeCurrentStatus(isLogin: true);
        });
    }
  }

  Future<void> _fetchMore() async {
    final _loginProvider =
        Provider.of<LoginCurrentNoProvider>(context, listen: false);
    final _provider = Provider.of<InstaProfileProvider>(context, listen: false);
    if (_provider.islast == false) {
      await _provider.fetchData(
          currentRowNo: _loginProvider.loginCurrentdata.currentNo.toInt());
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
                      HomeAppBar(
                        isLogin:
                            _isLogin && _loginProvider.loginCurrentdata.isLogin,
                      ),
                      RefreshIndicator(
                        onRefresh: () => _refresh(),
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            width: _size.width,
                            height: _size.height -
                                kToolbarHeight -
                                MediaQuery.of(context).padding.top -
                                MediaQuery.of(context).padding.bottom,
                            constraints: BoxConstraints(minHeight: 150),
                            child: Stack(children: [
                              Positioned.fill(
                                child: _isLogin &&
                                        _loginProvider.loginCurrentdata.isLogin
                                    ? Consumer<InstaProfileProvider>(builder:
                                        (context, homeProvider, child) {
                                        return PageView.builder(
                                            controller: _pageController,
                                            onPageChanged: (index) {
                                              currentIndexValue.value = index;
                                              if (index ==
                                                  homeProvider.instaUserList
                                                          .length -
                                                      6) {
                                                _fetchMore();
                                              }
                                            },
                                            itemCount: homeProvider
                                                .instaUserList.length,
                                            itemBuilder: (context, index) {
                                              return CustomWebView(
                                                  initialUrl: homeProvider
                                                      .instaUserList[index]
                                                      .userProfilelink);
                                            });
                                      })
                                    : Center(
                                        child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text:
                                                "Another Session is in Active State\n",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                .copyWith(color: Colors.grey),
                                            children: [
                                              TextSpan(
                                                  text: "Pull Down To Refresh!",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button
                                                      .copyWith(
                                                          color: Colors.grey)),
                                            ]),
                                      )),
                              ),
                              _isLogin &&
                                      _loginProvider.loginCurrentdata.isLogin
                                  ? Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: RatingBarWidget(
                                          databasehelper: databasehelper,
                                          pageController: _pageController),
                                    )
                                  : Container(),
                            ]),
                          ),
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
