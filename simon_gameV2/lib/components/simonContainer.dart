import 'package:flutter/material.dart';

class SimonContainer {
  SimonContainer({@required this.colour, @required this.onPressed,@required this.getNum});
  final Color colour;
  final Function onPressed;
  final Text getNum;

  final radius = BorderRadius.all(Radius.circular(60.0));

  Container getDecoration() {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: radius,
        color: colour,
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: radius),
        child: getNum,
        onPressed: onPressed,
      ),
    );
  }
}
