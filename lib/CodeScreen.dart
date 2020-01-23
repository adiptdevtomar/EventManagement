import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'event_lister.dart';

class CodePage extends StatefulWidget {
  String name;

  CodePage({Key key, @required this.name}) : super(key: key);

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  final GoogleSignIn _gSignIn = GoogleSignIn();
  final myController = TextEditingController();
  var EventID;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  _signIn() {
    EventID = null;
    try {
      Firestore.instance
          .collection("Events")
          .where("Code", isEqualTo: myController.text)
          .getDocuments()
          .then((QuerySnapshot ques) {
        if (ques.documents.length != 0) {
          var l = ques.documents[0].data;
          EventID = l['Name'];
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  drawerapp(Title: EventID, name: widget.name)));
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

  void _shDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure you want to signout?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  _gSignIn.signOut();
                  print('Signed out');
                  Navigator.popAndPushNamed(context, '/c');
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        _shDialog();
      },
      child: SafeArea(
        child: Scaffold(
            body: Center(
                child: Container(
          height: MediaQuery.of(context).size.height * .30,
          width: MediaQuery.of(context).size.width * .60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Event Code",
                style: TextStyle(fontSize: 25.0),
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Cannot be left empty";
                    }
                    return null;
                  },
                  controller: myController,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 6,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                  maxLines: 1,
                  decoration: InputDecoration(
                      counterText: "",
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.add),
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            _signIn();
                          }
                        },
                      ),
                      border: OutlineInputBorder()),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "${widget.name}",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  color: Colors.amberAccent,
                  onPressed: () {
                    _shDialog();
                  },
                  child: Text("Logout Google Account"),
                ),
              )
            ],
          ),
        ))),
      ),
    );
  }
}
