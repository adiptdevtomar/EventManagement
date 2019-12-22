import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'event_lister.dart';

class CodePage extends StatefulWidget {
  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  String thisText = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * .25,
              width: MediaQuery.of(context).size.width * .60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Event Code", style: TextStyle(fontSize: 25.0),),
                  TextField(
                    autofocus: true,
                    onChanged: (value){
                      this.thisText = value;
                    },
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w300),
                    maxLines: 1,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(child: Icon(Icons.add),onTap: (){
                        Navigator.of(context).push(CupertinoPageRoute(builder: (context)=> new drawerapp()));
                      },),
                      border: OutlineInputBorder()
                    ),
                  )
                ],
              ),
            )
    ));
  }
}
