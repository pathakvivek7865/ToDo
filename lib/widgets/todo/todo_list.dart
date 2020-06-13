import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/scoped_todo.dart';
import '../../widgets/todo/todo_card.dart';

const String testDevice = 'E6E0A298E3FE01531B1273B580B9D8F6';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodoListState();
  }
}

class _TodoListState extends State<TodoList> {
  // static final MobileAdTargetingInfo adTargetingInfo = MobileAdTargetingInfo(
  //   testDevices: <String>[testDevice],
  //   keywords: <String>['todo', 'todos', 'list', 'check', 'checklist', 'nice', 'app', 'beautiful'],
  // );

  // BannerAd _bannerAd;

  // BannerAd createBannerAd() {
  //   return BannerAd(
  //       adUnitId: 'ca-app-pub-3749770504472376/4875745010',
  //       size: AdSize.banner,
  //       targetingInfo: adTargetingInfo,
  //       listener: (MobileAdEvent event) {
  //         print("BannerAd event $event");
  //       });
  // }

  Widget _buildDismissible(BuildContext context, ScopedTodo model, int index) {
    return Dismissible(
      key: Key(model.allTodos[index].id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection direction) {
        myOnDismissed(direction, context, model, index);
      },
      background: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8.0),
                  topRight: Radius.circular(8.0)),
              color: Colors.red,
            ),
            padding: EdgeInsets.only(right: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.delete_sweep, color: Colors.white),
                ),
                Text(
                  "Remove",
                  style: TextStyle(color: Colors.white),
                )
              ],
            )),
      ),
      child: TodoCard(index),
    );
  }

  void myOnDismissed(DismissDirection direction, BuildContext context,
      ScopedTodo model, int index) {
    if (direction == DismissDirection.endToStart) {
      Scaffold.of(context).hideCurrentSnackBar();
      model.selectTodo(model.allTodos[index].id);
      model.deleteTodo().then((_) {
        model.getDatas();
      });

      Scaffold.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text("One Item Removed"),
          action: SnackBarAction(
            label: '',
            onPressed: () {},
          ),
        ),
      );
    } else {}
  }

  @override
  void initState() {
    super.initState();

    // FirebaseAdMob.instance
    //     .initialize(appId: 'ca-app-pub-3749770504472376~2632725054');

    // _bannerAd ??= createBannerAd();
    // _bannerAd
    //   ..load()
    //   ..show();
  }

  @override
  void dispose() {
    // _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedTodo>(
      builder: (BuildContext context, Widget child, ScopedTodo model) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 0.0),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            itemCount: model.allTodos.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildDismissible(context, model, index);
            },
          ),
        );
      },
    );
  }
}
