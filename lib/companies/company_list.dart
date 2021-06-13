import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:billy/components/payment_page.dart';
import 'package:billy/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyList extends StatelessWidget {
  final String companyName;
  final String searchResults;
  final String sortBy;
  static double count = 0; //sum for counting total invoices sum
  final user = FirebaseAuth.instance.currentUser;

  CompanyList({this.companyName, this.searchResults, this.sortBy});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: (searchResults != "" && searchResults != null)
              ? FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection(companyName)
              .where(sortBy, isGreaterThanOrEqualTo: searchResults)
              .where(sortBy, isLessThan: searchResults + 'z')
              .snapshots()
              : FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection(companyName)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading...');
            }
            return Scaffold(
              backgroundColor: kBackGroundColor,
              body: ListView(
                padding: EdgeInsets.all(1.0),
                children: snapshot.data.docs.map((document) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      title: Text("Date: " + document.data()['invoiceDate'],
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Invoice ID: " + document.data()['invoiceID'],
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 10),
                          Text("Sum: " + document.data()['invoiceSum'],
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.payment),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentPage(
                                          companyName,
                                          document.data()['invoiceID'],
                                          document.data()['invoiceSum'])));
                        },
                        color: Colors.green,
                      ),
                      // On long press delete document from list view and database
                      onLongPress: () {
                        deleteInvoice(context, document);
                      },
                      leading: IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () async {
                          String url = await document.data()['invoiceUrl'];
                          if (url != null) {
                            await urlPhoto(context, url);
                          }
                        },
                        color: Colors.orange,
                      ),
                      horizontalTitleGap: 10.0,
                    ),
                  );
                }).toList(),
              ),
            );
          }),
    );
  }

  //Get url as a string and open inside alert dialog
  Future<void> urlPhoto(BuildContext context, String url) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Row(children: [
                Image.network(
                  url,
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ]),
            );
          });
        });
  }

  //delete invoice from firebase
  Future<void> deleteInvoice(BuildContext context, document) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text('Are you sure want to delete this invoice?'),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Row(
                  children: [
                    TextButton(
                        child: Text('Yes'),
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection(companyName)
                              .doc(document.id)
                              .delete();
                          FirebaseStorage.instance
                              .refFromURL(document.data()['invoiceUrl'])
                              .delete();
                          Navigator.pop(context);
                        }),
                    TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ))
          ],
        );
      },
    );
  }
}

