import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {

  final String title;
  final String name;
  final String nickName;

  GameScreen({Key key, @required this.title, @required this.name, @required this.nickName})
      : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {

  void _delete() async {
    await Firestore.instance.collection("CurrentUsers").where("NickName",isEqualTo: widget.nickName).getDocuments().then((QuerySnapshot snap){
      snap.documents.forEach((DocumentSnapshot sna){
        sna.reference.delete();
      });
    });
  }

  void _shDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure you want to Leave?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  _delete();
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
        }
    );
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        _shDialog();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("All Data"),
          ),
          body: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: StreamBuilder(
                stream: Firestore.instance.collection('CurrentUsers')
                    .snapshots(),
                builder: (context, snapshots) {
                  if (!snapshots.hasData) {
                    return Text('Loading');
                  }
                  else {
                    return ListView.builder(
                      itemCount: snapshots.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot myUsers = snapshots.data
                            .documents[index];
                        return (widget.title == myUsers['EventName'])
                            ? ListTile(
                            title: Text('${myUsers['NickName']}'),
                            subtitle: Text('${myUsers['UserName']}')
                        ):SizedBox(
                          height: 1.0,
                        );
                      },
                    );
                  }
                },
              )
          ),
        ),
      ),
    );
  }
}
