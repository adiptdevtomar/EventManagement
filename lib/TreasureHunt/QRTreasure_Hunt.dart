import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qrscan/qrscan.dart' as Scanner;
import 'package:flutter/material.dart';
import 'package:game_task/globals.dart' as globals;

class QRTreasureHunt extends StatefulWidget {
  @override
  _QRTreasureHuntState createState() => _QRTreasureHuntState();
}

class _QRTreasureHuntState extends State<QRTreasureHunt> {

  bool updateLeaderBoard = false;
  List<String> lst = [];
  String _timeToDisplay = "00:00:00";
  var type = 0;
  var swatch = Stopwatch();
  final dur = Duration(seconds: 0);
  var currentIndex;

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

  _getType() async {
    var snap = await Firestore.instance
        .collection("TreasureHuntGame")
        .document(globals.code)
        .get();
    if (snap.data["Type"] == "QRGame") {
      setState(() {
        type = 1;
      });
    } else {
      setState(() {
        type = 2;
      });
    }
  }

  _getGame() async {
    await Firestore.instance
        .collection("TreasureHuntGame")
        .document(globals.code)
        .collection("Questions")
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        lst.add(element.data["Q"]);
      });
    }).whenComplete(() {
      _getType();
    });
  }

  void _showDialog(title){
   showDialog(
     context: context,
     builder: (BuildContext context){
       return AlertDialog(
         title: Text(title),
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(10.0),
         ),
         actions: <Widget>[
           (title == "Correct")?FlatButton(
             onPressed: (){
               setState(() {
                 currentIndex+=1;
               });
               Navigator.pop(context);
             },
             child: Row(
               children: <Widget>[
                 Text("NextQuestions",style: TextStyle(color: Colors.orange),),
               ],
             ),
           ):FlatButton(
             onPressed: (){
               Navigator.pop(context);
             },
             child: Text("Return",style: TextStyle(color: Colors.orange),),
           )
         ],
       );
     }
   );
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
      setState(() {
      });
      swatch.reset();
      Navigator.of(context).popAndPushNamed('/winner');
    });
  }

  _scan() async {
    await Scanner.scan().then((result) {
      if(result == lst[currentIndex]){
        if(currentIndex == lst.length-1){
          setState(() {
            updateLeaderBoard = true;
          });
          _addToLeaderBoard();
        }
        else{
          _showDialog("Correct");
        }
      }
      else{
        _showDialog("Incorrect");
      }
    });
  }

  @override
  void initState() {
    currentIndex = 0;
    _getGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (type == 0) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: SpinKitWave(
              size: 13.0,
              color: Colors.black,
            ),
          ),
        ),
      );
    }
    if (type == 1) {
      startStopWatch();
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              _timeToDisplay,
              style: TextStyle(color: Colors.orange),
            ),
            centerTitle: true,
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: <Widget>[
                  Text(
                    "Question${currentIndex + 1}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(lst[currentIndex],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 23.0)),
                  ),
                  Spacer(),
                  Container(
                    height: 60.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                            colors: [Color(0xFFf45d27), Color(0xFFf5851f)])),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                          child: updateLeaderBoard?SpinKitWave(color: Colors.black,size: 13.0,):Text(
                        "Scan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      onPressed: (){
                        _scan();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    if (type == 2) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Text("2"),
          ),
        ),
      );
    }
  }
}
