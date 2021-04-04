import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main_companies.dart';

class OcrCompanies {
  final String companyName;
  final String text;
  final String startWordForSum;
  final String endWordForSum;
  final String startWordForDate;
  final String endWordForDate;
  final String startWordForID;
  final String endWordForID;

  OcrCompanies({
    @required this.companyName,
    @required this.text,
    @required this.startWordForSum,
    @required this.endWordForSum,
    @required this.startWordForDate,
    @required this.endWordForDate,
    @required this.startWordForID,
    @required this.endWordForID,
  });

  //add current details to collection into firestore
  insertDetails() async {
    var user = FirebaseAuth.instance.currentUser;
    var uid = user.uid;
    final CollectionReference vaultCollection = FirebaseFirestore.instance.collection('users').doc(uid).collection(companyName);
    vaultCollection.add({"date": await getDate(), "id": await getID(), "price": await getSum()});
  }

  //return sum from invoice
  Future<String> getSum() async {
    final startIndex = await text.indexOf(startWordForSum);
    final endIndex = await text.indexOf(endWordForSum, startIndex + startWordForSum.length);
    return text.substring(startIndex + startWordForSum.length, endIndex);
  }

  //return date from invoice
  Future<String> getDate() async {
    final startIndex = await text.indexOf(startWordForDate);
    final endIndex = await text.indexOf(endWordForDate, startIndex + startWordForDate.length);
    return text.substring(startIndex + startWordForDate.length, endIndex);
  }

  //return id from invoice
  Future<String> getID() async {
    final startIndex = await text.indexOf(startWordForID);
    final endIndex = await text.indexOf(endWordForID, startIndex + startWordForID.length);
    return text.substring(startIndex + startWordForID.length, endIndex);
  }

}

