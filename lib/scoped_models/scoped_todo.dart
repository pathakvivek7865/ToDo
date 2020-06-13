import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import '../models/todo.dart';
import '../utils/database_helper.dart';

class ScopedTodo extends Model {
  List<Todo> _todos = List<Todo>();

  int _selectedTodo;
  bool _isEdit = false;

  DatabaseHelper dbHelper = DatabaseHelper();

  void getDatas() async {
    await dbHelper.db.then((result) async {
      await dbHelper.getTodos().then((result) {
        List<Todo> todos = List<Todo>();

        for (int i = 0; i < result.length; i++) {
          todos.add(Todo.fromObject(result[i]));
        }

        this._todos = todos;
        notifyListeners();
      });
    });
  }

  List<Todo> get allTodos {
    return List.from(_todos);
  }

  int get selectedTodoId {
    return _selectedTodo;
  }

  Todo get selectedTodo {
    return this.allTodos.firstWhere((Todo todo) {
      return todo.id == this.selectedTodoId;
    });
  }

  bool get isEdit {
    return _isEdit;
  }

  void selectTodo(int id) {
    _selectedTodo = id;
  }

  void setEdit(bool value) {
    _isEdit = value;
  }

  Future<Null> addTodo(Todo todo) async {
    await dbHelper.db.then((result) async {
      await dbHelper.insertTodo(todo).then((result) {});
    });
    setEdit(false);
    getDatas();

    notifyListeners();
  }

  Future<Null> deleteTodo() async {
    if (selectedTodoId != null) {
      await dbHelper.db.then((result) async {
        await dbHelper.deleteTodo(selectedTodoId).then((result) {});
      });
    }
    selectTodo(null);
  }

  Future<Null> updateTodo(Todo todo) async {
    await dbHelper.db.then((res) async {
      await dbHelper.updateTodo(todo);
    });
    getDatas();
    setEdit(false);
    notifyListeners();
  }

  Future<Null> onCheck() async {
    if (selectedTodoId != null) {
      Todo todo = Todo.withId(_todos[selectedTodoId].id,
          _todos[selectedTodoId].title, 4, _todos[selectedTodoId].date, 1);

      await dbHelper.db.then((result) async {
        await dbHelper.updateTodo(todo);
      });
    }

    selectTodo(null);
    notifyListeners();
  }

  
}
