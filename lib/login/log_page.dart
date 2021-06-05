import 'package:billy/billymain_page.dart';
import 'package:billy/icons/rounded_button.dart';
import 'package:billy/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showSpinner = true;


  String _email, _password;
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackGroundColor,
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                kMainLogo,
                kSmallLogo,
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your username'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
                ),
                showSpinner? RoundedButton(
                  title: 'Log In',
                  colour: Colors.black,
                  fontColour: Colors.white,
                  onPressed: () async {
                    try {
                      setState(() {
                        showSpinnerFlag();
                      });
                      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BillyMainPage()));
                      setState(() {
                        showSpinnerFlag();
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }

                  },
                ): Column(
                  children: [
                    SizedBox(height: 15),
                    Center(
                      child:CircularProgressIndicator(backgroundColor: Colors.amber,),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Show the spinner
  void showSpinnerFlag(){
    showSpinner = !showSpinner;
  }

}
