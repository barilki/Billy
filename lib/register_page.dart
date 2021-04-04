import 'package:billy/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'components/constants.dart';
import 'components/rounded_button.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showSpinner = false;

  String _email, _password;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackGroundColor,
      body: Form(
        key: _formKey,
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
                TextFormField(
                  textAlign: TextAlign.center,
                  validator: emailValidator,
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
                TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  validator: pwdValidator,
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });

                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
                ),
                RoundedButton(
                  title: 'Register',
                  colour: Colors.black,
                  fontColour: Colors.white,
                  onPressed: (){
                    if (_formKey.currentState.validate()) {
                      _auth.createUserWithEmailAndPassword(
                          email: _email, password: _password);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid, example: email@example.com';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'Password must be longer than 6 characters';
    } else {
      return null;
    }
  }
}
