import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:instsinfu/Utils/databasehelper.dart';

enum MenuOption { Export1, Export2, Export3, ExportAll }

class CustomPopUpMenu extends StatelessWidget {
  CustomPopUpMenu({Key key}) : super(key: key);

  DatabaseHelper databasehelper = DatabaseHelper();

  Future<void> _exportCSV({int rating, @required BuildContext context}) async {
    try {
      List<List<String>> data =
          await databasehelper.getTransCSV(rating: rating);
      if (rating == 4) {
        data = await databasehelper.getTransCSV(rating: 1);
        List<List<String>> data1 = await databasehelper.getTransCSV(rating: 2);

        data.addAll(data1);
        List<List<String>> data2 = await databasehelper.getTransCSV(rating: 3);
        data.addAll(data2);
      }

      String csvData = ListToCsvConverter().convert(data);
      final _fileName = "$rating star-${DateTime.now()}.csv";
      Directory _dir = Directory("storage/emulated/0/InstaInflucerCSV");

      if (!_dir.existsSync()) {
        _dir = await _dir.create(recursive: true);
      }

      await File(Directory(path.join(_dir.path, _fileName)).path)
          .writeAsString(csvData);

      final snackBar =
          SnackBar(content: Text('File saved to InstaInflucerCSV'));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar =
          SnackBar(content: Text('Can\'t save : Something went wrong'));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOption>(onSelected: (menuOption) {
      switch (menuOption) {
        case MenuOption.Export1:
          _exportCSV(rating: 1, context: context);
          break;
        case MenuOption.Export2:
          _exportCSV(rating: 2, context: context);
          break;
        case MenuOption.Export3:
          _exportCSV(rating: 3, context: context);
          break;
        case MenuOption.ExportAll:
          _exportCSV(rating: 4, context: context);
          break;
      }
    }, itemBuilder: (BuildContext context) {
      return <PopupMenuEntry<MenuOption>>[
        PopupMenuItem(
          child: Text("Export 1*"),
          value: MenuOption.Export1,
        ),
        PopupMenuItem(
          child: Text("Export 2*"),
          value: MenuOption.Export2,
        ),
        PopupMenuItem(
          child: Text("Export 3*"),
          value: MenuOption.Export3,
        ),
        PopupMenuItem(
          child: Text("Export All"),
          value: MenuOption.ExportAll,
        ),
      ];
    });
  }
}
