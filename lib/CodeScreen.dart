import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'globals.dart' as globals;

import 'AboutEvent/event_lister.dart';

class CodePage extends StatefulWidget {
  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  final GoogleSignIn _gSignIn = GoogleSignIn();
  final myController = TextEditingController();
  bool code = true;
  var eventID;
  bool _isTapped = false;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  _signIn() {
    code = true;
    eventID = null;
    setState(() {
      _isTapped = true;
    });
    try {
      Firestore.instance
          .collection("Events")
          .where("Code", isEqualTo: myController.text)
          .getDocuments()
          .then((QuerySnapshot ques) {
        if (ques.documents.length != 0) {
          var l = ques.documents[0].data;
          eventID = l['Name'];
          globals.PollCat = l['pollCat'];
          globals.eventName = eventID;
          globals.code = myController.text;
        } else {
          setState(() {
            code = false;
          });
        }
      }).whenComplete(() {
        setState(() {
          _isTapped = false;
        });
        if (_formKey.currentState.validate()) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => drawerapp()));
        }
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text("Are you sure you want to signout?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  _gSignIn.signOut();
                  print('Signed out');
                  Navigator.popAndPushNamed(context, '/c');
                },
              ),
              FlatButton(
                child: Text("No", style: TextStyle(color: Colors.black)),
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
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
    FocusScopeNode currentFocus = FocusScope.of(context);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        _shDialog();
      },
      child: SafeArea(
        child: Scaffold(
            //backgroundColor: Color(0XFF22264C),
            //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
            body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                              MediaQuery.of(context).size.width * 0.35),
                          bottomRight: Radius.circular(
                              MediaQuery.of(context).size.width * 0.35)),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
                      )),
                  child: Hero(
                    tag: "dash",
                    child: Icon(
                      FontAwesomeIcons.googleWallet,
                      size: 200.0,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  height: MediaQuery.of(context).size.height * .30,
                  width: MediaQuery.of(context).size.width * .60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Event Code",
                          style: TextStyle(fontSize: 25.0, color: Colors.black),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Cannot be left empty";
                            }
                            if (code == false) {
                              return "Incorrect Code!!";
                            } else {
                              return null;
                            }
                          },
                          controller: myController,
                          textCapitalization: TextCapitalization.characters,
                          maxLength: 6,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                          maxLines: 1,
                          decoration: InputDecoration(
                              counterText: "",
                              suffixIcon: GestureDetector(
                                child: (_isTapped)
                                    ? SizedBox(
                                        width: 30.0,
                                        child: SpinKitWave(
                                          color: Colors.black,
                                          size: 13.0,
                                        ),
                                      )
                                    : Icon(Icons.arrow_forward,
                                        color: Colors.black),
                                onTap: (!_isTapped)
                                    ? () {
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                        print("hello");
                                        _signIn();
                                      }
                                    : null,
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black,
                                      style: BorderStyle.solid))),
                        ),
                      ),
                      Center(
                        child: Text(
                          "${globals.userName}",
                          style: TextStyle(fontSize: 17.0, color: Colors.black),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          FlatButton(
                            padding: EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            //color: Color(0XFF71D59D),
                            onPressed: () {
                              _shDialog();
                            },
                            child: Container(
                              padding: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gradient: LinearGradient(colors: [
                                    Color(0xFFf45d27),
                                    Color(0xFFf5851f)
                                  ])),
                              child: Text(
                                "Logout Google Account",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Spacer(
                  flex: 2,
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
