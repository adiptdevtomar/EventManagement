import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task/AboutEvent/MoreInfo.dart';
import 'file:///C:/Users/hp/IdeaProjects/game_task/lib/AboutEvent/Speakers.dart';
import 'package:game_task/select_game.dart';

import '../home_page.dart';
import '../globals.dart' as globals;

class drawerapp extends StatefulWidget {
  @override
  _drawerappState createState() => _drawerappState();
}

class _drawerappState extends State<drawerapp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _details;
  bool hasData = false;

  _fetchDetails() async {
    await Firestore.instance
        .collection("Events")
        .where("Code", isEqualTo: globals.code)
        .limit(1)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        _details = element.data;
      });
    }).whenComplete(() {
      setState(() {
        hasData = true;
      });
    });
  }

  @override
  void initState() {
    _fetchDetails();
    super.initState();
  }

  void _logoutDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Are you sure you want to Logout?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/a');
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        _logoutDialog();
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SelectGame()));
                  },
                ),
              )
            ],
            leading: GestureDetector(
              child: Icon(
                Icons.format_list_bulleted,
                color: Colors.black,
              ),
              onTap: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0,
          ),
          body: (hasData)
              ? ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Image.asset("assets/images/tedx.jpg"),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "${_details["Name"]}",
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.orange,
                              size: 16.0,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "15 Sep - 17 Sep",
                                style: TextStyle(fontSize: 17.0),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "7:30am - 11:30pm",
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.grey.shade600),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 25.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.orange,
                              size: 16.0,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "15 Sep - 17 Sep",
                                style: TextStyle(fontSize: 17.0),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "7:30am - 11:30pm",
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.grey.shade600),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "About",
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                      child: Text(
                        "A TEDx event is a local gathering where live TED-like talks and performances are shared with the community. X",
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 25, 0.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoreInfo()));
                        },
                        child: Text(
                          "See More",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    )
                  ],
                )
              : Center(
                  child: SpinKitWave(
                    color: Colors.black,
                    size: 13.0,
                  ),
                ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
                    ),
                  ),
                  accountName: Text(
                    globals.eventName,
                    style: TextStyle(fontSize: 25.0, color: Colors.black),
                  ),
                  accountEmail: Text(globals.userName,
                      style: TextStyle(color: Colors.black)),
                ),
                ListTile(
                  title: Text("Back to Event Code"),
                  leading: Icon(Icons.arrow_back),
                  onTap: () {
                    _logoutDialog();
                  },
                ),
                Divider(
                  indent: 15.0,
                  endIndent: 15.0,
                  color: Colors.black,
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage("Home")));
                  },
                ),
                ListTile(
                  title: Text("Agenda"),
                  leading: Icon(Icons.view_agenda),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage("Agenda")));
                  },
                ),
                ListTile(
                  title: Text("Attendees"),
                  leading: Icon(Icons.people),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage("Attendees")));
                  },
                ),
                ListTile(
                  title: Text("Speaker"),
                  leading: Icon(Icons.mic),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Speakers()));
                  },
                ),
                ListTile(
                  title: Text("Companies"),
                  leading: Icon(Icons.group_work),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage("Companies")));
                  },
                ),
                ListTile(
                  title: Text("Maps"),
                  leading: Icon(Icons.map),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage("Maps")));
                  },
                ),
                ListTile(
                  title: Text("Documents"),
                  leading: Icon(Icons.card_travel),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage("Documents")));
                  },
                ),
                ListTile(
                  title: Text("Announcements"),
                  leading: Icon(Icons.announcement),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage("Announcements")));
                  },
                ),
                ListTile(
                  title: Text("Event Information"),
                  leading: Icon(Icons.info),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MoreInfo()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
