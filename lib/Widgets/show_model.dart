import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showCustomDialog(title, context, content, actionButton) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.headline6),
          content: Text(content, style: Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            MaterialButton(
              child: Text(actionButton[0],
                  style: Theme.of(context).textTheme.bodyText1),
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            ),
          ],
        );
      });
}
