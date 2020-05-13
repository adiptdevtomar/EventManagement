import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_task/Image_Video/Scroll_Game.dart';
import 'package:game_task/globals.dart' as globals;

class PlayArea extends StatefulWidget {
  @override
  _PlayAreaState createState() => _PlayAreaState();
}

class _PlayAreaState extends State<PlayArea> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 170.0,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder()
                  ),
                  key: _formKey,
                  initialValue: globals.userName,
                ),
                SizedBox(height: 5.0,),
                Align(child: Text("*Or Enter New Name",style: TextStyle(color: Colors.deepOrange),),alignment: Alignment.centerRight,),
                Spacer(),
                FlatButton(
                  padding: EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  //color: Color(0XFF71D59D),
                  onPressed: () {
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => ScrollGame()));
                  },
                  child: Container(
                    width: 130.0,
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(colors: [
                          Color(0xFFf45d27),
                          Color(0xFFf5851f)
                        ])),
                    child: Center(
                      child: Text(
                        "Continue ->",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
        )
      ),
    );
  }
}
