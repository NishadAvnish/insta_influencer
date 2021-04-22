import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instsinfu/Models/profile_model.dart';
import 'package:instsinfu/Providers/database_helper_provider.dart';
import 'package:instsinfu/Utils/databasehelper.dart';
import 'package:instsinfu/Widgets/popup_menu_option.dart';
import 'package:instsinfu/Widgets/second_list_Item.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  DatabaseHelper databasehelper;
  int _currentGridIndex = 0;
  bool isConvrtCSV = true;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    databasehelper = DatabaseHelper();
    if (mounted) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    await Provider.of<DatabaseHelperProvider>(context, listen: false)
        .fetchDatabaseData(rating: _currentGridIndex + 1);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favourite"),
          centerTitle: true,
          actions: [CustomPopUpMenu()],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed("/savedcsvscreen"),
          child: Icon(Icons.save),
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
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Consumer<DatabaseHelperProvider>(
                      builder: (context, snapshot, _) {
                      return snapshot.savedDatabaselist.length == 0
                          ? Center(
                              child: Text("No Data Found!"),
                            )
                          : ListView.builder(
                              itemBuilder: (context, int index) {
                                ProfileModel profile = ProfileModel();
                                profile = snapshot.savedDatabaselist[index];
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
                                        Provider.of<DatabaseHelperProvider>(
                                                context,
                                                listen: false)
                                            .deleteFromDatabase(
                                                userId: profile.userid,
                                                rating: _currentGridIndex + 1)
                                            .then((value) {
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
                              itemCount: snapshot.savedDatabaselist.length,
                            );
                    }),
            ),
          ],
        ));
  }

  Widget _ratingBar(String text, int index) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _currentGridIndex = index;
          _isLoading = true;
        });
        await Provider.of<DatabaseHelperProvider>(context, listen: false)
            .fetchDatabaseData(rating: _currentGridIndex + 1);

        setState(() {
          _isLoading = false;
        });
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
                width: 2,
                color:
                    _currentGridIndex == index ? Colors.teal : Colors.black54),
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
