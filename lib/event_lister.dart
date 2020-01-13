import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_task/GSignIn.dart';

import 'game_page.dart';
import 'home_page.dart';

class drawerapp extends StatefulWidget {

  final String Title;
  final UserDetails detailsUser;
  drawerapp({Key key, @required this.Title , @required this.detailsUser}) : super(key : key);

  @override
  _drawerappState createState() => _drawerappState();
}

class _drawerappState extends State<drawerapp> {

  void _logoutDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure you want to Logout?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
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
      onWillPop: (){
        _logoutDialog();
      },
      child: Scaffold(
        body: Center(
          child: Text("Main Page"),
        ),
        appBar: AppBar(
          title: Text("Event Feed"),
          actions: <Widget>[
            GestureDetector(
              child: Padding(
                child: Icon(Icons.keyboard_arrow_right),
                padding: EdgeInsets.only(right: 10.0),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => GamePage()));
              },
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                /*currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.deepOrange,
                  child: Text(widget.Title.substring(0,1)),
                ),*/
                accountName: Text(widget.Title,style: TextStyle(fontSize: 25.0),),
                accountEmail: Text(widget.detailsUser.userName),
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage("Home")));
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage("Maps")));
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
    );
  }
}
