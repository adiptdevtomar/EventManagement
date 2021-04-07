import 'package:flutter/material.dart';

class MoreInfo extends StatefulWidget {
  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Text(
                    "A TEDx event is a local gathering where live TED-like talks and performances are shared with the community. TEDx events are fully planned and coordinated independently, on a community-by-community basis. The content and design of each TEDx event is unique and developed independently, but all of them have features in common"),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "What a TEDx event is not:",
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                ),
                Text(
                    "A TEDx event isn’t an industry or marketing conference.\n1) It isn’t limited to one topic or field. It isn’t used to sell something.\n2) A TEDx event is not organized by or for special-interest political, religious or commercial groups.\n3) A TEDx event cannot be used to raise money, not even for a charity.\n4) A TEDx event cannot partner with another conference or event.\n5) A TEDx event can’t be co-branded with an institution except under specific license types – for a college or university, or for internal events (for corporations and organizations).\n6) A TEDx event is not a platform for professional or circuit speakers, such as motivational speakers and professional life coaches. Its purpose is to give a platform to those who don’t often have one.\n7) A TEDx event is not focused solely on entrepreneurship, business or technology. Diversity of topics is key!"),
              ],
            )),
      ),
    );
  }
}
