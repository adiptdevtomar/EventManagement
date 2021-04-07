import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_task/GSignIn.dart';
import 'package:game_task/GuessPlayer/ResultPage.dart';
import 'package:game_task/GuessPlayer/find_player.dart';
import 'package:game_task/GuessPlayer/playGame.dart';
import 'package:game_task/Image_Video/Choose_Name.dart';
import 'package:game_task/Image_Video/Play_Game.dart';
import 'package:game_task/Image_Video/Results.dart';
import 'package:game_task/Image_Video/ShowDetails.dart';
import 'package:game_task/TreasureHunt/create_team.dart';
import 'package:game_task/TreasureHunt/team_test.dart';
import 'package:game_task/TreasureHunt/WinnerPage.dart';
import 'file:///C:/Users/hp/IdeaProjects/game_task/lib/AboutEvent/event_lister.dart';
import 'package:game_task/sign_in_test.dart';
import 'CodeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primaryColor: Colors.black,
        accentColor: Colors.white,
      ),
      home: SignInTest(),
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => CodePage(),
        '/c': (BuildContext context) => GSignIn(),
        '/d' : (BuildContext context) => drawerapp(),
        '/h' : (BuildContext context) => TeamTest(),
        '/p' : (BuildContext context) => CreateGame(),
        '/playGame' : (BuildContext context) => PlayGame(),
        '/winner' : (BuildContext context) => WinnerPage(),
        '/ResultPage' : (BuildContext context) => ResultPage(),
        '/findPlayer' : (BuildContext context) => FindPlayer(),
        '/ShowDetails' : (BuildContext context) => ShowDetails(),
        '/ChooseName' : (BuildContext context) => ChooseName(),
        '/PlayGameGG' : (BuildContext context) => PlayGameGG(),
        '/Result' : (BuildContext context) => Results()
      },
    );
  }
}
