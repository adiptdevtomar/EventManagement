import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:game_task/globals.dart' as globals;

import 'ResultPage.dart';

class PlayGame extends StatefulWidget {
  @override
  _PlayGameState createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> with TickerProviderStateMixin {

  bool checkAns = false;
  Color col = Colors.black;
  AnimationController controller;
  var active = 0;
  bool leavePressed = false;
  String val;
  Map details;
  bool isLoading = true;
  var email;
  TextEditingController _controller = TextEditingController();

  _removeMatch() async {
    await Firestore.instance
        .collection("AllMatches")
        .document(globals.docID)
        .delete()
        .whenComplete(() {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  _disDialog() async {
    await Future.delayed(Duration(milliseconds: 1));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text("Sorry! The Other Player has left the Game"),
            actions: <Widget>[
              FlatButton(
                child: Text("Return"),
                onPressed: () {
                  _removeMatch();
                },
              )
            ],
          );
        });
  }

  _guessTrue() async {
    await Firestore.instance
        .collection("AllMatches")
        .document(globals.docID)
        .updateData({"Guess${globals.playerNo}": true}).whenComplete(() {
      _getScore();
    });
  }

  _newScore() async {
    await Firestore.instance
        .collection("AllScore")
        .document(globals.winner + globals.code)
        .setData({"Score": 1}).whenComplete(() {
          setState(() {
            checkAns = false;
          });
      Navigator.of(context).popAndPushNamed("/ResultPage");
    });
  }

  _increaseScore() async {
    await Firestore.instance
        .collection("AllScore")
        .document(globals.winner + globals.code)
        .updateData({"Score": FieldValue.increment(1)}).whenComplete(() {
          setState(() {
            checkAns = false;
          });
      Navigator.of(context).popAndPushNamed("/ResultPage");
    });
  }

  _getScore() async {
    DocumentSnapshot snap = await Firestore.instance
        .collection("AllScore")
        .document(globals.winner + globals.code)
        .get();
    if (!snap.exists) {
      _newScore();
    } else {
      _increaseScore();
    }
  }

  _checkAns() {
    setState(() {
      checkAns = true;
      col = Colors.black;
    });
    if (details["${globals.toGuess}"] == _controller.text) {
      globals.winner = globals.emailID;
      _guessTrue();
    } else {
      setState(() {
        col = Colors.red;
        checkAns = false;
      });
      controller.forward(from: 0.0);
    }
  }

  _fetchDetails() async {
    var lol;
    lol = await Firestore.instance
        .collection("AllMatches")
        .document(globals.docID)
        .get();
    if (globals.playerNo == 2) {
      active = 1;
    } else {
      active = 2;
    }
    email = lol["Email$active"];

    await Firestore.instance
        .collection("ReadyGame")
        .document(email)
        .get()
        .then((onValue) {
      details = onValue.data;
      globals.guess = details["${globals.toGuess}"];
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  _createScore() async {
    await Firestore.instance
        .collection("AllScore")
        .document(globals.winner + globals.code)
        .setData({"Score": 0}).whenComplete(() {
      Navigator.of(context).popAndPushNamed("/ResultPage");
    });
  }

  _zeroScore() async {
    DocumentSnapshot snap = await Firestore.instance
        .collection("AllScore")
        .document(globals.winner + globals.code)
        .get();
    if (!snap.exists) {
      _createScore();
    } else {
      Navigator.of(context).popAndPushNamed("/ResultPage");
    }
  }

  _removePlayer() async {
    await Firestore.instance
        .collection("AllMatches")
        .document(globals.docID)
        .delete();
  }

  _shDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text("Are you sure you want to leave?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  _removePlayer();
                },
              ),
              FlatButton(
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  setState(() {
                    leavePressed = false;
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _fetchDetails();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 30.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {},
      child: Stack(
        children: <Widget>[
          Image.asset(
            "assets/images/back.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Center(
                child: CountdownFormatted(
                  duration: Duration(minutes: 2),
                  onFinish: () {
                    globals.winner = "-1-1";
                    Navigator.of(context).popAndPushNamed("/ResultPage");
                  },
                  builder: (BuildContext context, String remaining) {
                    return Text(
                      "Time : $remaining",
                      style:
                          TextStyle(fontSize: 20.0, color: Colors.deepOrange),
                    );
                  },
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Center(
                    child: InkWell(
                      child: Text(
                        "Leave?",
                        style:
                            TextStyle(fontSize: 17.0, color: Colors.deepOrange),
                      ),
                      onTap: () {
                        _shDialog();
                        setState(() {
                          leavePressed = true;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
            body: (isLoading)
                ? Center(
                    child: SpinKitWave(
                      size: 15.0,
                      color: Colors.black,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.86,
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Player Card",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 25.0),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: globals.keys.length,
                              itemBuilder: (context, index) {
                                if (globals.toGuess == globals.keys[index]) {
                                  return Container();
                                } else {
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text("${globals.keys[index]} - ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18.0)),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                                "${details["${globals.keys[index]}"]}",
                                                style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 16.0)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Align(
                                child: Text(
                                  "${globals.toGuess} - ",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                alignment: Alignment.centerLeft),
                            SizedBox(
                              height: 10.0,
                            ),
                            AnimatedBuilder(
                                animation: offsetAnimation,
                                builder: (buildContext, child) {
                                  if (offsetAnimation.value < 0.0) print("");
                                  return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30.0),
                                    padding: EdgeInsets.only(
                                        left: offsetAnimation.value + 30.0,
                                        right: 30.0 - offsetAnimation.value),
                                    child: Center(
                                        child: TextField(
                                      autofocus: false,
                                      controller: _controller,
                                      decoration: InputDecoration(
                                          hintText: "Your Guess",
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: col)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                            color: col,
                                          ))),
                                    )),
                                  );
                                }),
                            SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                  padding: EdgeInsets.all(0.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  //color: Color(0XFF71D59D),
                                  onPressed: () {
                                    setState(() {
                                      checkAns = true;
                                    });
                                    FocusScope.of(context).unfocus();
                                    _checkAns();
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        gradient: LinearGradient(colors: [
                                          Color(0xFFf45d27),
                                          Color(0xFFf5851f)
                                        ])),
                                    child: (checkAns)?SizedBox(
                                      height: 30.0,
                                      width: 45.0,
                                      child: SpinKitWave(
                                        size: 15.0,
                                        color: Colors.white,
                                      ),
                                    ):Center(
                                      child: Text(
                                        "Submit!",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            (leavePressed)
                                ? Text("")
                                : Container(
                                    child: StreamBuilder(
                                      stream: Firestore.instance
                                          .collection("AllMatches")
                                          .document(globals.docID)
                                          .snapshots(),
                                      builder: (context, snapshots) {
                                        if (!snapshots.hasData) {
                                          return Text("");
                                        } else {
                                          DocumentSnapshot ds = snapshots.data;
                                          if (ds.exists) {
                                          } else {
                                            leavePressed = true;
                                            _disDialog();
                                          }
                                          return Text("");
                                        }
                                      },
                                    ),
                                  ),
                            StreamBuilder(
                              stream: Firestore.instance
                                  .collection("AllMatches")
                                  .snapshots(),
                              builder: (context, snapshots) {
                                if (!snapshots.hasData) {
                                  return Text("");
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshots.data.documents.length,
                                    itemBuilder: (context, index) {
                                      var doc = snapshots.data.documents[index];
                                      if (doc["Guess$active"] == true) {
                                        globals.winner = email;
                                        _zeroScore();
                                        return Text(
                                          "",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        return Text("");
                                      }
                                    },
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
