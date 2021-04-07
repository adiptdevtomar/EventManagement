import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task/Image_Video/Choose_Name.dart';
import 'package:game_task/Image_Video/MatchMaking.dart';
import 'package:game_task/globals.dart' as globals;

class ShowDetails extends StatefulWidget {
  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  _createDemo() async {
    await Firestore.instance.collection("GGMatches").add({
      "Email1": "aparna.chand@gmail.com",
      "Guess1": false,
      "Code": "QWERTY",
      "NoOfPlayers": 1,
      "QuesID": "yUhVp5d6rVktY71q6Nf5"
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                                MediaQuery.of(context).size.width * 0.60),
                            bottomRight: Radius.circular(
                                MediaQuery.of(context).size.width * 0.60)),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "How To Play!",
                          style: TextStyle(color: Colors.black, fontSize: 25.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "Answer Correctly before your opponent to gain points.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        )
                      ],
                    )),
                Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection("GGVideoNames")
                          .document(globals.emailID + globals.code)
                          .snapshots(),
                      builder: (context, snapshots) {
                        if (!snapshots.hasData) {
                          return Center(
                            child: SpinKitWave(
                              color: Colors.black,
                              size: 13.0,
                            ),
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                snapshots.data["Name"],
                                style: TextStyle(fontSize: 25.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text("Score : ${snapshots.data["Score"]}"),
                              SizedBox(
                                height: 50.0,
                              ),
                              RaisedButton(
                                padding: EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                //color: Color(0XFF71D59D),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MatchMaking()));
                                },
                                child: Container(
                                  height: 45.0,
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      gradient: LinearGradient(colors: [
                                        Color(0xFFf45d27),
                                        Color(0xFFf5851f)
                                      ])),
                                  child: Center(
                                    child: Text(
                                      "Play!",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  _createDemo();
                                },
                                child: Text("Create!"),
                              ),
                              InkWell(
                                child: Text(
                                  "Change Name?",
                                  style:
                                      TextStyle(color: Colors.deepOrangeAccent),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChooseName()));
                                },
                              )
                            ],
                          );
                        }
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
