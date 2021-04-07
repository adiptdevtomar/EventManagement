import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task/globals.dart' as globals;

class ChooseName extends StatefulWidget {
  @override
  _ChooseNameState createState() => _ChooseNameState();
}

class _ChooseNameState extends State<ChooseName> {
  bool loading = false;
  bool isTapped = false;
  bool exists = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  _saveName() async {
    await Firestore.instance
        .collection("GGVideoNames")
        .document(globals.emailID + globals.code)
        .setData({"Name": _controller.text, "Score": 0}).whenComplete(() {
      setState(() {
        isTapped = false;
      });
      Navigator.of(context).pop();
    });
  }

  _updateName() async {
    await Firestore.instance
        .collection("GGVideoNames")
        .document(globals.emailID + globals.code)
        .updateData({"Name": _controller.text}).whenComplete(() {
      setState(() {
        isTapped = false;
      });
      Navigator.of(context).pop();
    });
  }

  _checker() async {
    DocumentSnapshot snap = await Firestore.instance
        .collection("GGVideoNames")
        .document(globals.emailID + globals.code)
        .get();
    if (snap.exists) {
      _updateName();
    } else {
      _saveName();
    }
  }

  _checkName() async {
    await Firestore.instance
        .collection("GGVideoNames")
        .getDocuments()
        .then((value) {
      value.documents.forEach((e) {
        if (e["Name"] == _controller.text) {
          setState(() {
            exists = true;
          });
        }
      });
    }).whenComplete(() {
      if (_formKey.currentState.validate()) {
        _checker();
      }
    });
  }

  _getName() async {
    DocumentSnapshot doc = await Firestore.instance
        .collection("GGVideoNames")
        .document(globals.emailID + globals.code)
        .get();
    if (doc.exists) {
      _controller.text = doc["Name"];
    }
  }

  @override
  void initState() {
    _getName();
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Let's Get Started!",
                          style: TextStyle(color: Colors.black, fontSize: 25.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "Please Enter a Game Name in the given field. It can be changed afterwards.",
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (val) {
                            if (val.isEmpty) {
                              setState(() {
                                isTapped = false;
                              });
                              return "A Name dammit!";
                            } else {
                              setState(() {
                                isTapped = false;
                              });
                              if (exists == true) {
                                return "Name Already Exists!";
                              } else {
                                return null;
                              }
                            }
                          },
                          controller: _controller,
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        //color: Color(0XFF71D59D),
                        onPressed: () {
                          setState(() {
                            isTapped = true;
                          });
                          _checkName();
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
                          child: (isTapped)
                              ? SpinKitWave(
                                  color: Colors.black,
                                  size: 13.0,
                                )
                              : Center(
                                  child: Text(
                                    "Play!",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
