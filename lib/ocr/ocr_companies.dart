import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
  Future <String> sum;
  Future <String> billNumber;
  Future <String> date;
  Future <String> expDate;

  OcrCompanies({
    this.pickedImage,
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
  }) {
    if (companyName == 'חברת חשמל'){this.getDataIEC();}
  }

  // //add current details to collection into firestore
  // Future<void> insertDetails() async {
  //   var user = FirebaseAuth.instance.currentUser;
  //   var uid = user.uid;
  //   String invoiceID = await getID(); //get current invoice id (futrue type)
  //   String path = "$user/$companyName/$invoiceID.jpeg"; //String of path
  //   var storageRef = FirebaseStorage.instance.ref("$path".replaceAll(RegExp("\\s+"),"")); //Create a Storage Ref / username
  //   storageRef.putFile(pickedImage); //Upload photo to firebase storage
  //   String url = await (storageRef.getDownloadURL());
  //   final CollectionReference vaultCollection = FirebaseFirestore.instance.collection('users').doc(uid).collection(companyName);
  //   vaultCollection.add({"invoiceDate": await getDate(), "invoiceID": await getID(), "invoiceSum": await getSum(), "invoiceUrl": url});
  // }


  //Extract data from IEC invoice
  Future<void> getDataIEC() async {
    String validateDate = "((0[1-9])|([1-2][0-9])|(3[0-1]))/((0[1-9])|(1[0-2]))/[0-9]{4}";
    Future<String> temp;
    //Getting price
    sum = regEx(r"[0-9]+[.][0-9]+",filterText(firstWordSum, lastWordSum));
    //Getting invoice number
    temp = regEx(r"[-][0-9]+",filterText(firstWordBillNo, lastWordBillNo));
    billNumber = regEx(r"[0-9]+", await temp);
    //Getting date
    date = regEx(validateDate , filterText(firstWordDate, lastWordDate));
    //Getting expiration date
    expDate = regEx(validateDate, filterText(firstWordExpDate, lastWordExpDate));

    print(filterText(firstWordExpDate, lastWordExpDate));

    print("SUM: " + await sum);

    print("BILL NUMBER: " + await billNumber);

    print("DATE: " + await date);

    print("expDate: " + await expDate);
  }

  //Using Regular expression to get specific text
  Future <String> regEx(String pat, String txt) async {
    final pattern = pat;
    final regEx = RegExp(pattern, multiLine: true);
    final newText = regEx.allMatches(txt.toString()).map((m) => m.group(0)).join(' ');
  return newText;
  }

  //Filter text between two characters
  String filterText(String firstWord, String lastWord){
    final startIndex = text.indexOf(firstWord);
    final endIndex = text.indexOf(lastWord, startIndex + firstWord.length);
    print("FILTER");
    return text.substring(startIndex + firstWord.length, endIndex);
  }


}

