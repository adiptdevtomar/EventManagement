import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task/globals.dart' as globals;
import 'package:video_player/video_player.dart';

class PlayGameGG extends StatefulWidget {
  @override
  _PlayGameGGState createState() => _PlayGameGGState();
}

class _PlayGameGGState extends State<PlayGameGG> with TickerProviderStateMixin {
  bool hasNames = false;
  var name1;
  var name2;
  var email1;
  var email2;
  bool hasGuessed = false;
  bool hasDetails = false;
  AnimationController controller;
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;
  var gameID;
  var _details;
  TextEditingController textController = TextEditingController();
  var col = Colors.black;

  _increaseScore() async {
    await Firestore.instance
        .collection("GGVideoNames")
        .document(globals.emailID + globals.code)
        .updateData({"Score": FieldValue.increment(1)}).whenComplete(() {
      setState(() {
        hasGuessed = false;
      });
      globals.gWinner = 1;
      Navigator.of(context).popAndPushNamed("/Result");
    });
  }

  _navigate() async {
    await Future.delayed(Duration(milliseconds: 1)).whenComplete(() {
      Navigator.of(context).popAndPushNamed("/Result");
    });
  }

  _updateGuess() async {
    await Firestore.instance
        .collection("GGMatches")
        .document(globals.docID)
        .updateData({"Guess${globals.playerNo}": false}).whenComplete(() {
      _increaseScore();
    });
  }

  _getVideo(url) {
    _videoPlayerController = VideoPlayerController.network(url);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    _videoPlayerController.play();
  }

  _getAudioImage() async {
    await Firestore.instance
        .collection("GGMatches")
        .document(globals.docID)
        .get()
        .then((value) {
      gameID = value.data["QuesID"];
    });
    _details = await Firestore.instance
        .collection("AudioVideo")
        .document(gameID)
        .get()
        .whenComplete(() {
      setState(() {
        hasDetails = true;
      });
    });
    globals.guess = _details["A"];
    if (_details["Type"] == "Videos") {
      _getVideo(_details["Url"]);
    }
  }

  _getNames() async {
    await Firestore.instance
        .collection("GGVideoNames")
        .document(email1 + globals.code)
        .get()
        .then((value) {
      name1 = value.data["Name"];
    });
    await Firestore.instance
        .collection("GGVideoNames")
        .document(email2 + globals.code)
        .get()
        .then((value) {
      name2 = value.data["Name"];
    }).whenComplete(() {
      setState(() {
        hasNames = true;
      });
    });
  }

  _getEmail() async {
    await Firestore.instance
        .collection("GGMatches")
        .document(globals.docID)
        .get()
        .then((value) {
      email1 = value.data["Email1"];
      email2 = value.data["Email2"];
    }).whenComplete(() {
      _getNames();
    });
  }

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _getEmail();
    _getAudioImage();
    super.initState();
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
      onWillPop: () {
        return null;
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: <Widget>[],
              title: Center(
                child: CountdownFormatted(
                  duration: Duration(seconds: 60),
                  onFinish: () {
                    globals.gWinner = 3;
                    Navigator.of(context).popAndPushNamed("/Result");
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
              backgroundColor: Colors.black,
              elevation: 0.0,
            ),
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.88,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      (hasNames)
                          ? Text(
                              "$name1 vs $name2",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            )
                          : SpinKitWave(
                              size: 13.0,
                              color: Colors.white,
                            ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(width: 2, color: Colors.deepOrange),
                            borderRadius: BorderRadius.circular(10.0)),
                        height: MediaQuery.of(context).size.height * 0.77,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: (hasDetails)
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  AutoSizeText(
                                    "" + _details["Q"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 3,
                                  ),
                                  SizedBox(height: 20.0),
                                  (_details["Type"] == "Images")
                                      ? Image.network(
                                          _details["Url"],
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null)
                                              return Center(
                                                child: ConstrainedBox(
                                                  child: child,
                                                  constraints: BoxConstraints(
                                                      maxHeight:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.4),
                                                ),
                                              );
                                            return Center(
                                              child: Container(
                                                height: 100.0,
                                                width: 100.0,
                                                child: Center(
                                                  child: SpinKitWave(
                                                    size: 20.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Text(""),
                                  (_details["Type"] == "Videos")
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          child: FutureBuilder(
                                            future:
                                                _initializeVideoPlayerFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                return AspectRatio(
                                                  aspectRatio:
                                                      _videoPlayerController
                                                          .value.aspectRatio,
                                                  child: VideoPlayer(
                                                      _videoPlayerController),
                                                );
                                              } else {
                                                return SpinKitWave(
                                                  color: Colors.black,
                                                  size: 15.0,
                                                );
                                              }
                                            },
                                          ),
                                        )
                                      : Text(""),
                                  Spacer(),
                                  AnimatedBuilder(
                                      animation: offsetAnimation,
                                      builder: (buildContext, child) {
                                        if (offsetAnimation.value < 0.0)
                                          print("");
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 30.0),
                                          padding: EdgeInsets.only(
                                              left:
                                                  offsetAnimation.value + 30.0,
                                              right:
                                                  30.0 - offsetAnimation.value),
                                          child: Center(
                                              child: TextField(
                                            autofocus: false,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: col)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                  color: col,
                                                ))),
                                            controller: textController,
                                          )),
                                        );
                                      }),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  FlatButton(
                                    padding: EdgeInsets.all(0.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    onPressed: () {
                                      if (textController.text !=
                                          _details["A"]) {
                                        setState(() {
                                          col = Colors.red;
                                        });
                                        controller.forward(from: 0.0);
                                      } else {
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        setState(() {
                                          col = Colors.black;
                                        });
                                        setState(() {
                                          hasGuessed = true;
                                        });
                                        _updateGuess();
                                      }
                                    },
                                    child: Container(
                                      width: 130.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          gradient: LinearGradient(colors: [
                                            Color(0xFFf45d27),
                                            Color(0xFFf5851f)
                                          ])),
                                      child: Center(
                                        child: (hasGuessed)
                                            ? SpinKitWave(
                                                size: 13.0,
                                                color: Colors.black,
                                              )
                                            : Text(
                                                "Check!",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: SpinKitWave(
                                  color: Colors.black,
                                  size: 13.0,
                                ),
                              ),
                      ),
                      StreamBuilder(
                          stream: Firestore.instance
                              .collection("GGMatches")
                              .document(globals.docID)
                              .snapshots(),
                          builder: (context, snapshots) {
                            if (!snapshots.hasData) {
                              return SizedBox.shrink();
                            } else {
                              if (snapshots.data[
                                      "Guess${(globals.playerNo == 1) ? 2 : 1}"] ==
                                  true) {
                                globals.gWinner = 2;
                                _navigate();
                                return SizedBox.shrink();
                              } else {
                                return SizedBox.shrink();
                              }
                            }
                          })
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
