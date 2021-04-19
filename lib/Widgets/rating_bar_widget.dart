import 'package:flutter/material.dart';
import 'package:instsinfu/Providers/notifier_provider.dart';
import 'package:instsinfu/Providers/insta_profile_provider.dart';
import 'package:instsinfu/Providers/logined_current_provider.dart';
import 'package:instsinfu/Utils/databasehelper.dart';
import 'package:provider/provider.dart';

class RatingBarWidget extends StatelessWidget {
  const RatingBarWidget({
    Key key,
    @required this.databasehelper,
    @required PageController pageController,
  })  : _pageController = pageController,
        super(key: key);

  final DatabaseHelper databasehelper;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    final _deviceBrightness = MediaQuery.of(context).platformBrightness;
    return Container(
      padding: EdgeInsets.only(bottom: 4, top: 4, left: 0, right: 0),
      color: _deviceBrightness == Brightness.dark
          ? Colors.grey.shade900
          : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => _onButtonClickNextPage(1, context),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: _deviceBrightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                  shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "Assets/Images/1star.gif",
                  // height: 40,
                  // width: 40,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _onButtonClickNextPage(2, context),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: _deviceBrightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                  shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "Assets/Images/2star.gif",
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _onButtonClickNextPage(3, context),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: _deviceBrightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                  shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "Assets/Images/3star.gif",
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(), primary: Colors.red),
            onPressed: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 50), curve: Curves.easeIn);
            },
            child: Icon(
              Icons.close,
              size: 50,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _onButtonClickNextPage(int rating, BuildContext context) {
    final _templist = Provider.of<InstaProfileProvider>(context, listen: false)
        .instaUserList[currentIndexValue.value];

    //save currentIndex at every button click
    Provider.of<LoginCurrentNoProvider>(context, listen: false)
        .changeCurrentStatus(isLogin: true);

    _pageController.nextPage(
        duration: Duration(milliseconds: 50), curve: Curves.easeIn);

    databasehelper.addTransToDatabase(<String, dynamic>{
      "userName": _templist.userName,
      "userid": _templist.userid,
      "userProfilelink": _templist.userProfilelink,
      "email": _templist.email,
      "category": _templist.category,
      "engrate": _templist.engrate,
      "avgLike": _templist.avgLike,
      "rating": rating,
    }).catchError((error) {
      final snackBar =
          SnackBar(content: Text('Can\'t save : Something went wrong'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
