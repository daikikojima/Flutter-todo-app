import 'package:flutter/material.dart';
import 'package:todo_aoos/show_page.dart';

import 'add_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShowPage(),
      routes: <String, WidgetBuilder>{
        '/add': (BuildContext context) => new AddPage(index: -1),
      },
    );
  }
}
