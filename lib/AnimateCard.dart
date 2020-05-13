import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimateCard extends StatefulWidget {
  @override
  _AnimateCardState createState() => _AnimateCardState();
}

class _AnimateCardState extends State<AnimateCard>
    with TickerProviderStateMixin {
  bool red = false;
  bool orange = false;
  bool blue = false;
  bool indigo = false;

  AnimationController animCont;
  Animation heightAnim;
  Animation widthAnim;
  Animation animBox;
  Animation animTapH;
  Animation animTapW;
  Animation angleAnim;

  @override
  void initState() {
    animCont = AnimationController(duration: Duration(seconds: 1), vsync: this);

    angleAnim = Tween(begin: math.pi / 4, end: 0.0).animate(animCont)
      ..addListener(() {
        setState(() {});
      });

    animBox = Tween(begin: 120.0, end: 0.0).animate(animCont)
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    animTapW = Tween(begin: 120.0, end: MediaQuery.of(context).size.width)
        .animate(animCont)
          ..addListener(() {
            setState(() {});
          });

    animTapH = Tween(begin: 120.0, end: MediaQuery.of(context).size.height)
        .animate(animCont)
          ..addListener(() {
            setState(() {});
          });

    heightAnim = Tween(begin: 240.0, end: MediaQuery.of(context).size.height)
        .animate(animCont)
          ..addListener(() {
            setState(() {});
          });

    widthAnim = Tween(begin: 240.0, end: MediaQuery.of(context).size.width)
        .animate(animCont)
          ..addListener(() {
            setState(() {});
          });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Transform.rotate(
        angle: angleAnim.value,
        child: Container(
          height: heightAnim.value,
          width: widthAnim.value,
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        animCont.forward();
                        orange = true;
                      },
                      onDoubleTap: (){
                        animCont.reverse().whenComplete((){
                          orange = false;
                        });
                      },
                      child: Container(
                        color: Colors.orange,
                        height:
                            (orange == true) ? animTapH.value : animBox.value,
                        width:
                            (orange == true) ? animTapW.value : animBox.value,
                        child: (animCont.status == AnimationStatus.completed)?Center(child: Text("Double Tap")):Text(""),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        animCont.forward();
                        red = true;
                      },
                      onDoubleTap: (){
                        animCont.reverse().whenComplete((){
                          red = false;
                        });
                      },
                      child: Container(
                        color: Colors.red,
                        height: (red == true) ? animTapH.value : animBox.value,
                        width: (red == true) ? animTapW.value : animBox.value,
                        child: (animCont.status == AnimationStatus.completed)?Center(child: Text("Double Tap")):Text(""),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        animCont.forward();
                        blue = true;
                      },
                      onDoubleTap: (){
                        animCont.reverse().whenComplete((){
                          blue = false;
                        });
                      },
                      child: Container(
                        color: Colors.blue,
                        height: (blue == true) ? animTapH.value : animBox.value,
                        width: (blue == true) ? animTapW.value : animBox.value,
                        child: (animCont.status == AnimationStatus.completed)?Center(child: Text("Double Tap")):Text(""),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        animCont.forward();
                        indigo = true;
                      },
                      onDoubleTap: (){
                        animCont.reverse().whenComplete((){
                          indigo = false;
                        });
                      },
                      child: Container(
                        color: Colors.indigo,
                        height: (indigo == true) ? animTapH.value : animBox.value,
                        width: (indigo == true) ? animTapW.value : animBox.value,
                        child: (animCont.status == AnimationStatus.completed)?Center(child: Text("Double Tap")):Text(""),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
