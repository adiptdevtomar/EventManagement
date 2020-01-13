import 'package:flutter/material.dart';

class TestCase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Container(
        color: Colors.lime,
        child: Text("Aparna"),
      ),
    );
  }
}
