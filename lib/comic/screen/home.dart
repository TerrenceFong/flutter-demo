import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/comic/utils/sqflite_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import "package:collection/collection.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, String>> comicList = [];

  @override
  void initState() {
    super.initState();
    print('comicList');

    getRootInfo();

    // 初始化数据库
    SqfliteManager.getInstance();
  }

  Future<String> localPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<void> getRootInfo() async {
    final path = await localPath();

    final dir = Directory('$path');
    print('root: $dir');

    List<Map<String, String>> _items = [];

    await for (var entity in dir.list(followLinks: false)) {
      final isDir = await FileSystemEntity.isDirectory(entity.path);
      final dirname = p.basename(entity.path);
      print('dirname: $dirname');
      if (isDir == true) {
        _items.add({'name': dirname, 'path': entity.path});
      }
    }

    _items.sort((a, b) => compareAsciiUpperCase(a['name']!, b['name']!));

    setState(() {
      comicList = _items;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Comic Lists'),
      ),
      body: ListView.builder(
        // Add a key to the ListView. This makes it possible to
        // find the list and scroll through it in the tests.
        key: const Key('long_list'),
        itemCount: comicList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.folder),
            title: Text(
              comicList[index]['name']!,
              // Add a key to the Text widget for each item. This makes
              // it possible to look for a particular item in the list
              // and verify that the text is correct
              key: Key('item_${index}_text'),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/chapterList/${comicList[index]["name"]}',
              );
            },
          );
        },
      ),
    );
  }
}
