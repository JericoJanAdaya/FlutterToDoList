// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<String> _todoList = <String>[];
  final TextEditingController _textFieldController = TextEditingController();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        centerTitle: true,
      ),
      body: ListView(children: _getItems()),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }

  void _addTodoItem(String title) {
    setState(() {
      _todoList.add(title);
    });
    _textFieldController.clear();
  }

  void _removeTodoItem(String title) {
    setState(() {
      _todoList.remove(title);
    });
    _textFieldController.clear();
  }

  void _replaceTodoItem(String title) {
    setState(() {
      int range = _todoList.indexOf(title);
      _todoList.replaceRange(range, range + 1, [_textFieldController.text]);
    });
    _textFieldController.clear();
  }

  void _toggleDone() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  Widget _buildTodoItem(BuildContext context, title) {
    return ListTile(
        onTap: () {
          _toggleDone();
        },
        title: Text(
          title,
          style: TextStyle(
            decoration: isChecked ? TextDecoration.lineThrough : null,
          ),
        ),
        leading: Checkbox(
          value: isChecked,
          onChanged: (bool? checkBoxState) {
            _toggleDone();
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _displayChange(context, title),
              icon: Icon(
                Icons.edit_sharp,
                color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                _removeTodoItem(title);
                isChecked ? _toggleDone() : null;
              },
              icon: Icon(
                Icons.delete_forever_outlined,
                color: Colors.grey,
              ),
            ),
          ],
        ));
  }

  Future<void> _displayChange(BuildContext context, title) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Change task'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Change'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _replaceTodoItem(title);
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _textFieldController.clear();
                },
              )
            ],
          );
        });
  }

  Future<void> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add a task to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Add'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _textFieldController.clear();
                },
              )
            ],
          );
        });
  }

  List<Widget> _getItems() {
    final List<Widget> todoWidgets = <Widget>[];
    for (String title in _todoList) {
      todoWidgets.add(_buildTodoItem(context, title));
    }
    return todoWidgets;
  }
}
