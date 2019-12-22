import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'game_page.dart';
import 'home_page.dart';

class drawerapp extends StatefulWidget {
  @override
  _drawerappState createState() => _drawerappState();
}

class _drawerappState extends State<drawerapp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Main Page"),
      ),
      appBar: AppBar(
        title: Text("Events"),
        actions: <Widget>[
          GestureDetector(child: Padding(child: Icon(Icons.keyboard_arrow_right),padding: EdgeInsets.only(right: 10.0),),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GamePage()));
              },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Event Name"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.amberAccent,
                child: Text("P"),
              ),
              accountEmail: Text("Event Details"),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage("Home")));
              },
            ),
            ListTile(
              title: Text("Agenda"),
              leading: Icon(Icons.view_agenda),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage("Agenda")));
              },
            ),
            ListTile(
              title: Text("Attendees"),
              leading: Icon(Icons.people),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage("Attendees")));
              },
            ),
            ListTile(
              title: Text("Speaker"),
              leading: Icon(Icons.mic),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage("Speaker")));
              },
            ),
            ListTile(
              title: Text("Companies"),
              leading: Icon(Icons.group_work),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage("Companies")));
              },
            ),
            ListTile(
              title: Text("Maps"),
              leading: Icon(Icons.map),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage("Maps")));
              },
            ),
            ListTile(
              title: Text("Documents"),
              leading: Icon(Icons.card_travel),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage("Documents")));
              },
            ),
            ListTile(
              title: Text("Announcements"),
              leading: Icon(Icons.announcement),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage("Announcements")));
              },
            ),
            ListTile(
              title: Text("Event Information"),
              leading: Icon(Icons.info),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage("Event Information")));
              },
            ),
            Divider(
              indent: 15.0,
              endIndent: 15.0,
              color: Colors.black,
            ),
            ListTile(
              title: Text("Back to Event Code"),
              leading: Icon(Icons.arrow_back),
              onTap: (){
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
