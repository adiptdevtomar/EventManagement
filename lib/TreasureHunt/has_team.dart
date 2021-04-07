import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task/TreasureHunt/QRTreasure_Hunt.dart';
import 'package:game_task/TreasureHunt/treasure_hunt.dart';
import 'package:game_task/globals.dart' as globals;

class HasTeam extends StatefulWidget {
  @override
  _HasTeamState createState() => _HasTeamState();
}

class _HasTeamState extends State<HasTeam> {

  bool _startTapped = false;
  bool isTapped = false;
  int _toDelete;
  String _delTeam;
  bool hasTeam = false;

  _shDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Text("Game Already Played!!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Return"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _checkPlayer() async {
    await Firestore.instance
        .collection("THLeader")
        .getDocuments()
        .then((onValue) {
      onValue.documents.forEach((f) {
        if (f.data["Name"] == globals.teamName) {
          setState(() {
            hasTeam = true;
          });
        }
      });
    }).whenComplete(() {
      setState(() {
        _startTapped = false;
      });
    });

    if (hasTeam == true) {
      _shDialog();
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => QRTreasureHunt()));
    }
  }

  _leaveTeam() async {
    var no;

    await Firestore.instance
        .collection("THTeams")
        .getDocuments()
        .then((onValue) {
      onValue.documents.forEach((f) {
        var l = f["NoOfMembers"];
        no = f["NoOfMembers"];
        for (int i = 1; i <= l; i++) {
          if (f["Player$i"]["Code"] == "${globals.code}" &&
              f["Player$i"]["Email"] == "${globals.emailID}") {
            _delTeam = f.documentID;
            _toDelete = i;
            no = f["NoOfMembers"];
          }
        }
      });
    });

    await Firestore.instance
        .collection("THTeams")
        .document("$_delTeam")
        .get()
        .then((onValue) {
      for (int j = _toDelete; j < no; j++) {
        var m = onValue.data["Player${_toDelete + 1}"];
        Firestore.instance
            .collection("THTeams")
            .document("$_delTeam")
            .updateData({"Player$_toDelete": m});
      }
    });

    await Firestore.instance
        .collection("THTeams")
        .document("$_delTeam")
        .updateData({
      'NoOfMembers': FieldValue.increment(-1),
      'Player$no': FieldValue.delete()
    });

    await Firestore.instance
        .collection("THTeams")
        .document("$_delTeam")
        .get()
        .then((onValue) {
      if (onValue.data["NoOfMembers"] == 0) {
        Navigator.of(context).popAndPushNamed('/h');
        Firestore.instance.collection("THTeams").document("$_delTeam").delete();
      } else {
        Navigator.of(context).popAndPushNamed('/h');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          body: (isTapped)
              ? Center(
                  child: SpinKitWave(
                    color: Colors.black,
                    size: 20.0,
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.80,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Team Name: ${globals.teamName}",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection("THTeams")
                                    .document("${globals.teamName}")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return SpinKitWave(
                                      color: Colors.black,
                                      size: 20.0,
                                    );
                                  } else {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data["NoOfMembers"],
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: <Widget>[
                                            Container(
                                              child: ListTile(
                                                title: Text(
                                                    "${index + 1} : ${snapshot.data["Player${index + 1}"]["Name"]}"),
                                              ),
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            ((snapshot.data["NoOfMembers"]) ==
                                                    (index + 1))
                                                ? Text(
                                                    "Team Code: ${snapshot.data["TeamCode"]}",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )
                                                : SizedBox(),
                                            ((snapshot.data["NoOfMembers"]) ==
                                                    (index + 1))
                                                ? (snapshot.data["Player1"]
                                                            ["Email"] ==
                                                        globals.emailID)
                                                    ? (snapshot.data[
                                                                "NoOfMembers"] ==
                                                            1)
                                                        ? Text(
                                                            "Minimum 2 members required")
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0),
                                                            child: Container(
                                                              height: 60.0,
                                                              width: 150.0,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  gradient:
                                                                      LinearGradient(
                                                                          colors: [
                                                                        Color(
                                                                            0xFFf45d27),
                                                                        Color(
                                                                            0xFFf5851f)
                                                                      ])),
                                                              child: FlatButton(
                                                                child:
                                                                    (_startTapped)
                                                                        ? Center(
                                                                            child:
                                                                                SpinKitWave(
                                                                              color: Colors.black,
                                                                              size: 13.0,
                                                                            ),
                                                                          )
                                                                        : Center(
                                                                            child:
                                                                                Text("Start Game?")),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _startTapped =
                                                                        true;
                                                                  });
                                                                  _checkPlayer();
                                                                },
                                                              ),
                                                            ),
                                                          )
                                                    : Text(
                                                        "Only ${snapshot.data["Player1"]["Name"]} can Start the game")
                                                : SizedBox()
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    gradient: LinearGradient(colors: [
                                      Color(0xFFf45d27),
                                      Color(0xFFf5851f)
                                    ])),
                                child: FlatButton(
                                  child: (isTapped)
                                      ? SpinKitWave(
                                          color: Colors.black,
                                          size: 13.0,
                                        )
                                      : Text("Leave Team?"),
                                  onPressed: () {
                                    setState(() {
                                      isTapped = true;
                                    });
                                    _leaveTeam();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
    );
  }
}
