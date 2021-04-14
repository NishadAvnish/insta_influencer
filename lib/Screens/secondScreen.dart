import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instsinfu/Models/profile_model.dart';
import 'package:instsinfu/Utils/databasehelper.dart';
import 'package:instsinfu/Widgets/second_list_Item.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  DatabaseHelper databasehelper;
  List<ProfileModel> profileModel = [];
  int _currentGridIndex = 0;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    databasehelper = DatabaseHelper();
    fetchData();
  }

  fetchData() {
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
        body: Column(
          children: [
            Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 12.0),
                  child: GridView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 3,
                          crossAxisCount: 3,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 80),
                      itemBuilder: (context, index) {
                        return _ratingBar("${index + 1}", index);
                      }),
                )),
            Expanded(
              child: FutureBuilder(
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
                                    Navigator.of(context).pushNamed(
                                        "/singleUserWeb",
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Item deleted Successfully!")));
                                      }).catchError((e) {
                                        setState(() {});
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Something went wrong!")));
                                      });
                                    },
                                    child: ListItem(
                                      profile: profile,
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
              ),
            ),
          ],
        ));
  }

  Widget _ratingBar(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentGridIndex = index;
        });
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
                width: 2,
                color: _currentGridIndex == index
                    ? Colors.orange
                    : Colors.black54),
            borderRadius: BorderRadius.circular(15.0)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.button,
              ),
              Icon(Icons.star)
            ],
          ),
        ),
      ),
    );
  }
}
