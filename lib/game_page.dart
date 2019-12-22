import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  var documentReference = Firestore.instance.collection("Poll Questions");
  //var len = Firestore.instance.collection("Poll Questions").snapshots().length.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(child: Text("Polling Screen"),padding: EdgeInsets.only(left: 63.0),),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
            stream: Firestore.instance.collection('Poll Questions').snapshots(),
            builder: (context,snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: SizedBox(
                    child: Icon(Icons.cloud_off),
                  ),
                );
              }
              else
                {
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context,index){
                        DocumentSnapshot Ques = snapshot.data.documents[index];
                        return Padding(
                          padding: EdgeInsets.all(13.0),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 20.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 4,
                                  color: Colors.black54,
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 15.0,
                                      offset: Offset(5.0,5.0)
                                  )]
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      children: <Widget>[
                                        Align(child: AutoSizeText("${Ques["Q1"]}",style: TextStyle(fontSize: 20.0),maxLines: 2,),alignment: Alignment.topLeft,),
                                        SizedBox(height: 5.0,),
                                        Align(child: Padding(
                                            padding: const EdgeInsets.only(left:3.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text("Votes ",style: TextStyle(color: Colors.grey,fontSize: 12.0)),
                                                CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  radius: 2,
                                                ),
                                                Text(" ${Ques["Votes"]}",style: TextStyle(color: Colors.grey,fontSize: 12.0),),
                                              ],
                                            )
                                        ),alignment: Alignment.centerLeft,)
                                      ],
                                    ),
                                  ),
                                  RadioButtonGroup(
                                    activeColor: Colors.indigo,
                                    labels: <String>[
                                      "${Ques["A1"]}",
                                      "${Ques["A2"]}",
                                      "${Ques["A3"]}",
                                      "${Ques["A4"]}",
                                    ],
                                    onSelected: (String Selected){
                                      documentReference.document(Ques.documentID).updateData({"Votes": FieldValue.increment(1)});
                                    },
                                  )
                                ],
                              )
                          ),
                        );
                      });
                }
            },
          )
        ),
      )
    );
  }
}
