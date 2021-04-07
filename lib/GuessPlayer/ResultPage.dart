import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task/globals.dart' as globals;

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool hasScore = false;
  var winner = 0;
  var score;

  _getWinner() {
    if (globals.winner == globals.emailID) {
      setState(() {
        winner = 1;
      });
      _getScore();
    } else {
      if (globals.winner == "-1-1"){
        setState(() {
          winner = 3;
          hasScore = true;
        });
      }
      else{
        setState(() {
          winner = 2;
        });
        _getScore();
      }
    }
  }

  _getScore() async {
    await Firestore.instance
        .collection("GGScore")
        .document(globals.winner + globals.code)
        .get()
        .then((value) {
          setState(() {
            score = value.data["Score"];
          });
    }).whenComplete(() {
      setState(() {
        hasScore = true;
      });
    });
  }

  @override
  void initState() {
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
  Widget build(BuildContext context) {
    if (winner == 0) {
      return Scaffold(
        body: Container(
          child: Center(
            child: Text(""),
          ),
        ),
      );
    }
    if (winner == 1) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          body: (hasScore == true)
              ? Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset("assets/images/winner.png"),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Your Score : $score",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25.0),
                              ),
                              SizedBox(height: 10.0,),
                              FlatButton(
                                padding: EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0)),
                                //color: Color(0XFF71D59D),
                                onPressed: () {
                                  Navigator.of(context).popAndPushNamed('/findPlayer');
                                },
                                child: Container(
                                    padding:
                                    EdgeInsets.fromLTRB(55.0, 15.0, 55.0, 15.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60.0),
                                        gradient: LinearGradient(colors: [
                                          Color(0xFFf45d27),
                                          Color(0xFFf5851f)
                                        ])),
                                    child: Text(
                                      "Play Again",
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.white),
                                    )),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).pop();
                                },
                                child: Text("Return?",style: TextStyle(
                                    fontSize: 17.0,
                                    color: Colors.deepOrangeAccent
                                ),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: SpinKitWave(
                    color: Colors.black,
                    size: 18.0,
                  ),
                ));
    }
    if (winner == 2) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          body: (hasScore == true)
              ? Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset("assets/images/loser.png"),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Your Score : $score",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25.0),
                        ),
                        Text("Correct Answer : ${globals.guess}"),
                        SizedBox(height: 10.0,),
                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60.0)),
                          //color: Color(0XFF71D59D),
                          onPressed: () {
                            Navigator.of(context).popAndPushNamed('/findPlayer');
                          },
                          child: Container(
                              padding:
                              EdgeInsets.fromLTRB(55.0, 15.0, 55.0, 15.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60.0),
                                  gradient: LinearGradient(colors: [
                                    Color(0xFFf45d27),
                                    Color(0xFFf5851f)
                                  ])),
                              child: Text(
                                "Play Again",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              )),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Text("Return?",style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.deepOrangeAccent
                          ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
              : Center(
            child: SpinKitWave(
              color: Colors.black,
              size: 18.0,
            ),
          ));
    }
    if (winner == 3) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          body: (hasScore == true)
              ? Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset("assets/images/loser.png"),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Time's Up!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25.0),
                        ),
                        Text("Correct Answer : ${globals.guess}"),
                        SizedBox(height: 10.0,),
                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60.0)),
                          onPressed: () {
                            Navigator.of(context).popAndPushNamed('/findPlayer');
                          },
                          child: Container(
                              padding:
                              EdgeInsets.fromLTRB(55.0, 15.0, 55.0, 15.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60.0),
                                  gradient: LinearGradient(colors: [
                                    Color(0xFFf45d27),
                                    Color(0xFFf5851f)
                                  ])),
                              child: Text(
                                "Play Again",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              )),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Text("Return?",style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.deepOrangeAccent
                          ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
              : Center(
            child: SpinKitWave(
              color: Colors.black,
              size: 18.0,
            ),
          ));
    }
  }
}
