import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../globals.dart' as globals;

class WinnerPage extends StatefulWidget {
  @override
  _WinnerPageState createState() => _WinnerPageState();
}

class _WinnerPageState extends State<WinnerPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Congratulations!!!",
                    style: TextStyle(color: Colors.black, fontSize: 30.0),
                  ),
                  Text(
                    "LeaderBoard",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection("THLeader")
                            .where("EventCode", isEqualTo: globals.code)
                            .orderBy("Time")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: SpinKitWave(
                                color: Colors.white,
                                size: 20.0,
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot doc =
                                    snapshot.data.documents[index];
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            child: Text(
                                              "${index + 1}",
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                          ),
                                          Container(
                                            child: Center(
                                              child: Text(
                                                "${doc["Name"]}",
                                                style: TextStyle(fontSize: 15.0),
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.37,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.37,
                                            child: Center(
                                              child: Text(
                                                "${(((doc["Time"] / 60) / 60).toInt() == 0) ? "" : ((doc["Time"] / 60) / 60).toInt().toString() + " hours"} ${(doc["Time"] < 60) ? "" : ((doc["Time"] >= 3600) ? (((doc["Time"] / 60) % 60).toInt().toString() + " min") : (doc["Time"] / 60).toInt().toString() + " min")} ${doc["Time"] % 60} sec",
                                                style: TextStyle(fontSize: 15.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: Colors.grey.shade300
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                    ),
                                    SizedBox(height: 10.0)
                                  ],
                                );
                              },
                            );
                          }
                        },
                      )),
                  FlatButton(
                    padding: EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    //color: Color(0XFF71D59D),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 130.0,
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                              colors: [Color(0xFFf45d27), Color(0xFFf5851f)])),
                      child: Center(
                        child: Text(
                          "Return",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
