import 'package:billy/components/payment_page.dart';
import 'package:billy/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:ui';

class CompanyList extends StatelessWidget {
  final String companyName;
  final String searchResults;
  final String sortBy;
  static double count = 0; //sum for counting total invoices sum
  final user = FirebaseAuth.instance.currentUser;
  static final DateTime now = DateTime.now();
  static final intl.DateFormat formatter = intl.DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(now);

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
              return Text('');
            }
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: kBackGroundColor,
              body: ListView(
                padding: EdgeInsets.all(1.0),
                children: snapshot.data.docs.map((document) {
                  return Container(
                    height: 80,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text("סכום: " + document.data()['invoiceSum'] + '₪',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),

                              ],
                            ),
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children: [
                              Text("תאריך: " + document.data()['invoiceDate'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              Text(
                                  "תאריך פירעון: " +
                                      document.data()['invoiceDueDate'],
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              Text("מספר חשבונית: " + document.data()['invoiceID'],
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          ),
                        ]
                        ),
                        // On press delete button, delete document from list view and database
                        trailing: IconButton(
                            alignment: Alignment.centerRight,
                            icon: Icon(Icons.image),
                            onPressed: () async {
                              String url = await document.data()['invoiceUrl'];
                              if (url != null) {
                                await urlPhoto(context, url);
                              }
                            },
                            color: Colors.orange,
                          ),

                        // On long press navigate to payment page
                        onLongPress: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentPage(companyName)));
                        },
                        leading: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              deleteInvoice(context, document);
                            },
                            color: Colors.red,
                          ),

                        horizontalTitleGap: 10.0,
                      ),
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
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height - 80,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Image.network(
                    url,
                    height: 700,
                    width: 700,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          );
        });
  }

  //delete invoice from firebase
  Future<void> deleteInvoice(BuildContext context, document) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text('האם ברצונך למחוק את החשבונית?',
              textDirection: TextDirection.rtl, style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            CupertinoDialogAction(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                      ),
                        child: Text("לא",style: TextStyle(fontSize: 16)),
                    ),
                    onTap: () async{
                      Navigator.of(context).pop(); // replace with your own functions
                    },
                  ),
            ),

            CupertinoDialogAction(
                child: GestureDetector(
                  child: Container(
                      child: Text("כן",style: TextStyle(fontSize: 16)),
                  ),
                  onTap: () async{

                    Navigator.pop(context);
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection(companyName)
                        .doc(document.id)
                        .delete();
                    FirebaseStorage.instance
                        .refFromURL(document.data()['invoiceUrl'])
                        .delete(); // replace with your own functions
                  },
                ),
            )

          ],
        );
      },
    );
  }
}
