
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/constants.dart';
import 'components/rounded_button.dart';
import 'package:billy/login_page.dart';
import 'package:billy/register_page.dart';


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
                    title: 'Sign In',
                      colour: Colors.black,
                      fontColour: Colors.white,
                      onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                      },
                  ),
                  RoundedButton(
                    title: 'Sign up',
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

