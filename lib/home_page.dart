import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(title,style: TextStyle(color: Colors.black),),
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
      ),
    );
  }
}
