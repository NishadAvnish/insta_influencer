import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

class LoadCsvDataScreen extends StatefulWidget {
  final String path;

  LoadCsvDataScreen({this.path});

  @override
  _LoadCsvDataScreenState createState() => _LoadCsvDataScreenState();
}

class _LoadCsvDataScreenState extends State<LoadCsvDataScreen> {
  List<List<dynamic>> _data = [];

  @override
  void initState() {
    super.initState();

    if (mounted) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    // final _myData = await rootBundle.loadString(widget.path);
    // final _csvData = CsvToListConverter().convert(_myData);
    final _csvData = await loadingCsvData(widget.path);

    _data.addAll(_csvData);

    setState(() {});
  }

  Future<List<List<dynamic>>> loadingCsvData(String path) async {
    final csvFile = new File(path).openRead();
    return await csvFile
        .transform(utf8.decoder)
        .transform(
          CsvToListConverter(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceBrightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
        appBar: AppBar(
          title: Text("CSV DATA"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dividerThickness: 2.0,
              headingRowColor: MaterialStateColor.resolveWith((states) {
                return Colors.teal;
              }),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: _deviceBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey.shade900),
              ),
              columns: [
                "UserID",
                "UserId",
                "Insta_Profile",
                "Email",
                "Category",
                "Eng rate",
                'Avg. like',
                "Rating"
              ].map((element) => DataColumn(label: Text(element))).toList(),
              rows: _data.mapIndexed((item, index) {
                return DataRow(
                    cells: item
                        .map(
                          (row) => DataCell(Text(row.toString())),
                        )
                        .toList());
              }).toList(),
            ),
          ),
        ));
  }
}

// // SingleChildScrollView(
//         child: FutureBuilder(
//           future: loadingCsvData(path),
//           builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
//             return snapshot.hasData
//                 ? Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: snapshot.data
//                           .map(
//                             (data) => Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 10),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Text(
//                                     data[0].toString(),
//                                   ),
//                                   Text(
//                                     data[1].toString(),
//                                   ),
//                                   Text(
//                                     data[2].toString(),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                           .toList(),
//                     ),
//                   )
//                 : Center(
//                     child: CircularProgressIndicator(),
//                   );
//           },
//         ),
//       ),
