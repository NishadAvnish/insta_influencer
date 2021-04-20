import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class SavedCSVFiles extends StatefulWidget {
  @override
  _SavedCSVFilesState createState() => _SavedCSVFilesState();
}

class _SavedCSVFilesState extends State<SavedCSVFiles> {
  List<FileSystemEntity> _selectedList = [];
  List<FileSystemEntity> _itemList = [];
  bool _isSelected = false;
  bool _isLoading;
  Directory _dir;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    if (!mounted) return;
    _getFiles();
  }

  Future<void> _getFiles() async {
    _dir = await getApplicationDocumentsDirectory();
    _dir.list().every((element) {
      if (element.toString().contains("star")) {
        _itemList.add(element);
      }
      return true;
    }).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _selectItem(int index) {
    if (!_selectedList.contains(_itemList[index])) {
      _selectedList.add(_itemList[index]);
      _isSelected = true;
      setState(() {});
    }
  }

  Future<void> _deleteSelectedItem() async {
    Future.delayed(Duration(milliseconds: 100));

    _selectedList.forEach((element) async {
      if (_itemList.contains(element)) _itemList.remove(element);
      final _splitList = element.toString().split("/");
      var _fileName = _splitList[_splitList.length - 1];
      _fileName = _fileName.substring(0, _fileName.length - 1);
      await File(_dir.path + "/" + _fileName).delete();
    });
    _selectedList.clear();
    setState(() {});
  }

  Future<void> _shareContent() async {
    try {
      List<String> _sharableList = [];
      _selectedList.forEach((element) {
        _sharableList.add(element.path);
      });
      Share.shareFiles(_sharableList);
    } catch (e) {
      print(e);
    }
  }

  // Future<void> _selectAll() async {
  //   Future.delayed(Duration(milliseconds: 100));

  //   _selectedList = _itemList;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedList.length < 1
            ? "Saved CSVs"
            : "${_selectedList.length} item selected"),
        centerTitle: !_isSelected,
        actions: [
          _isSelected
              ? Row(
                  children: [
                    // IconButton(
                    //   icon: Icon(Icons.done_all),
                    //   onPressed: () => _selectAll(),
                    // ),
                    SizedBox(width: 8),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteSelectedItem()),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        _shareContent();
                      },
                    ),
                    SizedBox(width: 8),
                  ],
                )
              : Container()
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _itemList.length == 0
                ? Center(
                    child: Text("No CSV file found!"),
                  )
                : SizedBox(
                    height: _mediaQuery.size.height -
                        _mediaQuery.padding.top -
                        _mediaQuery.padding.bottom -
                        kToolbarHeight,
                    width: _mediaQuery.size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 165,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 3 / 5),
                        itemBuilder: (context, index) {
                          final _splitList =
                              _itemList[index].toString().split("/");
                          final _fileName = _splitList[_splitList.length - 1];
                          return GestureDetector(
                            onLongPress: () => _selectItem(index),
                            onTap: _isSelected
                                ? () => _selectItem(index)
                                : () => Navigator.of(context).pushNamed(
                                    "/loadCsvFile",
                                    arguments: _itemList[index].path),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.0)),
                                            child: Center(
                                                child: Opacity(
                                              opacity: 0.3,
                                              child: Image.asset(
                                                "Assets/Images/csv.png",
                                                height: 50,
                                                width: 50,
                                              ),
                                            )),
                                          ),
                                        ),
                                        _selectedList.contains(_itemList[index])
                                            ? Positioned(
                                                top: 8,
                                                right: 8,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _selectedList.remove(
                                                        _itemList[index]);
                                                    setState(() {
                                                      if (_selectedList
                                                              .length ==
                                                          0)
                                                        _isSelected = false;
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    "Assets/Images/correct.png",
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ))
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: 45,
                                    child: Card(
                                      elevation: 0.0,
                                      color: Colors.grey.withOpacity(0.7),
                                      child: Center(child: Text(_fileName)),
                                    ))
                              ],
                            ),
                          );
                        },
                        itemCount: _itemList.length,
                      ),
                    ),
                  ),
      ),
    );
  }
}
