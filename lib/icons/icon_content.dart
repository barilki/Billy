import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconContent extends StatelessWidget {
  IconContent({@required this.img, this.label});

  final String img;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: Image.asset(
      'images/$img',
          width: 2.0,
          height: 2.0,
    ));
  }
}

//
// Container(
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// image: DecorationImage(
// fit: BoxFit.contain,
// image: AssetImage('images/$img'),
// )
