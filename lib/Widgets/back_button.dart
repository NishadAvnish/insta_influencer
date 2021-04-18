import 'package:cron/cron.dart';
import 'package:flutter/material.dart';

Future<bool> onBackPressed(BuildContext context) async {
  Cron().close();
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Are you sure?'),
      content: new Text('Do you want to exit from App'),
      actions: <Widget>[
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: Text("NO"),
        ),
        SizedBox(height: 30),
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(true),
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text("YES"),
          ),
        ),
      ],
    ),
  );
}
