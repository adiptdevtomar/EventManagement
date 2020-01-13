import 'package:flutter/material.dart';
import 'package:game_task/GSignIn.dart';
import 'package:game_task/Test.dart';
import 'CodeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.indigo),
      home: GSignIn(),
      );
  }
}
