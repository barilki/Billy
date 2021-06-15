import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';


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

String userNameValidator(String value) {
  if (value.length > 15) {
    return 'Username must be shorter than 15 characters';
  } if (value.length < 2) {
    return 'Username must be longer than 2 characters';
  } else {
    return null;
  }
}

warningAlerts(BuildContext context,String msg) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    borderSide: BorderSide(color: Colors.red, width: 3),
    buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
    headerAnimationLoop: true,
    animType: AnimType.BOTTOMSLIDE,
    title: 'WARNING!',
    desc: msg,
    showCloseIcon: true,
    //btnCancelOnPress: () {},
    //btnOkOnPress: () {},
  )..show();
}

successAlert(BuildContext context,String msg) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.SUCCES,
    borderSide: BorderSide(color: Colors.green, width: 3),
    buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
    headerAnimationLoop: true,
    animType: AnimType.BOTTOMSLIDE,
    title: 'Success!',
    desc: msg,
    showCloseIcon: true,
    //btnCancelOnPress: () {},
    //btnOkOnPress: () {},
  )..show();
}