import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../pages/edit_todo.dart';
import '../../scoped_models/scoped_todo.dart';

class TodoCard extends StatefulWidget {
  final int index;
  TodoCard(this.index);

  @override
  State<StatefulWidget> createState() {
    return _TodoCard();
  }
}

class _TodoCard extends State<TodoCard> {
  Color cardColor;
  double cardElevation;
  Color color = Colors.grey;

  void _setVariables(ScopedTodo model) {
    if (model.allTodos[widget.index].isDone == 1) {
      cardColor = Colors.black12;
      cardElevation = 0.0;
    } else {
      cardColor = Colors.white;
      cardElevation = 5.0;
    }

    int priority = model.allTodos[widget.index].priority;
    switch (priority) {
      case 1:
        color = Colors.red;
        break;
      case 2:
        color = Colors.yellow;
        break;
      case 3:
        color = Colors.green;
        break;

      default:
        color = Colors.grey;
        break;
    }
  }

  Widget _buildCard(ScopedTodo model, int index) {
    return GestureDetector(
      onLongPress: () {
        if (model.allTodos[index].isDone != 1) {
          model.setEdit(true);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => EditTodo(index: index),
            ),
          ).then((_) {
            model.setEdit(false);
          });
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0), topLeft: Radius.circular(8.0)),
        ),
        color: cardColor,
        elevation: cardElevation,
        child: Container(
          height: 100.0,
          child: Row(
            children: <Widget>[
              _buildColorBar(),
              _buildCheckBox(model),
              _buildCardTitle(model, index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.0), topLeft: Radius.circular(8.0)),
        color: color,
      ),
      height: 100.0,
      width: 22.0,
      margin: EdgeInsets.only(left: 0.0),
    );
  }

  Widget _buildCheckBox(ScopedTodo model) {
    return Transform.scale(
      scale: 1.5,
      child: Checkbox(
        activeColor: color,
        value: model.allTodos[widget.index].isDone == 1 ? true : false,
        onChanged: (bool) {
          model.selectTodo(widget.index);
          model.onCheck().then((_) {
            _setVariables(model);
            model.getDatas();
          });
        },
      ),
    );
  }

  Widget _buildCardTitle(ScopedTodo model, int index) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 34.0, 10.0, 20.0),

        //width: 200.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            model.allTodos[index].isDone == 0
                ? Flexible(
                    child: Text(
                      model.allTodos[index].title,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                  )
                : Flexible(
                    child: Text(
                      model.allTodos[index].title,
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
            SizedBox(
              height: 8.0,
            ),
            Text(model.allTodos[index].date)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedTodo>(
      builder: (BuildContext context, Widget child, ScopedTodo model) {
        _setVariables(model);
        return _buildCard(model, widget.index);
      },
    );
  }
}
