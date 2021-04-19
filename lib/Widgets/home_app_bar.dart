import 'package:flutter/material.dart';
import 'package:instsinfu/Providers/notifier_provider.dart';
import 'package:instsinfu/Providers/insta_profile_provider.dart';
import 'package:instsinfu/Providers/logined_current_provider.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget {
  bool isCurrentlyLogin;
  HomeAppBar({Key key, this.isCurrentlyLogin}) : super(key: key);

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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 1,
                  child: isCurrentlyLogin
                      ? IconButton(
                          icon: Icon(Icons.logout),
                          onPressed: () {
                            Provider.of<LoginCurrentNoProvider>(context,
                                    listen: false)
                                .changeCurrentStatus(isLogin: false);
                            isLogin.value = false;
                          })
                      : Container(),
                ),
                Flexible(
                  flex: 6,
                  child: isCurrentlyLogin
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    .instaUserList[currentPageIndex].engrate),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    .instaUserList[currentPageIndex].avgLike),
                              ],
                            ),
                          ],
                        )
                      : Text(
                          "Instancer",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                ),
                Flexible(
                    flex: 1,
                    child: IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () {
                          Navigator.pushNamed(context, "/secondScreen");
                        })),
              ],
            ),
          );
        });
  }
}
