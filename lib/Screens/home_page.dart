import 'dart:async';
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
  String _errorText = "";

  LoginCurrentNoProvider _loginProvider;
  @override
  void initState() {
    super.initState();
    databasehelper = DatabaseHelper();
    _pageController = PageController(initialPage: currentIndexValue.value);

    if (!mounted) return;
    _fetchMainSheetdata();
  }

  Future<void> _fetchMainSheetdata() async {
    _loginProvider =
        Provider.of<LoginCurrentNoProvider>(context, listen: false);
    _isLoading = true;
    // count is to avoid fetch call every time user moves to Home
    if (_loginProvider.count == 0) {
      await _refresh();
    }
  }

  Future<void> _refresh() async {
    try {
      await Provider.of<LoginCurrentNoProvider>(context, listen: false)
          .fetchLoginData();
      if (!isLogin.value) {
        if (_loginProvider.currentLoginInfo.isLogin == false ||
            _loginProvider.currentLoginInfo.isLogin == true &&
                DateTime.now()
                        .difference(DateTime.parse(
                            _loginProvider.currentLoginInfo.dateTime))
                        .inMinutes >=
                    2.50) {
          final _provider =
              Provider.of<InstaProfileProvider>(context, listen: false);

          _loginProvider.login(); // to change the current status of loginData.

          if (_provider.islast == false) {
            await _provider.fetchMainSheetData(
                currentRowNo:
                    _loginProvider.currentLoginInfo.currentNo.toInt());
          }
          isLogin.value = true;
        }

        if (isLogin.value)

          //start periodic timer to call api at every 2 minute time if user logined
          startCron(context);
      }
    } catch (e) {
      setState(() {
        _errorText = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchMoreMainSheet() async {
    final _loginProvider =
        Provider.of<LoginCurrentNoProvider>(context, listen: false);
    final _provider = Provider.of<InstaProfileProvider>(context, listen: false);
    if (_provider.islast == false) {
      await _provider.fetchMainSheetData(
          currentRowNo: _loginProvider.currentLoginInfo.currentNo.toInt());
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
          bottom: false,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  // child: Container(
                  //   width: _size.width,
                  //   height: _size.height ,
                  child: ValueListenableBuilder(
                      valueListenable: isLogin,
                      builder: (context, isLoginValue, _) {
                        return Column(
                          children: [
                            HomeAppBar(
                              isCurrentlyLogin: isLoginValue &&
                                  _loginProvider.currentLoginInfo.isLogin,
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () => _refresh(),
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: _homePageMainUI(isLoginValue),
                                ),
                              ),
                            ),
                            isLoginValue &&
                                    _loginProvider.currentLoginInfo.isLogin
                                ? RatingBarWidget(
                                    databasehelper: databasehelper,
                                    pageController: _pageController)
                                : Container(
                                    color: Colors.red,
                                  ),
                          ],
                        );
                      }),
                  // ),
                ),
        ),
      ),
    );
  }

  Widget _homePageMainUI(bool isLoginValue) {
    return
        // [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: isLoginValue && _loginProvider.currentLoginInfo.isLogin
                ? Consumer<InstaProfileProvider>(
                    builder: (context, homeProvider, child) {
                    return PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          currentIndexValue.value = index;
                          if (index == homeProvider.instaUserList.length - 6) {
                            _fetchMoreMainSheet();
                          }
                        },
                        itemCount: homeProvider.instaUserList.length,
                        itemBuilder: (context, index) {
                          return CustomWebView(
                              initialUrl: homeProvider
                                  .instaUserList[index].userProfilelink);
                        });
                  })
                : _errorText != ""
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            _errorText,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                      )
                    : Center(
                        child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "Another Session is in Active State\n",
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
                                      .copyWith(color: Colors.grey)),
                            ]),
                      )));

    // isLoginValue && _loginProvider.currentLoginInfo.isLogin
    //     ? Positioned(
    //         bottom: 0,
    //         left: 0,
    //         right: 0,
    //         child: RatingBarWidget(
    //             databasehelper: databasehelper,
    //             pageController: _pageController),
    //       )
    //     : Container(
    //         color: Colors.red,
    //       ),
    // ];
  }
}
