import 'package:flutter/material.dart';
import 'package:instsinfu/Models/profile_model.dart';
import 'package:instsinfu/Providers/currentindex_notifier.dart';
import 'package:instsinfu/Providers/insta_profile_provider.dart';
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
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(), primary: Colors.green),
            onPressed: () {
              final _templist =
                  Provider.of<InstaProfileProvider>(context, listen: false)
                      .instaUserList[currentIndexValue.value];
              databasehelper.addTransToDatabase(
                  // Provider.of<InstaProfileProvider>(context, listen: false)
                  //     .instaUserList[currentIndexValue.value]

                  <String, dynamic>{
                    "userName": _templist.userName,
                    "userid": _templist.userid,
                    "userProfilelink": _templist.userProfilelink,
                    "email": _templist.email,
                    "category": _templist.category,
                    "engrate": _templist.engrate,
                    "avgLike": _templist.avgLike,
                    "rating": 1,
                  }).then((value) {
                final snackBar = SnackBar(content: Text('Saved to database'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }).catchError((error) {
                final snackBar =
                    SnackBar(content: Text('Something Went Wrong'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
              _pageController.nextPage(
                  duration: Duration(milliseconds: 50), curve: Curves.easeIn);
            },
            child: Icon(
              Icons.done,
              size: 50,
              color: Colors.white,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(), primary: Colors.green),
            onPressed: () {
              // databasehelper
              //     .addTransToDatabase(
              //         Provider.of<InstaProfileProvider>(
              //                     context,
              //                     listen: false)
              //                 .instaUserList[
              //             currentIndexValue.value])
              //     .then((value) {
              //   final snackBar = SnackBar(
              //       content: Text('Saved to database'));
              //   ScaffoldMessenger.of(context)
              //       .showSnackBar(snackBar);
              // }).catchError((error) {
              //   final snackBar = SnackBar(
              //       content:
              //           Text('Something Went Wrong'));
              //   ScaffoldMessenger.of(context)
              //       .showSnackBar(snackBar);
              // });
              _pageController.nextPage(
                  duration: Duration(milliseconds: 50), curve: Curves.easeIn);
            },
            child: Icon(
              Icons.done,
              size: 50,
              color: Colors.white,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(), primary: Colors.green),
            onPressed: () {
              // databasehelper
              //     .addTransToDatabase(
              //         Provider.of<InstaProfileProvider>(
              //                     context,
              //                     listen: false)
              //                 .instaUserList[
              //             currentIndexValue.value])
              //     .then((value) {
              //   final snackBar = SnackBar(
              //       content: Text('Saved to database'));
              //   ScaffoldMessenger.of(context)
              //       .showSnackBar(snackBar);
              // }).catchError((error) {
              //   final snackBar = SnackBar(
              //       content:
              //           Text('Something Went Wrong'));
              //   ScaffoldMessenger.of(context)
              //       .showSnackBar(snackBar);
              // });
              _pageController.nextPage(
                  duration: Duration(milliseconds: 50), curve: Curves.easeIn);
            },
            child: Icon(
              Icons.done,
              size: 50,
              color: Colors.white,
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
}
