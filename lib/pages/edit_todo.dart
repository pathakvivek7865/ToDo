import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import '../scoped_models/scoped_todo.dart';
import '../models/todo.dart';

class EditTodo extends StatefulWidget {
  final int index;

  EditTodo({this.index});

  @override
  State<StatefulWidget> createState() {
    return _AddTodo();
  }
}

class _AddTodo extends State<EditTodo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _priorities = ["High", "Medium", "Low"];
  String _priority = "Low";

  Map<String, dynamic> _formData = {
    'title': '',
    'priority': 3,
    'date': DateFormat.yMd().format(DateTime.now()).toString(),
    'isDone': 0
  };

  Widget _buildTitleTextField(ScopedTodo model) {
    return TextFormField(
      initialValue:
          model.isEdit ? model.allTodos[widget.index].title.toString() : '',
      autofocus: true,
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: 'Title',
        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
      ),
      maxLength: 30,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Title cannot be null';
        }

        if (value.length > 30) {
          return 'Max length for title is 30.';
        }

        else return null;
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildPriorityDropDown(ScopedTodo model) {
    return DropdownButton<String>(
      items: _priorities.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: _priority,
      onChanged: (value) => updatePriority(value),
    );
  }

  void updatePriority(String value) {
    switch (value) {
      case 'High':
        setState(() {
          _formData["priority"] = 1;
        });
        break;
      case 'Medium':
        setState(() {
          _formData["priority"] = 2;
        });
        break;
      case 'Low':
        setState(() {
          _formData["priority"] = 3;
        });
        break;
    }

    setState(() {
      _priority = value;
    });
  }

  Widget _buildAddButton(ScopedTodo model) {
    return ScopedModelDescendant<ScopedTodo>(
        builder: (BuildContext context, Widget child, ScopedTodo model) {
      return Container(
        height: 50.0,
        margin: EdgeInsets.only(top: 16.0),
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          child: model.isEdit
              ? Text("UPDATE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0
                  ))
              : Text("ADD",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0
                  )),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              if (model.isEdit == true) {
                Todo todo = Todo.withId(
                    model.allTodos[widget.index].id,
                    _formData["title"],
                    _formData["priority"],
                    _formData["date"],
                    _formData["isDone"]);
                model.updateTodo(todo).then((_) {
                  Navigator.pop(context);
                });
              } else {
                Todo todo = Todo(_formData["title"], _formData["priority"],
                    _formData["date"], _formData["isDone"]);
                model.addTodo(todo).then((_) {
                  Navigator.pop(context);
                });
              }
            }
          },
        ),
      );
    });
  }

  Widget _buildAddForm() {
    return ScopedModelDescendant<ScopedTodo>(
      builder: (BuildContext context, Widget child, ScopedTodo model) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _buildTitleTextField(model),
                _buildPriorityDropDown(model),
                _buildAddButton(model),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedTodo>(
      builder: (BuildContext context, Widget child, ScopedTodo model) {
        return Scaffold(
          appBar: AppBar(
            title: model.isEdit
                ? Text(
                    "Edit Todo",
                    style: TextStyle(fontSize: 30.0, color: Colors.white),
                  )
                : Text(
                    "Add Todo",
                    style: TextStyle(fontSize: 30.0, color: Colors.white),
                  ),
            centerTitle: true,
          ),
          body: _buildAddForm(),
        );
      },
    );
  }
}
