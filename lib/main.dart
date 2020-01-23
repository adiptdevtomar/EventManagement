import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_task/GSignIn.dart';
import 'package:game_task/Test.dart';
import 'package:game_task/event_lister.dart';
import 'package:game_task/sign_in_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'CodeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _name;
  @override
  void initState()
  {
    FirebaseAuth.instance.currentUser().then((user){
      _name = user.displayName;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.indigo),
      home: SignInTest(),
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => CodePage(name: _name),
        '/c': (BuildContext context) => GSignIn()
      },
    );
  }
}
