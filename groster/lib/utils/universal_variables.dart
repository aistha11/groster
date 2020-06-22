import 'package:flutter/material.dart';

class UniversalVariables {
  static final Color blueColor = Color(0xff2b9ed4);
  static final Color blackColor = Color(0xff19191b);
  static final Color greyColor = Color(0xff8f8f8f);
  static final Color userCircleBackground = Color(0xff2b2b33);
  static final Color onlineDotColor = Color(0xff46dc64);
  static final Color lightBlueColor = Color(0xff0077d7);
  static final Color separatorColor = Color(0xff272c35);

  static final Color gradientColorStart = Color(0xff00b6f3);
  static final Color gradientColorEnd = Color(0xff0184dc);

  static final Color senderColor = Color(0xff2b343b);
  static final Color receiverColor = Color(0xff1e2225);

  static final Gradient fabGradient = LinearGradient(
      colors: [gradientColorStart, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
  //For appBar
  static final Color mainCol = Color.fromRGBO(73, 222, 135,1.0);
  //For Scaffold Background
  static final Color backgroundCol = Colors.white;
  //Icon, Save, Search
  static final Color iconCol = Color.fromRGBO(239, 213, 96, 1.0);
  //secondary color
  static final Color secondCol = Color.fromRGBO(239, 213, 96, 1.0);
  //For UserTitle Color
  static final Color titCol = Colors.black;
  //For Profile Icon Edit Color
  static final Color iconProfileCol = Color.fromRGBO(239, 213, 96, 0.8);
  //For User last message color
  static final Color lastMsgCol = Colors.black26;
}
