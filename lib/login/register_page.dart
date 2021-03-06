import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:billy/validation.dart';

import 'log_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../icons/rounded_button.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showSpinner = false;
  String _email, _password, _user;
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
                    validator: userNameValidator,
                    onChanged: (value) {
                      setState(() {
                        _user = value.trim();
                      });

                    },
                    decoration: kTextFieldDecoration.copyWith(hintText: 'שם פרטי',prefixIcon: Icon(Icons.account_circle_sharp, color: Colors.white),)
                ),

                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  validator: emailValidator,
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'דואר אלקטרוני',prefixIcon: Icon(Icons.email, color: Colors.white),)
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
                  decoration: kTextFieldDecoration.copyWith(hintText: 'סיסמא',prefixIcon: Icon(Icons.lock, color: Colors.white),)
                ),
                RoundedButton(
                  title: 'הירשם',
                  colour: Colors.black,
                  fontColour: Colors.white,
                  onPressed: (){
                    if (_formKey.currentState.validate()) {
                        _auth.createUserWithEmailAndPassword(
                            email: _email, password: _password).then((res) {
                              _auth.currentUser.updateProfile(displayName: _user);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  LoginPage()));
                          successAlert(context, 'הרשמה בוצעה בהצלחה.');
                        }).catchError((e) {
                          warningAlerts(context, 'הדואר אלקטרוני נמצא כבר בשימוש.');
                        });
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

}
