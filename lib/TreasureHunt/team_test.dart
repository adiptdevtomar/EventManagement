import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task/TreasureHunt/has_team.dart';
import 'package:game_task/TreasureHunt/create_team.dart';
import 'package:game_task/globals.dart' as globals;

class TeamTest extends StatefulWidget {
  @override
  _TeamTestState createState() => _TeamTestState();
}

class _TeamTestState extends State<TeamTest> {

  int _hasTeam = 0;

  _hasGame() async {
    await Firestore.instance.collection("TreasureHuntGame").getDocuments().then((onValue){
      onValue.documents.forEach((f){
        if(globals.code == f.documentID){
          _teamCheck();
        }
        else{
          setState(() {
            _hasTeam = 3;
          });
        }
      });
    });
  }
  
  _teamCheck() async {
    await Firestore.instance
        .collection("THTeams")
        .getDocuments()
        .then((onValue) {
      onValue.documents.forEach((f) {
        var l = f["NoOfMembers"];
        for (int i = 1; i <= l; i++) {
          if (f["Player$i"]["Code"] == "${globals.code}" &&
              f["Player$i"]["Email"] == "${globals.emailID}") {
            setState(() {
              globals.teamName = f.documentID;
            });
          }
        }
      });
    });
    if (globals.teamName != null) {
      setState(() {
        _hasTeam = 1;
      });
    }
    else{
      setState(() {
        _hasTeam = 2;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      globals.teamName = null;
    });
    _hasGame();
  }

  @override
  Widget build(BuildContext context) {
    if(_hasTeam == 3){
      return Scaffold(
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("No Game Found",style: TextStyle(fontSize: 24.0),),
                FlatButton(
                  padding: EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  //color: Color(0XFF71D59D),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(colors: [
                          Color(0xFFf45d27),
                          Color(0xFFf5851f)
                        ])),
                    child: Text(
                      "Return",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    if (_hasTeam == 1) {
      return HasTeam();
    }
    if(_hasTeam == 2){
      return CreateGame();
    }
    if(_hasTeam == 0)
    {
      return Scaffold(
        body: Center(
          child: SpinKitWave(color: Colors.black,size: 18.0,),
        ),
      );
    }
    else{
      return Text("");
    }
  }
}
