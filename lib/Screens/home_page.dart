import 'dart:async';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:instsinfu/Providers/notifier_provider.dart';
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

  LoginCurrentNoProvider _loginProvider;
  @override
  void initState() {
    super.initState();
    databasehelper = DatabaseHelper();

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
    if (!isLogin.value) {
      if (_loginProvider.loginCurrentdata.isLogin == false ||
          _loginProvider.loginCurrentdata.isLogin == true &&
              DateTime.now()
                      .difference(_loginProvider.loginCurrentdata.dateTime)
                      .inMinutes >=
                  2.10) {
        final _provider =
            Provider.of<InstaProfileProvider>(context, listen: false);

        _loginProvider.login(); // to change the current status of loginData.

        if (_provider.islast == false) {
          await _provider.fetchData(
              currentRowNo: _loginProvider.loginCurrentdata.currentNo.toInt());
        }
        isLogin.value = true;
      }
      setState(() {
        _isLoading = false;
      });

      if (isLogin.value)

        //start periodic timer to call api every time
        startCron(context);
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
              : MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: ValueListenableBuilder(
                      valueListenable: isLogin,
                      builder: (context, isLoginValue, _) {
                        return Container(
                          width: _size.width,
                          height: _size.height,
                          child: Column(
                            children: [
                              HomeAppBar(
                                isCurrentlyLogin: isLoginValue &&
                                    _loginProvider.loginCurrentdata.isLogin,
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
                                        child: isLoginValue &&
                                                _loginProvider
                                                    .loginCurrentdata.isLogin
                                            ? Consumer<InstaProfileProvider>(
                                                builder: (context, homeProvider,
                                                    child) {
                                                return PageView.builder(
                                                    controller: _pageController,
                                                    onPageChanged: (index) {
                                                      currentIndexValue.value =
                                                          index;
                                                      if (index ==
                                                          homeProvider
                                                                  .instaUserList
                                                                  .length -
                                                              6) {
                                                        _fetchMore();
                                                      }
                                                    },
                                                    itemCount: homeProvider
                                                        .instaUserList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return CustomWebView(
                                                          initialUrl: homeProvider
                                                              .instaUserList[
                                                                  index]
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
                                                        .copyWith(
                                                            color: Colors.grey),
                                                    children: [
                                                      TextSpan(
                                                          text:
                                                              "Pull Down To Refresh!",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .button
                                                              .copyWith(
                                                                  color: Colors
                                                                      .grey)),
                                                    ]),
                                              )),
                                      ),
                                      isLoginValue &&
                                              _loginProvider
                                                  .loginCurrentdata.isLogin
                                          ? Positioned(
                                              bottom: MediaQuery.of(context)
                                                  .padding
                                                  .bottom,
                                              left: 0,
                                              right: 0,
                                              child: RatingBarWidget(
                                                  databasehelper:
                                                      databasehelper,
                                                  pageController:
                                                      _pageController),
                                            )
                                          : Container(),
                                    ]),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
        ),
      ),
    );
  }
}
