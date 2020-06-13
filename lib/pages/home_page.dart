import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/scoped_todo.dart';
import '../widgets/todo/todo_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedTodo>(
        builder: (BuildContext context, Widget child, ScopedTodo model) {
      if (model.allTodos.length < 1) {
        model.getDatas();
      }
      return Scaffold(
        backgroundColor: Colors.white,
        //drawer: _buildDrawer(),
        appBar: AppBar(
          title: Text(
            "ToDo",
            style: TextStyle(fontSize: 30.0, color: Colors.white),
          ),
          centerTitle: true,
          
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey.withOpacity(0.2),
          child: TodoList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, 'editTodo');
            }),
      );
    });
  }
}
