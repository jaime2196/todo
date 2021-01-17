import 'package:flutter/material.dart';

class Util{

  static Widget getBackgrodundDismissible(IconData icon, MaterialColor color, bool izda){
    return Container(
        alignment: izda?Alignment.centerLeft:Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(icon),
        ),
        color:  color// Colors.red,
      );
  }
}