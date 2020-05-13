import 'dart:async';

import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task/globals.dart' as globals;

class TreasureHunt extends StatefulWidget {
  @override
  _TreasureHuntState createState() => _TreasureHuntState();
}

class _TreasureHuntState extends State<TreasureHunt>
    with TickerProviderStateMixin {
  AnimationController animCont;
  Animation animation;
  Color col = Colors.black;
  String _timeToDisplay = "00:00:00";
  bool isTapped = false;
  var swatch = Stopwatch();
  final dur = Duration(seconds: 0);
  int _quesNumber = 1;
  final TextEditingController textController = TextEditingController();
  AnimationController controller;

  void startStopWatch() {
    swatch.start();
    starttimer();
  }

  void starttimer() {
    Timer(dur, keeprunning);
  }

  void keeprunning() {
    if (swatch.isRunning) {
      setState(() {
        _timeToDisplay = swatch.elapsed.inHours.toString().padLeft(2, "0") +
            ":" +
            (swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
            ":" +
            (swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
      });
    }
  }

  void _addToLeaderBoard() async {
    var t = _timeToDisplay.split(':');
    var hours = int.parse(t[0]);
    var min = int.parse(t[1]);
    var sec = int.parse(t[2]);
    var ttt = (hours * 60 * 60) + (min * 60) + sec;
    await Firestore.instance.collection("THLeader").add({
      "Name": "${globals.teamName}",
      "EventCode": "${globals.code}",
      "Time": ttt
    }).whenComplete(() {
      swatch.reset();
      isTapped = false;
      Navigator.of(context).popAndPushNamed('/winner');
    });
  }

  void _shDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Text("Are you sure you want to Leave?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  swatch.stop();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context);
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
    animCont = AnimationController(duration: Duration(seconds: 1), vsync: this);
    final curvedAnim = CurvedAnimation(parent: animCont, curve: Curves.easeIn);
    animation = Tween(begin: 0.0, end: math.pi * 2).animate(curvedAnim)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    animCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
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
      onWillPop: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        _shDialog();
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            setState(() {
              col = Colors.black;
            });
          },
          child: Scaffold(
              backgroundColor: Colors.black,
              body: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("TreasureHuntGame")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.9,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Center(
                              child: SpinKitWave(
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot doc =
                                    snapshot.data.documents[index];
                                if (globals.code == doc.documentID) {
                                  startStopWatch();
                                  return SingleChildScrollView(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.95,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            _timeToDisplay,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.deepOrangeAccent),
                                          ),
                                          Transform(
                                            transform: Matrix4.identity()
                                              ..setEntry(3, 2, 0.001)
                                              ..rotateY(-animation.value),
                                            alignment: FractionalOffset.center,
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.77,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(width: 2,color: Colors.deepOrange),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.4,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    child: Center(
                                                      child: Text(
                                                        "${doc["Q$_quesNumber"]}",
                                                        style: TextStyle(
                                                            fontSize: 25.0,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  AnimatedBuilder(
                                                      animation:
                                                          offsetAnimation,
                                                      builder: (buildContext,
                                                          child) {
                                                        if (offsetAnimation
                                                                .value <
                                                            0.0) print("");
                                                        return Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      30.0),
                                                          padding: EdgeInsets.only(
                                                              left: offsetAnimation
                                                                      .value +
                                                                  30.0,
                                                              right: 30.0 -
                                                                  offsetAnimation
                                                                      .value),
                                                          child: Center(
                                                              child: TextField(
                                                            autofocus: false,
                                                            decoration:
                                                                InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    enabledBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color:
                                                                                col)),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                      color:
                                                                          col,
                                                                    ))),
                                                            controller:
                                                                textController,
                                                          )),
                                                        );
                                                      }),
                                                  Column(
                                                    children: <Widget>[
                                                      FlatButton(
                                                        onPressed: () {
                                                          if (textController
                                                                  .text !=
                                                              doc["A$_quesNumber"]) {
                                                            setState(() {
                                                              col = Colors.red;
                                                            });
                                                            controller.forward(
                                                                from: 0.0);
                                                          } else {
                                                            if (!currentFocus
                                                                .hasPrimaryFocus) {
                                                              currentFocus
                                                                  .unfocus();
                                                            }
                                                            if (int.parse(doc[
                                                                    "NumberOfQues"]) >
                                                                _quesNumber) {
                                                              animCont
                                                                  .forward()
                                                                  .whenComplete(
                                                                      () {
                                                                animCont
                                                                    .reset();
                                                              });
                                                              Future.delayed(
                                                                  Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  () {
                                                                setState(() {
                                                                  _quesNumber =
                                                                      _quesNumber +
                                                                          1;
                                                                  col = Colors
                                                                      .black;
                                                                });
                                                              });
                                                            } else {
                                                              if (!currentFocus
                                                                  .hasPrimaryFocus) {
                                                                currentFocus
                                                                    .unfocus();
                                                              }
                                                              isTapped = true;
                                                              swatch.stop();
                                                              _addToLeaderBoard();
                                                            }
                                                          }
                                                        },
                                                        padding:
                                                            EdgeInsets.all(0.0),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0)),
                                                        child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15.0),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                gradient:
                                                                    LinearGradient(
                                                                        colors: [
                                                                      Color(
                                                                          0xFFf45d27),
                                                                      Color(
                                                                          0xFFf5851f)
                                                                    ])),
                                                            child: (!isTapped)
                                                                ? SizedBox(
                                                                    width: 80.0,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Submit',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SizedBox(
                                                                    child:
                                                                        SpinKitWave(
                                                                      size: 14,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    width: 80.0,
                                                                  )),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Center(
                                              child: InkWell(
                                            onTap: () {
                                              if (!currentFocus
                                                  .hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
                                              _shDialog();
                                            },
                                            child: Text(
                                              "Leave Game?",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              });
                        }
                      }),
                ],
              )),
        ),
      ),
    );
  }
}
