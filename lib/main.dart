import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/home_page.dart';
import './scoped_models/scoped_todo.dart';
import './pages/edit_todo.dart';

bool isConnected;

void main() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      isConnected = true;
    }
  } on SocketException catch (_) {
    print('not connected');
    isConnected = false;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScopedTodo model = ScopedTodo();
    return ScopedModel(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        routes: {
          '/': (BuildContext context) => HomePage(),
          'editTodo': (BuildContext context) => EditTodo(),
        },
        builder: (BuildContext context, Widget child) {
          return Padding(
            child: child,
            padding: isConnected
                ? EdgeInsets.only(bottom: 50.0)
                : EdgeInsets.only(bottom: 0.0),
          );
        },
      ),
    );
  }
}
