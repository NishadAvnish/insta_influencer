import 'package:flutter/material.dart';
import 'package:instsinfu/Models/profile_model.dart';
import 'package:instsinfu/Providers/currentindex_notifier.dart';
import 'package:instsinfu/Providers/insta_profile_provider.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget {
  ProfileModel currentProfile;
  HomeAppBar({Key key, this.currentProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _homeProvider =
        Provider.of<InstaProfileProvider>(context, listen: false);
    return ValueListenableBuilder(
        valueListenable: currentIndexValue,
        builder: (context, currentPageIndex, child) {
          return SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Row(
              children: [
                Flexible(
                  flex: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Eng. Rate",
                            style: Theme.of(context).textTheme.button.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          Text(_homeProvider
                              .instaUserList[currentPageIndex].engrate),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Avg. Like",
                            style: Theme.of(context).textTheme.button.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          Text(_homeProvider
                              .instaUserList[currentPageIndex].avgLike),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () {
                          Navigator.pushNamed(context, "/secondScreen");
                        }))
              ],
            ),
          );
        });
  }
}
