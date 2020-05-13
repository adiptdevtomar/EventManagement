import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../globals.dart' as globals;

class CreateGame extends StatefulWidget {
  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  var docID;
  TextEditingController _tCode = TextEditingController();
  TextEditingController _tName = TextEditingController();
  bool codeIsTapped = false;
  bool isTapped = false;
  final _formKey = GlobalKey<FormState>();
  final _codeKey = GlobalKey<FormState>();
  bool match = false;
  bool exists = false;
  var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  var er = false;

  String randomString(int strLen) {
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strLen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  _addPlayer() async {
    var l;
    await Firestore.instance
        .collection("THTeams")
        .document(docID)
        .get()
        .then((onValue) {
      l = onValue.data["NoOfMembers"];
    });

    var _details = Map<String, String>();
    _details["Email"] = "${globals.emailID}";
    _details["Code"] = "${globals.code}";
    _details["Name"] = "${globals.userName}";

    await Firestore.instance
        .collection("THTeams")
        .document(docID)
        .updateData({"Player${l + 1}": _details});

    await Firestore.instance
        .collection("THTeams")
        .document(docID)
        .updateData({"NoOfMembers": FieldValue.increment(1)}).whenComplete(() {
      setState(() {
        codeIsTapped = false;
        Navigator.of(context).popAndPushNamed('/h');
      });
    });
  }

  _checkCode() async {
    var l = await Firestore.instance.collection("THTeams").getDocuments();
    l.documents.forEach((f) {
      if (f.data["TeamCode"] == _tCode.text && f.data["Player1"]["Code"] == globals.code) {
        docID = f.documentID;
        match = true;
        if (f.data["NoOfMembers"] == 4) {
          er = true;
        }
      } else {
        match = false;
      }
    });
    if (_codeKey.currentState.validate()) {
      _addPlayer();
    }
  }

  _checkName() async {
    var l = await Firestore.instance.collection("THTeams").getDocuments();
    l.documents.forEach((f) {
      if (f.documentID == _tName.text) {
        exists = true;
      } else {
        exists = false;
      }
    });
    if (_formKey.currentState.validate()) {
      _createTeam();
    }
  }

  _createTeam() async {
    var _details = Map<String, dynamic>();
    _details["Code"] = "${globals.code}";
    _details["Name"] = "${globals.userName}";
    _details["Email"] = "${globals.emailID}";

    await Firestore.instance
        .collection("THTeams")
        .document("${_tName.text}")
        .setData({"Player1": _details});

    await Firestore.instance
        .collection("THTeams")
        .document(_tName.text)
        .updateData({
      "TeamCode": "${randomString(4)}",
      "NoOfMembers": 1
    }).whenComplete(() {
      setState(() {
        isTapped = false;
        Navigator.of(context).popAndPushNamed('/h');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: GestureDetector(child: Icon(Icons.arrow_back_ios,color: Colors.black,),onTap: (){
            Navigator.of(context).pop();
          },),
        ),
          body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.95,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Spacer(),
                            Text(
                              'Have a Team Code?',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 25.0),
                            Form(
                              key: _codeKey,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      codeIsTapped = false;
                                    });
                                    return "Cannot be Left Empty";
                                  } else if (match == false) {
                                    setState(() {
                                      codeIsTapped = false;
                                    });
                                    return "Event Code does not Exist!";
                                  } else if (match == true && er == true){
                                    setState(() {
                                      codeIsTapped = false;
                                    });
                                    return "Team Already Has 4 Members!";
                                  }
                                  else {
                                    return null;
                                  }
                                },
                                controller: _tCode,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black))),
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            FlatButton(
                              padding: EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              //color: Color(0XFF71D59D),
                              onPressed: () {
                                setState(() {
                                  codeIsTapped = true;
                                });
                                _checkCode();
                              },
                              child: Container(
                                width: 130.0,
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    gradient: LinearGradient(colors: [
                                      Color(0xFFf45d27),
                                      Color(0xFFf5851f)
                                    ])),
                                child: Center(
                                  child: (codeIsTapped)
                                      ? SpinKitWave(
                                          color: Colors.black,
                                          size: 15.0,
                                        )
                                      : Text(
                                          "Join Team",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Text(
                              "OR",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Text(
                              "Make one",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      isTapped = false;
                                    });
                                    return "Cannot be Left Empty";
                                  } else if (exists == true) {
                                    setState(() {
                                      isTapped = false;
                                      exists = false;
                                    });
                                    return "Name already Exists!";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: _tName,
                                decoration: InputDecoration(
                                    hintText: "Team Name",
                                    suffixIcon: GestureDetector(
                                      child: (isTapped)
                                          ? SizedBox(
                                              width: 30.0,
                                              child: SpinKitWave(
                                                color: Colors.black,
                                                size: 13.0,
                                              ),
                                            )
                                          : Icon(Icons.arrow_forward_ios),
                                      onTap: () {
                                        setState(() {
                                          isTapped = true;
                                          _checkName();
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black))),
                              ),
                            ),
                            Spacer()
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
