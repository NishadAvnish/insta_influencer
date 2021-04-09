import 'package:flutter/material.dart';
import 'package:instsinfu/Providers/insta_profile_provider.dart';

class HomeAppBarWidget extends StatelessWidget {
  final int index;
  final InstaProfileProvider homeProvider;

  const HomeAppBarWidget({Key key, this.index, this.homeProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  Text(homeProvider.instaUserList[index].engrate),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Avg. Like",
                    style: Theme.of(context).textTheme.button.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  Text(homeProvider.instaUserList[index].avgLike),
                ],
              ),
            ],
          ),
        ),
        Flexible(
            flex: 1,
            child: IconButton(icon: Icon(Icons.more_vert), onPressed: () {}))
      ],
    );
  }
}
