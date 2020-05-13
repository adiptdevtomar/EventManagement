import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ScrollGame extends StatefulWidget {
  @override
  _ScrollGameState createState() => _ScrollGameState();
}

class _ScrollGameState extends State<ScrollGame> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios, color: Colors.white),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection("AudioVideo").snapshots(),
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return Center(
                child: SpinKitWave(
                  color: Colors.black,
                  size: 15.0,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshots.data.documents[0];
                  return Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border:
                              Border.all(width: 2, color: Colors.deepOrange),
                          borderRadius: BorderRadius.circular(10.0)),
                      height: MediaQuery.of(context).size.height * 0.8,
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            doc["Q"],
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                          (doc["Type"] == "Images")
                              ? Image.network(
                                  "${doc["Url"]}",
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: Container(
                                        height: 100.0,
                                        width: 100.0,
                                        child: Center(
                                          child: SpinKitWave(
                                            size: 20.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Text(""),
                          //(doc["Type"] == "Videos")?Image.network(doc["Url"]):Text(""),
                          Spacer(),
                          TextFormField(
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
