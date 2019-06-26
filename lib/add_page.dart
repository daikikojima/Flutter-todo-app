import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPage extends StatelessWidget {
  int index;

  AddPage({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Todo app')),
      body: TodoForm(index),
    );
  }
}

class TodoForm extends StatefulWidget {
  int index;

  TodoForm(this.index);

  @override
  State<StatefulWidget> createState() => _TodoFormState(index);
}

class _TodoFormState extends State<TodoForm> {
  final todoTextController = TextEditingController();
  int index;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _formKey = GlobalKey<FormState>();

  _TodoFormState(this.index);

  @override
  void initState() {
    super.initState();
    if (index != -1) {
      _setText();
    }
  }

  Future<void> _setText() async {
    final prefs = await _prefs;
    List<String> texts = prefs.getStringList("todos") ?? [];
    setState(() {
      todoTextController.text = texts[index];
    });
  }

  Future<void> _addTodo(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      final prefs = await _prefs;
      List<String> texts = prefs.getStringList("todos") ?? [];
      final _text = todoTextController.text;
      if (index == -1) {
        texts.add(_text);
      } else {
        texts[index] = _text;
      }

      prefs.setStringList("todos", texts);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    todoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'ここにToDoを記入'),
              controller: todoTextController,
              validator: (value) {
                if (value.isEmpty) {
                  return '文字を入力してください';
                }
                return null;
              },
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              color: Colors.deepOrangeAccent,
              onPressed: () => _addTodo(context),
              child: Text("登録"),
            )
          ],
        ),
      ),
    );
  }
}
