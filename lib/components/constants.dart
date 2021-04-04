import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const kBackGroundColor = Colors.lightBlue;

//Text field Style
const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Color(0xFF8D8E98),
);


Text kMainLogo = Text('Billy',  style: GoogleFonts.sairaCondensed(
    fontSize: 90.0,
    color: Colors.white,
    fontWeight: FontWeight.w200,
    shadows: [ Shadow(
      blurRadius: 7,
      color: Colors.black.withOpacity(0.1),
      offset: Offset(0, 5.0),
    ),]
),);



const kSmallLogo = Text(
  'smart payment system',
  style: TextStyle(
    color: Colors.amber,
    fontSize: 20.0,
    letterSpacing: 2.5,
    fontWeight: FontWeight.bold,
  ),
);
