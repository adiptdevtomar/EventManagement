import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_task/Image_Video/Play_Area.dart';
import 'package:game_task/Image_Video/Scroll_Game.dart';
import 'package:game_task/TreasureHunt/team_test.dart';
import 'package:game_task/polling_screen.dart';

class SelectGame extends StatefulWidget {
  @override
  _SelectGameState createState() => _SelectGameState();
}

class _SelectGameState extends State<SelectGame> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text("Select Game",style: TextStyle(fontSize: 20.0,color: Colors.black),),
          leading: GestureDetector(child: Icon(Icons.arrow_back_ios,color: Colors.black,),onTap: (){
            Navigator.of(context).pop();
          },),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Center(
            child: Container(
              child: ListView(
                children: <Widget>[
                  FlatButton(
                    onPressed: (){},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(colors: [
                            Color(0xFFf45d27), Color(0xFFf5851f)
                          ])),
                      child: ListTile(
                        dense: true,
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PollingPage()));
                        },
                        title: Text(
                          "Poll inc",
                          style: TextStyle(color: Colors.black),
                        ),
                        leading: Icon(FontAwesomeIcons.poll,color: Colors.black,),
                        subtitle: Text("A simple Polling Game",style: TextStyle(color: Colors.black),),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  /*SizedBox(height: 10.0,),
                  FlatButton(
                    onPressed: (){},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(colors: [
                            Color(0xFFf45d27), Color(0xFFf5851f)
                          ])),
                      child: ListTile(
                        dense: true,
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayerCheck()));
                        },
                        title: Text(
                          "Guess Player",
                          style: TextStyle(color: Colors.black),
                        ),
                        leading: Icon(FontAwesomeIcons.peopleCarry,color: Colors.black,),
                        subtitle: Text("Guess Name of your opponent",style: TextStyle(color: Colors.black)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),*/
                  SizedBox(height: 10.0),
                  FlatButton(
                    onPressed: (){},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(colors: [
                            Color(0xFFf45d27), Color(0xFFf5851f)
                          ])),
                      child: ListTile(
                        dense: true,
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TeamTest()));
                        },
                        title: Text(
                          "Treasure Hunt",
                          style: TextStyle(color: Colors.black),
                        ),
                        leading: Icon(FontAwesomeIcons.box,color: Colors.black,),
                        subtitle: Text("Play TH along  with friends",style: TextStyle(color: Colors.black)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  FlatButton(
                    onPressed: (){},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(colors: [
                            Color(0xFFf45d27), Color(0xFFf5851f)
                          ])),
                      child: ListTile(
                        dense: true,
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScrollGame()));
                        },
                        title: Text(
                          "Guess the Info",
                          style: TextStyle(color: Colors.black),
                        ),
                        leading: Icon(FontAwesomeIcons.solidFileVideo,color: Colors.black,),
                        subtitle: Text("Guess the image or Video",style: TextStyle(color: Colors.black)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
