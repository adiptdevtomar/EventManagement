import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:game_task/globals.dart' as globals;

class PollingPage extends StatefulWidget {
  @override
  _PollingPageState createState() => _PollingPageState();
}

class _PollingPageState extends State<PollingPage> {

  bool once = false;
  bool hasDetails = false;
  Map _details;
  List _loading = [];
  var lst;
  List _prev = [];
  var _percent;
  var equal = 0;
  List<int> _selectedRadioTiles;
  var stream;

  _voteLogic(ques, valueInc, valueDec, index, i) async {
    var db = Firestore.instance;
    var batch = db.batch();
    if (valueDec != null) {
      print("IN DEC");
      batch.updateData(
          db.collection("Poll Questions").document(ques.documentID), {
        "V${valueDec + 1}": FieldValue.increment(-1),
        "Votes": FieldValue.increment(-1),
      });
      batch.updateData(
          db.collection("Votes").document(globals.emailID + globals.code),
          {"${ques["Q1"]}": FieldValue.delete()});
    }
    batch
        .updateData(db.collection("Poll Questions").document(ques.documentID), {
      "V${valueInc + 1}": FieldValue.increment(1),
      "Votes": FieldValue.increment(1),
    });
    DocumentSnapshot docs = await Firestore.instance
        .collection("Votes")
        .document(globals.emailID + globals.code)
        .get();
    if (!docs.exists) {
      print("non EXISTS");
      batch.setData(
          db.collection("Votes").document(globals.emailID + globals.code),
          {"${ques["Q1"]}": _selectedRadioTiles[index]});
    } else {
      print("exists");
      batch.updateData(
          db.collection("Votes").document(globals.emailID + globals.code),
          {"${ques["Q1"]}": _selectedRadioTiles[index]});
    }
    batch.commit().whenComplete(() {
      print("commit");
      setState(() {
        _loading[index] = false;
      });
    });
  }

  _setStream() async {
    stream = Firestore.instance
        .collection("Poll Questions")
        .where("Category", isEqualTo: globals.PollCat)
        .snapshots();
  }

  _getPercent(DocumentSnapshot ques, int index) {
    var l = ques["V${index + 1}"] / ques["Votes"];
    _percent = l;
    return l;
  }

  _getVotes() async {
    await Firestore.instance
        .collection("Votes")
        .document(globals.emailID + globals.code)
        .get()
        .then((doc) {
      if (doc.exists) {
        _details = doc.data.map((key, value) => MapEntry(key, value));
      }
    }).whenComplete(() {
      setState(() {
        hasDetails = true;
      });
    });
  }

  @override
  void initState() {
    _setStream();
    _getVotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0,
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            title: Padding(
              child: Text(
                "Polling Screen",
                style: TextStyle(color: Colors.black),
              ),
              padding: EdgeInsets.only(left: 63.0),
            ),
          ),
          body: (hasDetails)
              ? Container(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder(
                        stream: stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                child: SpinKitWave(
                                  color: Colors.black,
                                  size: 13.0,
                                ),
                              ),
                            );
                          } else {
                            if (snapshot.data.documents.length == 0) {
                              return Center(child: Text("No Question Found"));
                            } else {
                              return ListView.builder(
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    if (equal !=
                                        snapshot.data.documents.length) {
                                      equal = snapshot.data.documents.length;
                                      lst = List.generate(
                                          equal, (i) => i = i + 1);
                                      lst.shuffle();
                                      _loading =
                                          List.generate(equal, (i) => null);
                                      _selectedRadioTiles =
                                          List.generate(equal, (i) => null);
                                      _prev = List.generate(equal, (i) => null);
                                    }
                                    DocumentSnapshot ques =
                                        snapshot.data.documents[lst[index] - 1];
                                    if (_details != null) {
                                      if (once == false) {
                                        if (index == equal - 1) {
                                          once = true;
                                        }
                                        if (_details.containsKey(ques["Q1"])) {
                                          _selectedRadioTiles[index] =
                                              _details[ques["Q1"]];
                                          _prev[index] = _details[ques["Q1"]];
                                        }
                                      }
                                    }
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: 13.0,
                                          left: 13.0,
                                          right: 13.0,
                                          bottom: 5.0),
                                      child: Container(
                                          padding:
                                              EdgeInsets.only(bottom: 20.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 0.3,
                                              color: Colors.deepOrange,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: Colors.grey.shade300,
                                            /*boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 10.0,
                                          offset: Offset(7.0, 7.0),
                                        )
                                      ]*/
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Align(
                                                      child: AutoSizeText(
                                                        "${ques["Q1"]}",
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            color:
                                                                Colors.black),
                                                        maxLines: 2,
                                                      ),
                                                      alignment:
                                                          Alignment.topLeft,
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Align(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text("Votes ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .deepOrangeAccent,
                                                                  fontSize:
                                                                      12.0)),
                                                          CircleAvatar(
                                                            backgroundColor: Colors
                                                                .deepOrangeAccent,
                                                            radius: 2,
                                                          ),
                                                          Text(
                                                            " ${ques["Votes"]}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .deepOrangeAccent,
                                                                fontSize: 12.0),
                                                          ),
                                                        ],
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        ((ques.data.keys.length -
                                                                        1) *
                                                                    0.5)
                                                                .toInt() -
                                                            1,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, ind) {
                                                      return RadioListTile(
                                                        secondary: (_loading[
                                                                        index] ==
                                                                    true &&
                                                                _selectedRadioTiles[
                                                                        index] !=
                                                                    null)
                                                            ? SizedBox(
                                                                height: 10.0,
                                                                width: 10.0,
                                                                child:
                                                                    CupertinoActivityIndicator(
                                                                  radius: 5.0,
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                        activeColor: Colors
                                                            .deepOrangeAccent,
                                                        dense: true,
                                                        subtitle: (_loading[index] ==
                                                                    true &&
                                                                _selectedRadioTiles[
                                                                        index] !=
                                                                    null)
                                                            ? null
                                                            : (_selectedRadioTiles[
                                                                        index] !=
                                                                    null)
                                                                ? LinearPercentIndicator(
                                                                    progressColor: Colors
                                                                        .deepOrangeAccent,
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            4.0,
                                                                        right:
                                                                            6.0),
                                                                    lineHeight:
                                                                        5.0,
                                                                    animation:
                                                                        true,
                                                                    percent:
                                                                        _getPercent(
                                                                            ques,
                                                                            ind),
                                                                    trailing:
                                                                        Text(
                                                                      "${(_percent * 100.0).toStringAsFixed(1)}%",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13.0,
                                                                          color:
                                                                              Colors.deepOrangeAccent),
                                                                    ))
                                                                : null,
                                                        value: ind,
                                                        groupValue:
                                                            _selectedRadioTiles[
                                                                index],
                                                        title: Text(
                                                          "${ques["A${ind + 1}"]}",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        onChanged: (i) {
                                                          setState(() {
                                                            _loading[index] =
                                                                true;
                                                            _selectedRadioTiles[
                                                            index] = i;
                                                            _voteLogic(
                                                                ques,
                                                                _selectedRadioTiles[
                                                                    index],
                                                                _prev[index],
                                                                index,
                                                                i);
                                                            _prev[index] = i;
                                                          });
                                                        },
                                                      );
                                                    }),
                                              ),
                                            ],
                                          )),
                                    );
                                  });
                            }
                          }
                        },
                      )),
                )
              : Center(
                  child: SpinKitWave(
                    color: Colors.black,
                    size: 13.0,
                  ),
                )),
    );
  }
}
