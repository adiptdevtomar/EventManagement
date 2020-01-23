import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_task/CodeScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GSignIn extends StatefulWidget {
  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GSignIn> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser userDetails =
        await _firebaseAuth.signInWithCredential(credential);
    ProviderDetails providerInfo = new ProviderDetails(userDetails.providerId);

    List<ProviderDetails> providerData = new List<ProviderDetails>();
    providerData.add(providerInfo);

    UserDetails details = new UserDetails(
      userDetails.providerId,
      userDetails.displayName,
      userDetails.photoUrl,
      userDetails.email,
      providerData,
    );
    Navigator.push(

      context,
      new MaterialPageRoute(
        builder: (context) => new CodePage(name: userDetails.displayName),
      ),
    );
    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: SizedBox(
              width: 150.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black,width: 2.0),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.google,color: Colors.black),
                    SizedBox(width: 10.0,),
                    Text("Sign IN",style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold))
                    /*Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "Sign in With ",style: TextStyle(fontSize: 25.0)),
                          *//*TextSpan(text: "Sign",style: TextStyle(fontSize: 25.0,color: Colors.blue)),
                          TextSpan(text: " in ",style: TextStyle(fontSize: 25.0,color: Colors.yellow)),
                          TextSpan(text: "With ",style: TextStyle(fontSize: 25.0,color: Colors.red)),*//*
                          TextSpan(text: "G",style: TextStyle(fontSize: 25.0,color: Colors.blue)),
                          TextSpan(text: "o",style: TextStyle(fontSize: 25.0,color: Colors.red)),
                          TextSpan(text: "o",style: TextStyle(fontSize: 25.0,color: Colors.yellow)),
                          TextSpan(text: "g",style: TextStyle(fontSize: 25.0,color: Colors.blue)),
                          TextSpan(text: "l",style: TextStyle(fontSize: 25.0,color: Colors.green)),
                          TextSpan(text: "e",style: TextStyle(fontSize: 25.0,color: Colors.red)),
                        ]
                      )
                    ),*/
                  ],
                ),
                color: Colors.white,
                onPressed: () {
                  _signIn(context)
                      .then((FirebaseUser user) => print(user))
                      .catchError((e) => print(e));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);

  final String providerDetails;
}
