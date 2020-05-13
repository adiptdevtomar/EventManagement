import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task/GuessPlayer/find_player.dart';
import '../globals.dart' as globals;

class NewPlayer extends StatefulWidget {
  @override
  _NewPlayerState createState() => _NewPlayerState();
}

class _NewPlayerState extends State<NewPlayer> {
  
  int count;
  var card;
  bool exists = false;
  String toGuess = "";
  TextEditingController _name = TextEditingController();
  bool _tapped = false;
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _fields;
  List _keys;
  int _length;
  int _check = -1;
  bool hasDetails = false;

  _createDemo() async {
    await Firestore.instance.collection("AllMatches").add({
      "Email1": "aparna.chand@gmail.com",
      "Code": "QWERTY",
      "NoOfPlayers": 1,
      "Guess1": false
    });
  }

  _checkCard() async {
    await Firestore.instance.collection("ReadyGame").where("Code",isEqualTo: globals.code).getDocuments().then((onVal){
      onVal.documents.forEach((f){
        if(f.documentID == globals.emailID){
          card = f.data;
          setState(() {
            exists = true;
          });
        }
      });
    }).whenComplete((){
      setState(() {
        hasDetails = true;
      });
    });
  }

  void _addUser() async {
    var _details = Map<String, String>();
    for (int i = 0; i < _length; i++) {
      _details["${_keys[i]}"] = "${_fields[i].text}";
    }
    globals.toGuess = toGuess;
    _details["$toGuess"] = "${_name.text}";
    _details["Code"] = "${globals.code}";

    await Firestore.instance
        .collection("ReadyGame")
        .document(globals.emailID)
        .setData(_details)
        .whenComplete(() {
      setState(() {
        _tapped = false;
      });
      _keys[_length] = toGuess;
      globals.keys = _keys;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => FindPlayer()));
    });
  }

  @override
  void initState() {
    _checkCard();
    count = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 15.0),
              child: GestureDetector(
                child: Text(
                  "Clear",
                  style: TextStyle(color: Colors.deepOrange, fontSize: 20.0),
                ),
                onTap: () {
                  for (int i = 0; i < _fields.length; i++) {
                    _fields[i].text = "";
                  }
                  _name.text = "";
                },
              ),
            )
          ],
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: (hasDetails)
            ? Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.86,
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Center(
                            child: Text(
                          "Your Card",
                          style: TextStyle(
                              fontSize: 23.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
                        SizedBox(
                          height: 15.0,
                        ),
                        SizedBox(height: 15.0),
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection("PlayerCard")
                              .document("${globals.code}")
                              .snapshots(),
                          builder: (context, snapshots) {
                            if (!snapshots.hasData) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              );
                            } else {
                              _length = int.parse(snapshots.data["Fields"]);
                              if (_check != _length) {
                                _fields = List.generate(_length,
                                    (context) => new TextEditingController());
                                _keys = List(
                                    int.parse(snapshots.data["Fields"]) + 1);
                                toGuess = snapshots.data["ToGuess"];
                                _check = _length;
                                count = 0;
                              }
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: int.parse(snapshots.data["Fields"]),
                                itemBuilder: (context, index) {
                                  if (count !=
                                      int.parse(snapshots.data["Fields"])) {
                                    _keys[index] =
                                        snapshots.data["F${index + 1}"];
                                    if (exists) {
                                      _fields[index].text =
                                          card["${_keys[index]}"];
                                      _name.text = card["$toGuess"];
                                    }
                                    count = count + 1;
                                  }
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        (index == 0)
                                            ? Text(
                                                snapshots.data["ToGuess"],
                                                style:
                                                    TextStyle(fontSize: 17.0),
                                              )
                                            : SizedBox(),
                                        (index == 0)
                                            ? SizedBox(
                                                height: 5.0,
                                              )
                                            : SizedBox(),
                                        (index == 0)
                                            ? TextFormField(
                                                controller: _name,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder()),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return "Cannot be left empty";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              )
                                            : SizedBox(),
                                        (index == 0)
                                            ? SizedBox(
                                                height: 5.0,
                                              )
                                            : SizedBox(),
                                        (index == 0)
                                            ? Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  "* To Guess",
                                                  style: TextStyle(
                                                      color: Colors.orange,
                                                      fontSize: 15.0),
                                                ))
                                            : SizedBox(),
                                        (index == 0)
                                            ? SizedBox(
                                                height: 10.0,
                                              )
                                            : SizedBox(),
                                        Text(
                                          snapshots.data["F${index + 1}"],
                                          style: TextStyle(fontSize: 17.0),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        TextFormField(
                                          controller: _fields[index],
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Cannot be left empty";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        Column(
                          children: <Widget>[
                            FlatButton(
                              padding: EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              //color: Color(0XFF71D59D),
                              onPressed: (!_tapped)
                                  ? () {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          _tapped = true;
                                        });
                                        _addUser();
                                      }
                                    }
                                  : null,
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    gradient: LinearGradient(colors: [
                                      Color(0xFFf45d27),
                                      Color(0xFFf5851f)
                                    ])),
                                child: (_tapped == true)
                                    ? SizedBox(
                                        width: 40.0,
                                        height: 22.0,
                                        child: SpinKitWave(
                                          color: Colors.black,
                                          size: 10.0,
                                        ),
                                      )
                                    : Text(
                                        "Play",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        FlatButton(
                          child: Text("Create",style: TextStyle(color: Colors.black),),
                          onPressed: () {
                            _createDemo();
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: SpinKitWave(
                  color: Colors.black,
                  size: 20.0,
                ),
              ),
      ),
    );
  }
}
