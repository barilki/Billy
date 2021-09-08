import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class OcrCompanies {
  final File pickedImage;
  final String companyName;
  final String text;
  final String startWordForSum;
  final String endWordForSum;
  final String startWordForDate;
  final String endWordForDate;
  final String startWordForDueDate;
  final String endWordForDueDate;
  final String startWordForID;
  final String endWordForID;

  OcrCompanies({
    @required this.pickedImage,
    @required this.companyName,
    @required this.text,
    @required this.startWordForSum,
    @required this.endWordForSum,
    @required this.startWordForDate,
    @required this.endWordForDate,
    @required this.startWordForDueDate,
    @required this.endWordForDueDate,
    @required this.startWordForID,
    @required this.endWordForID,
  });

  //add current details to collection into Firestore
  Future<void> insertDetails() async {
    var user = FirebaseAuth.instance.currentUser;
    var uid = user.uid;
    String invoiceID = await getID(); //get current invoice id (futrue type)
    String path = "$user/$companyName/$invoiceID.jpeg"; //String of path
    var storageRef = FirebaseStorage.instance.ref("$path".replaceAll(RegExp("\\s+"),"")); //Create a Storage Ref / username
    storageRef.putFile(pickedImage); //Upload photo to firebase storage
    String url = await (storageRef.getDownloadURL());
    final CollectionReference vaultCollection = FirebaseFirestore.instance.collection('users').doc(uid).collection(companyName);
    vaultCollection.add({"invoiceDate": await getDate(), "invoiceDueDate": await getDueDate(), "invoiceID": await getID(), "invoiceSum": await getSum(), "invoiceUrl": url});
  }

  //return sum from invoice
  Future<String> getSum() async {
    final startIndex = text.indexOf(startWordForSum);
    final endIndex = text.indexOf(endWordForSum, startIndex + startWordForSum.length);
    print(text.substring(startIndex + startWordForSum.length, endIndex));
    return text.substring(startIndex + startWordForSum.length, endIndex);
  }

  //return date from invoice
  Future<String> getDate() async {
    final startIndex = await text.indexOf(startWordForDate);
    final endIndex = await text.indexOf(endWordForDate, startIndex + startWordForDate.length);
    return text.substring(startIndex + startWordForDate.length, endIndex);
  }

  //return due date from invoice
  Future<String> getDueDate() async {
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

