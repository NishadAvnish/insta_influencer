import 'package:flutter/material.dart';
import 'package:instsinfu/Models/profile_model.dart';
import 'package:instsinfu/Utils/databasehelper.dart';
import 'package:url_launcher/url_launcher.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  DatabaseHelper databasehelper;
  List<ProfileModel> profileModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databasehelper = DatabaseHelper();
    refresh();
  }

  refresh() {
    setState(() {
      databasehelper.getTrans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [],
        ),
        body: FutureBuilder(
          future: databasehelper.getTrans(),
          builder: (context, snapshot) {
            print("${snapshot.hasData} ................................");
            if (snapshot.hasData) {
              profileModel = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, int index) {
                  ProfileModel profile = ProfileModel();
                  profile = profileModel[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 05),
                    child: Container(
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(30))),
                      height: 150,

                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.brown.shade800,
                                  child:
                                      Text(profile.userName[0].toUpperCase()),
                                ),

                                // RotatedBox(
                                //     quarterTurns: -1,
                                //     child: profile.category == "null"
                                //         ? SizedBox()
                                //         : Text(
                                //             profile.category,
                                //             style: TextStyle(
                                //                 fontSize: 20,
                                //                 fontWeight: FontWeight.bold),
                                //           )),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.userName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    profile.category == "null"
                                        ? SizedBox()
                                        : Text(
                                            profile.category,
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    profile.userid == "null"
                                        ? SizedBox()
                                        : Text(
                                            profile.userid,
                                            style: TextStyle(
                                                color: Colors.black26,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    Row(
                                      children: [
                                        Text("Avg Like : ${profile.engrate}")
                                      ],
                                    )
                                  ],
                                ),
                                IconButton(
                                    icon: Icon(Icons.email), onPressed: () {})
                              ],
                            ),
                          )

                          // ListTile(
                          //   leading: RotatedBox(quarterTurns: -1, child: Text("Category")),
                          //   title: Text("Name"),
                          // ),
                          ),
                    ),
                  );
                },
                itemCount: profileModel == null ? 0 : profileModel.length,
              );
            } else
              return Center(child: new Text("no data"));
          },
        ));
  }
}
