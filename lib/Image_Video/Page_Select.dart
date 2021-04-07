import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_task/Image_Video/Choose_Name.dart';
import 'package:game_task/Image_Video/ShowDetails.dart';
import 'package:game_task/globals.dart' as globals;

class PageSelect extends StatefulWidget {
  @override
  _PageSelectState createState() => _PageSelectState();
}

class _PageSelectState extends State<PageSelect> {
  int hasName = 0;

  _checkName() async {
    DocumentSnapshot doc = await Firestore.instance
        .collection("GGVideoNames")
        .document(globals.emailID + globals.code)
        .get();
    if (doc.exists) {
      setState(() {
        hasName = 1;
      });
    } else {
      setState(() {
        hasName = 2;
      });
    }
  }

  @override
  void initState() {
    _checkName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (hasName == 0) {
      return Scaffold(
        body: Center(
          child: SpinKitWave(
            color: Colors.black,
            size: 20.0,
          ),
        ),
      );
    }
    if (hasName == 1) {
      return ShowDetails();
    }
    if (hasName == 2){
      return ChooseName();
    }
  }
}
