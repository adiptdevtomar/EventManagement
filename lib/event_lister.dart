import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_task/select_game.dart';

import 'home_page.dart';
import 'globals.dart' as globals;

class drawerapp extends StatefulWidget {
  @override
  _drawerappState createState() => _drawerappState();
}

class _drawerappState extends State<drawerapp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
          body: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Hello this is an event management app made by adipt dev tomar and aparmna chand for our college projetcs",
                style: TextStyle(fontSize: 20.0),
              )),
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage("Speaker")));
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage("Event Information")));
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
