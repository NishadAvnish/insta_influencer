import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instsinfu/Models/profile_model.dart';
import 'package:instsinfu/Utils/databasehelper.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  DatabaseHelper databasehelper;
  List<ProfileModel> profileModel = [];

  @override
  void initState() {
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
          title: Text("Favourite"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: databasehelper.getTrans(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              profileModel = snapshot.data;
              return snapshot.data.length == 0
                  ? Center(
                      child: Text("No Data Found!"),
                    )
                  : ListView.builder(
                      itemBuilder: (context, int index) {
                        ProfileModel profile = ProfileModel();
                        profile = profileModel[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 05),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/singleUserWeb",
                                  arguments: profile.userProfilelink);
                            },
                            child: Dismissible(
                              // Each Dismissible must contain a Key. Keys allow Flutter to
                              // uniquely identify widgets.
                              key: UniqueKey(),
                              // Provide a function that tells the app
                              // what to do after an item has been swiped away.
                              onDismissed: (direction) {
                                // Remove the item from the data source.
                                DatabaseHelper()
                                    .delete(profile.userid)
                                    .then((value) {
                                  setState(() {
                                    snapshot.data.removeAt(index);
                                  });

                                  // Show a snackbar. This snackbar could also contain "Undo" actions.
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Item deleted Successfully!")));
                                }).catchError((e) {
                                  setState(() {});
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Something went wrong!")));
                                });
                              },
                              child: Container(
                                height: 100,
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    elevation: 2,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                Colors.brown.shade800,
                                            child: Text(profile.userName[0]
                                                .toUpperCase()),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                profile.userName,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              profile.category == "null"
                                                  ? SizedBox()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 4.0,
                                                              top: 4.0),
                                                      child: Text(
                                                        profile.category,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
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
                                                        style: TextStyle(
                                                            fontSize: 12),
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
                                                        style: TextStyle(
                                                            fontSize: 12),
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
                                                    Clipboard.setData(
                                                            new ClipboardData(
                                                                text: profile
                                                                    .userProfilelink))
                                                        .then((value) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .hideCurrentSnackBar();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "Email c opied to clipboard")));
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
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: profileModel.length,
                    );
            } else
              return Center(child: new Text("no data"));
          },
        ));
  }
}
