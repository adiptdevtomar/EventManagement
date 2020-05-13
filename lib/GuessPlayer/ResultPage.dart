import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_task/globals.dart' as globals;

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  int winner = 0;

  _getWinner() {
    if (globals.winner == globals.emailID) {
      setState(() {
        winner = 1;
      });
    } else {
      setState(() {
        winner = 2;
      });
    }
  }

  AnimationController anim;
  Animation animation;

  @override
  void initState() {
    anim = AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = Tween(end: 6.0, begin: 1.0).animate(anim)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          anim.reverse();
        } else if (status == AnimationStatus.dismissed) {
          anim.forward();
        }
      });
    anim.forward();
    _getWinner();
    super.initState();
  }

  _deleteGame() async {
    await Firestore.instance
        .collection("AllMatches")
        .document(globals.docID)
        .delete()
        .whenComplete(() {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (winner == 0) {
      return Scaffold(
        body: Container(
          child: Center(
            child: Text("lol"),
          ),
        ),
      );
    }
    if (winner == 1) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Container(
              child: Center(
                  child: Column(
            children: <Widget>[
              Container(
                height: 300.0,
                width: 200.0,
                child: Center(
                  child: Transform.scale(
                      scale: animation.value,
                      child: Text(
                        "You Win",
                        style: TextStyle(color: Colors.black),
                      )),
                ),
              ),
              RaisedButton(
                child: Text("Return"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ))));
    }
    if (winner == 2) {
      return Scaffold(
        body: Center(
          child: Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Text("You Lost"),
                Text("${globals.winner}"),
                RaisedButton(
                  child: Text("Return"),
                  onPressed: () {
                    _deleteGame();
                  },
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
