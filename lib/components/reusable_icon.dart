import 'package:flutter/material.dart';

class ReusableIcon extends StatelessWidget {
  ReusableIcon({@required this.colour, this.cardChild, this.onPress});

  final Color colour;
  final Widget cardChild;
  final Function onPress;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: cardChild,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 5), )],
            color: colour,
            //borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}