import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'package:billy/companies/main_companies.dart';

class OcrCompanies {
  final File pickedImage;
  final String companyName;
  final String text;
  final String firstWordSum;
  final String lastWordSum;
  final String firstWordBillNo;
  final String lastWordBillNo;
  final String firstWordDate;
  final String lastWordDate;
  final String firstWordExpDate;
  final String lastWordExpDate;
  String sum;
  String billNumber;
  String date;
  String expDate;
  BuildContext contextOcr;

  String validSum = "[0-9]+[.][0-9]+";
  String validSumPropertyTax = "[0-9]+[,][0-9]+";
  String validDate =
      "((0[1-9])|([1-2][0-9])|(3[0-1]))/((0[1-9])|(1[0-2]))/[0-9]{4}";
  String validDateGas =
      "((0[1-9])|([1-2][0-9])|(3[0-1]))/((0[1-9])|(1[0-2]))/[0-9]{2}";
  String validDatePropertyTax =  "((0[1-9])|(1[0-2]))-((0[1-9])|(1[0-2]))/[0-9]{4}";
  String validBillNumber = "[0-9]+";

  final user = FirebaseAuth.instance.currentUser;

  OcrCompanies(
      {this.pickedImage,
      this.companyName,
      this.text,
      this.firstWordSum,
      this.lastWordSum,
      this.firstWordBillNo,
      this.lastWordBillNo,
      this.firstWordDate,
      this.lastWordDate,
      this.firstWordExpDate,
      this.lastWordExpDate,
      this.contextOcr}) {
    print("COMPANY NAME" + companyName);
    if (companyName == 'חשמל') {
      this.getDataIEC();
    }
    if (companyName == 'מים') {
      this.getDataWater();
    }
    if (companyName == 'גז') {
      this.getDataGas();
    }
    if (companyName == 'ארנונה') {
      this.getDataPropertyTax();
    }
  }

  //add current details to collection into firestore
  Future<void> insertDetails() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection(companyName)
        .add({
      "invoiceID": billNumber,
      "invoiceDate": date,
      "invoiceDueDate": expDate,
      "invoiceSum": sum,
      "invoiceUrl": await photoStorage()
    });
    //Navigate to Invoice's list
    Navigator.of(contextOcr, rootNavigator: true).pop(contextOcr);
    // Navigator.pop(contextOcr);
  }

  photoStorage() async {
    if (pickedImage != null) {
      String comp = companyName;
      String userNew = user.uid;
      String bNumber = billNumber;
      String path = "$userNew/$comp/$bNumber.jpeg"; //String of path
      var storageRef = FirebaseStorage.instance.ref("$path"
          .replaceAll(RegExp("\\s+"), "")); //Create a Storage Ref / username
      await storageRef.putFile(pickedImage); //Upload photo to firebase storage
      String url = await (storageRef.getDownloadURL());
      return url;
    }
  }

  //Extract data from IEC invoice
  Future<void> getDataIEC() async {
    String temp;

    try {
      //Getting price
      sum = regEx(validSum, filterText(firstWordSum, lastWordSum));
      // if(valid(await sum,validSum)){print("SUM WORK");}

      //Getting invoice number
      temp = regEx("[-][0-9]+", filterText(firstWordBillNo, lastWordBillNo));
      billNumber = regEx(validBillNumber, temp);
      //Getting date
      date = regEx(validDate, filterText(firstWordDate, lastWordDate));
      //Getting expiration date
      expDate = regEx(validDate, filterText(firstWordExpDate, lastWordExpDate));

      print("SUM: " + sum);

      print("BILL NUMBER: " + billNumber);

      print("DATE: " + date);

      print("expDate: " + expDate);

      //Upload invoice data to Firebase
      insertDetails();
    } catch (e) {
      errorMsg();
    }
  }

  //Extract data from IEC invoice
  Future<void> getDataWater() async {
    try {
      //Getting sum
      var sumNew = regExLastMatch(
          filterText(firstWordSum, lastWordSum), RegExp(validSum));
      sum = sumNew.last;
      //Getting bill number
      String billNum = filterText(firstWordBillNo, lastWordBillNo).trim();
      billNumber = regEx('[0-9]+', billNum);
      //Getting expiration date
      date = regEx(validDate, filterText(firstWordDate, lastWordDate));
      //Getting expiration date
      expDate = regEx(validDate, filterText(firstWordExpDate, lastWordExpDate));
      print("TEST");
      print('SUM: ' + sum);
      print('BILL: ' + billNumber);
      print('DATE: ' + date);
      print('EXP DATE: ' + expDate);
      insertDetails();
    } catch (e) {
      errorMsg();
    }
  }

  //Extract data from gas invoice
  Future<void> getDataGas() async {
    String year, dateTemp;

    try {
      //Getting sum
      var sumNew = regExLastMatch(
          filterText(firstWordSum, lastWordSum), RegExp(validSum));
      sum = sumNew.last;
      //Getting bill number
      String billNum = filterText(firstWordBillNo, lastWordBillNo);
      billNumber = regEx('[0-9]+', billNum);
      //Getting date
      String dateNew =
          regEx(validDateGas, filterText(firstWordDate, lastWordDate));
      year = dateNew.substring(6); //extract year
      date = dateNew.substring(0, dateNew.length - 2) + "20$year";
      //Getting exp date
      var expDateNew = regExLastMatch(
          filterText(firstWordExpDate, lastWordExpDate), RegExp(validDateGas));
      dateTemp = expDateNew.last;
      year = dateTemp.substring(6); //extract year
      expDate = dateTemp.substring(0, dateTemp.length - 2) + "20$year";
      print("TEST");
      print('SUM: ' + sum);
      print('BILL: ' + billNumber);
      print('DATE: ' + date);
      print('EXP DATE: ' + expDate);

      insertDetails();
    } catch (e) {
      errorMsg();
    }
  }

  //Extract data from gas invoice
  Future<void> getDataPropertyTax() async {
    String sumTemp, dateTemp , year, month;
    try {
      //Get sum
      sum = regEx(validSum, filterText(firstWordSum, lastWordSum));
      //Get Bill number
      billNumber = regEx(validBillNumber, filterText(firstWordBillNo, lastWordBillNo));
      //Get date
      dateTemp = regEx(validDatePropertyTax, filterText(firstWordDate,lastWordDate));
      year = dateTemp.substring(6, dateTemp.length); //Get year
      month = dateTemp.substring(0, dateTemp.indexOf('-'));//Get month
      print("MONTH: " + month);
      date = "01/$month/$year";
      //Get exp date
      expDate = regEx(validDate, filterText(firstWordExpDate, lastWordExpDate));

      print("SUM: " + sum);

      print("BILL NUMBER: " + billNumber);

      print("DATE: " + date);

      print("expDate: " + expDate);

      insertDetails();
    } catch (e) {
      errorMsg();
    }

  }

  //Using Regular expression to get specific text
  String regEx(String pat, String txt) {
    final pattern = pat;
    final regEx = RegExp(pattern, multiLine: true);
    final newText = regEx.stringMatch(txt);
    // final newText = regEx.allMatches(txt.toString()).map((m) => m.group(0)).join(' ');
    return newText;
  }

  //Return the last regex match
  Iterable<String> regExLastMatch(String text, RegExp regExp) {
    return regExp.allMatches(text).map((m) => m.group(0));
  }

  //Filter text between two characters
  String filterText(String firstWord, String lastWord) {
    final startIndex = text.indexOf(firstWord);
    final endIndex = text.indexOf(lastWord, startIndex + firstWord.length);
    print("FILTER");
    return text.substring(startIndex + firstWord.length, endIndex);
  }

  //Validation with regEx
  bool valid(String str, String pattern) {
    final regEx = RegExp(pattern);
    return regEx.hasMatch(str);
  }

  //Dialog Pop-up
  AwesomeDialog dialog() {
    return AwesomeDialog(
      context: contextOcr,
      dialogType: DialogType.WARNING,
      borderSide: BorderSide(color: Colors.red, width: 3),
      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: true,
      animType: AnimType.BOTTOMSLIDE,
      title: '...אופס',
      desc: ".צלמו שוב את החשבונית לקבלת תוצאה מיטבית",
    )..show();
  }

  void errorMsg() async {
    print("TEST");

    //Display dialog if extract words process is unsuccessful
    dialog();
    //Refresh camera page if extract words process is unsuccessful
    Navigator.of(contextOcr)
        .pushNamedAndRemoveUntil('/camera', (Route<dynamic> route) => true);
  }
}
