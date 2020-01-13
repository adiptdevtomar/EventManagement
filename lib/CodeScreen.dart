import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:game_task/GSignIn.dart';
import 'package:game_task/Queries.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'event_lister.dart';

class CodePage extends StatefulWidget {
  final UserDetails detailsUser;

  CodePage({Key key, @required this.detailsUser}) : super(key: key);

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  final GoogleSignIn _gSignIn = GoogleSignIn();
  String UserCode;
  var EventID;

  _signIn() {
    EventID = null;
    try {
      Firestore.instance
          .collection("Events")
          .where("Code", isEqualTo: UserCode)
          .getDocuments()
          .then((QuerySnapshot ques) {
        if (ques.documents.length != 0) {
          var l = ques.documents[0].data;
          EventID = l['Name'];
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  drawerapp(Title: EventID, detailsUser: widget.detailsUser)));
        } else
          _showDialog("Incorrect Code");
      });
    } catch (e) {
      if (e.message ==
          "A network error (such as timeout, interrupted connection or unreachable host) has occurred.") {
        _showDialog("No Internet Connection Found! Try Again");
      }
    }
  }

  void _showDialog(String err) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(err),
            content: FlatButton(
              color: Colors.indigo,
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      height: MediaQuery.of(context).size.height * .25,
      width: MediaQuery.of(context).size.width * .60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Event Code",
            style: TextStyle(fontSize: 25.0),
          ),
          TextField(
            onChanged: (value) {
              this.UserCode = value;
            },
            textCapitalization: TextCapitalization.characters,
            maxLength: 6,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            maxLines: 1,
            decoration: InputDecoration(
                counterText: "",
                suffixIcon: GestureDetector(
                  child: Icon(Icons.add),
                  onTap: () {
                    _signIn();
                  },
                ),
                border: OutlineInputBorder()),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FlatButton(
              color: Colors.amberAccent,
              onPressed: (){
                _gSignIn.signOut();
                print('Signed out');
                Navigator.pop(context);
              },
              child: Text("Logout Google Account"),
            ),
          )
        ],
      ),
    )));
  }
}
