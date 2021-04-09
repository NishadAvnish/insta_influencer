import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemBuilder: (context, int index) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 05),
            child: Container(
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(30))),
              height: 100,
              
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RotatedBox(
                            quarterTurns: -1,
                            child: Text(
                              "Category",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text("UserId"),
                          ],
                        ),
                        IconButton(icon: Icon(Icons.email), onPressed: () {})
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
        );
      },
      itemCount: 4,
    ));
  }
}
