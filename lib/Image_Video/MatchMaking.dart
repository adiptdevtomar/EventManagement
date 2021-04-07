import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task/globals.dart' as globals;

class MatchMaking extends StatefulWidget {
  @override
  _MatchMakingState createState() => _MatchMakingState();
}

class _MatchMakingState extends State<MatchMaking> {

  bool isTapped = false;
  String id;
  List lst = [];

  _findExistingGame() async {
    var lol = "";
    await Firestore.instance
        .collection("GGMatches")
        .getDocuments()
        .then((onValue) {
      onValue.documents.forEach((f) {
        if (f["Email1"] == globals.emailID || f["Email2"] == globals.emailID) {
          lol = f.documentID;
        }
      });
    });

    if (lol == "") {
      _findMatch();
    } else {
      await Firestore.instance
          .collection("GGMatches")
          .document(lol)
          .delete()
          .whenComplete(() {
        _findMatch();
      });
    }
  }

  _findMatch() async {
    await Firestore.instance
        .collection("GGMatches")
        .where("NoOfPlayers", isEqualTo: 1)
        .where("Code", isEqualTo: globals.code)
        .limit(1)
        .getDocuments()
        .then((onValue) {
      onValue.documents.forEach((f) {
        id = f.documentID;
      });
    });
    if (id == "") {
      _addMatch();
    } else {
      DocumentReference docRef =
          Firestore.instance.collection("GGMatches").document(id);
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot snap = await tx.get(docRef);
        if (snap.exists) {
          if (snap.data["NoOfPlayers"] == 1) {
            tx.update(docRef,
                {"Email2":globals.emailID,"Guess2":false,"NoOfPlayers": 2});
          } else {
            _addMatch();
          }
        }
      }).whenComplete(() {
        globals.docID = id;
        globals.playerNo = 2;
        Navigator.of(context).popAndPushNamed("/PlayGameGG");
      });
    }
  }

  _addMatch() async {
    await Firestore.instance.collection("GGMatches").add({
      "NoOfPlayers": 1,
      "Email1":globals.emailID,
      "Guess1":false,
      "Code": globals.code,
      "QuesID": (lst..shuffle()).first
    }).then((on) {
      id = on.documentID;
    });
    globals.docID = id;
  }

  _deletePlayer() async {
    var d = "";
    await Firestore.instance
        .collection("GGMatches")
        .where("Email1", isEqualTo: globals.emailID)
        .getDocuments()
        .then((onValue) {
      onValue.documents.forEach((f) {
        d = f.documentID;
      });
    });

    await Firestore.instance
        .collection("GGMatches")
        .document(d)
        .delete()
        .whenComplete(() {
      Navigator.of(context).pop();
    });
  }

  _getAllQuesId() async {
    await Firestore.instance
        .collection("AudioVideo")
        .getDocuments()
        .then((value) {
      value.documents.forEach((e) {
        lst.add(e.documentID);
      });
    });
  }

  _set() async {
    await Future.delayed(Duration(milliseconds: 1));
    globals.playerNo = 1;
    Navigator.of(context).popAndPushNamed("/playGame");
  }

  @override
  void initState() {
    isTapped = false;
    id = "";
    _getAllQuesId();
    _findExistingGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 300.0,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 100.0,
                  child: StreamBuilder(
                    stream:
                        Firestore.instance.collection("AllMatches").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("");
                      } else {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc =
                                snapshot.data.documents[index];
                            if (doc.documentID == id) {
                              if (doc["Email1"] == globals.emailID &&
                                  doc["NoOfPlayers"] == 2) {
                                _set();
                              } else {
                                print("");
                              }
                            }
                            return Center(child: Text(""));
                          },
                        );
                      }
                    },
                  ),
                ),
                Text(
                  "Finding Player",
                  style: TextStyle(fontSize: 30.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SpinKitDualRing(size: 30.0, color: Colors.black),
                SizedBox(height: 20.0),
                RaisedButton(
                  padding: EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  //color: Color(0XFF71D59D),
                  onPressed: (isTapped)
                      ? () {}
                      : () {
                          setState(() {
                            isTapped = true;
                          });
                          _deletePlayer();
                        },
                  child: Container(
                    height: 50.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                            colors: [Color(0xFFf45d27), Color(0xFFf5851f)])),
                    child: (isTapped)
                        ? SpinKitWave(
                            color: Colors.black,
                            size: 13.0,
                          )
                        : Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
