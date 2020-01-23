import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_task/CodeScreen.dart';
import 'package:game_task/GSignIn.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInTest extends StatefulWidget {
  @override
  _SignInTestState createState() => _SignInTestState();
}

class _SignInTestState extends State<SignInTest> {
  var _result;
  var _name;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _googleSignIn.isSignedIn().then((onValue) {
      setState(() {
        _result = onValue;
      });
    });
    FirebaseAuth.instance.currentUser().then((user){
      setState(() {
        _name = user.displayName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_result == true) {
      return CodePage(
        name: _name,
      );
    }
    if (_result == false) {
      return GSignIn();
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
      ),
    );
  }
}
