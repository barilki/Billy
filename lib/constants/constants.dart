import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kBackGroundColor = Color(0xffd3d3d3);

//Text field Style
const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Color(0xFF8D8E98),
);

Text kMainLogo = Text(
  'Billy',
  style: GoogleFonts.sairaCondensed(
      fontSize: 90.0,
      color: Colors.white,
      fontWeight: FontWeight.w200,
      shadows: [
        Shadow(
          blurRadius: 7,
          color: Colors.black.withOpacity(0.1),
          offset: Offset(0, 5.0),
        ),
      ]),
);

Text kCompareLogo = Text('השוואת מחירים',
    style: GoogleFonts.rubik(
        fontSize: 40.0,
        color: Colors.lightBlue,
        fontWeight: FontWeight.w200,
        shadows: [
          Shadow(
            blurRadius: 7,
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 5.0),
          ),
        ]),
    textDirection: TextDirection.ltr);

const kSmallLogo = Text(
  "Now it's easy to save",
  style: TextStyle(
    color: Colors.lightBlue,
    fontSize: 20.0,
    letterSpacing: 2.5,
    fontWeight: FontWeight.bold,
  ),
);
