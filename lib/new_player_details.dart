import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_task/game_area.dart';

class NewPlayer extends StatefulWidget {

  final String title;
  final String name;

  NewPlayer({Key key, @required this.title , @required this.name}) : super(key : key);

  @override
  _NewPlayerState createState() => _NewPlayerState();
}

class _NewPlayerState extends State<NewPlayer> {

  void addUser() async {
    await Firestore.instance.collection("CurrentUsers").add({'EventName': '${widget.title}', 'UserName': '${widget.name}', 'NickName': '${_nickName.text}'});
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameScreen(title: widget.title,name: widget.name,nickName: _nickName.text,)));
  }


  TextEditingController _nickName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nickName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
              child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          )),
          title: Text(
            "Add Nick Name",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      controller: _nickName,
                      decoration: InputDecoration(
                        hintText: "e.g. DET0",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "This Field Cannot be left Empty";
                        } else
                          return null;
                      },
                    ),
                    RaisedButton(
                      child: Text("Ready"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          addUser();
                        }
                      },
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
