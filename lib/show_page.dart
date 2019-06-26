import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_page.dart';

class ShowPage extends StatelessWidget {
  // This widget is the root of your application.
  void _incrementCounter(BuildContext context) {
    Navigator.pushNamed(context, '/add');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo app')),
      body: Center(
        child: _TodoListView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(context),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), //
    );
  }
}

class _TodoListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoList();
}

class _TodoList extends State<_TodoListView> {
  List<String> texts;

  Future<List<String>> _getPrefTodo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList("todos"));
  }

  Widget _showDialog(BuildContext context, String title, int index) {
    List<Widget> actions = List();
    actions.add(FlatButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    ));
    actions.add(FlatButton(
      child: Text("OK"),
      onPressed: () {
        _deleteTodo(index);
        Navigator.pop(context, true);
      },
    ));
    return AlertDialog(
      title: Text("削除"),
      content: Text("「${title}」を削除しますか?"),
      actions: actions,
    );
  }

  _deleteTodo(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    texts.removeAt(index);
    prefs.setStringList("todos", texts);
  }

  @override
  Widget build(BuildContext context) {
    _getPrefTodo().then((value) {
      setState(() {
        texts = value ?? List();
      });
    });
    return ListView.builder(
      itemCount: texts.length,
      itemBuilder: (context, int i) {
        return new GestureDetector(
            onTap: () => {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new AddPage(index: i),
                      ))
                },
            onLongPress: () => {
                  showDialog(
                    context: context,
                    builder: (_) => _showDialog(context, texts[i], i),
                  )
                },
            child: new Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(texts[i]),
              ),
            ));
      },
    );
  }
}
