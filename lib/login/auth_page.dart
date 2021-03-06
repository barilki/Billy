import 'package:billy/login/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../icons/rounded_button.dart';
import 'log_page.dart';


class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}


class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackGroundColor,
        body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  kMainLogo,
                  kSmallLogo,
                  SizedBox(
                    height: 70.0,
                  ),
                  RoundedButton(
                    title: 'התחברות',
                      colour: Colors.black,
                      fontColour: Colors.white,
                      onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                      },
                  ),
                  RoundedButton(
                    title: 'הרשמה',
                    colour: Colors.black,
                    fontColour: Colors.white,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                    },
                  )
                ],
              ),
            )),
      );
  }
}

