import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task/GuessPlayer/new_player_details.dart';
import 'package:game_task/globals.dart' as globals;

class PlayerCheck extends StatefulWidget {
  @override
  _PlayerCheckState createState() => _PlayerCheckState();
}

class _PlayerCheckState extends State<PlayerCheck> {

  int hasGame = 0;
  
  @override
  void initState() {
    super.initState();
    _codeCheck();
  }

  _codeCheck() async {
    await Firestore.instance.collection("PlayerCard").getDocuments().then((onValue){
      onValue.documents.forEach((f){
        if(f.documentID == globals.code){
          setState(() {
            hasGame = 2;
          });
        }
        else{
          setState(() {
            hasGame = 1;
          });
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if(hasGame == 2)
      {
        return NewPlayer();
      }
    if(hasGame == 1)
      {
        return Scaffold(
          body: Center(
            child: Container(
              height: 200.0,
              child: Column(
                children: <Widget>[
                  Text("No game available",style: TextStyle(fontSize: 20.0),),
                  SizedBox(height: 20.0,),
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(colors: [
                            Color(0xFFf45d27),
                            Color(0xFFf5851f)
                          ])),
                      child: Text("Return",style: TextStyle(color: Colors.black),)
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    if(hasGame == 0)
      {
        return Scaffold(
          body: Center(
            child: SpinKitWave(color: Colors.black,size: 20.0,),
          ),
        );
      }
  }
}
