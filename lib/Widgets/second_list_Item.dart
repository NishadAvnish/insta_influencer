import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instsinfu/Models/profile_model.dart';

class ListItem extends StatelessWidget {
  final ProfileModel profile;
  const ListItem({Key key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.brown.shade800,
                  child: Text(profile.userName[0].toUpperCase()),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.userName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    profile.category == "null"
                        ? SizedBox()
                        : Padding(
                            padding:
                                const EdgeInsets.only(bottom: 4.0, top: 4.0),
                            child: Text(
                              profile.category,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 12,
                            ),
                            SizedBox(width: 3),
                            Text(
                              "${profile.avgLike}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.timeline,
                              size: 12,
                            ),
                            SizedBox(width: 3),
                            Text(
                              "${profile.engrate}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                profile.email != null
                    ? IconButton(
                        icon: Icon(Icons.email),
                        onPressed: () {
                          Clipboard.setData(new ClipboardData(
                                  text: profile.userProfilelink))
                              .then((value) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Email copied to clipboard")));
                          });
                        })
                    : SizedBox()
              ],
            ),
          )

          // ListTile(
          //   leading: RotatedBox(quarterTurns: -1, child: Text("Category")),
          //   title: Text("Name"),
          // ),
          ),
    );
  }
}
