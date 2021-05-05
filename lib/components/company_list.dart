import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class company_list extends StatelessWidget {
  final String companyName;
  final String searchResults;
  double count = 0;//sum for counting total invoices sum
  final user = FirebaseAuth.instance.currentUser;
  company_list({this.companyName, this.searchResults});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
          stream: (searchResults != "" && searchResults !=null)
          ? FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection(companyName).where("invoiceID" , isEqualTo: searchResults)
              .snapshots()
        :    FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection(companyName)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

            if (!snapshot.hasData) return new Text('Loading...');
            else {
              //Calculate Total invoice sum
              final documents = snapshot.data.docs;
              count = documents.fold(0, (s, n) => s + double.parse(n['invoiceSum']));
            }
            return Scaffold(
              bottomNavigationBar: BottomAppBar(child:Row(
                children: [
                  Text("Total Invoices sum: $count ₪"),
                ],
              ),),
              body: ListView(
                padding: EdgeInsets.all(5.0),
                children: snapshot.data.docs.map((document) {
                  return ListTile(
                    title: Text("Date: " + document.data()['invoiceDate']),
                    subtitle: Row(
                      children: [
                        Text("Sum: " + document.data()['invoiceSum']),
                        SizedBox(width: 10.0),
                        Text("Invoice ID: " + document.data()['invoiceID']),
                        SizedBox(width: 10.0),
                        //Text("Client ID: " + document.data()['clientID']),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.image),
                      onPressed: () async {
                        String url = await document.data()['invoiceUrl'];
                        if (url != null) {
                          await urlPhoto(context, url);
                        }
                      },
                      color: Colors.orange,
                    ),
                    // On long press delete document from list view and database
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                          content: Text('Are you sure want to delete this invoice?'),
                          actions: [
                            CupertinoDialogAction(child: Text('Yes'), onPressed: (){
                              FirebaseFirestore.instance.collection('users').doc(user.uid).collection(companyName).doc(document.id).delete();
                            }),
                            CupertinoDialogAction(child: Text('No'), onPressed: (){
                            }),
                          ],
                        ),
                      );
                    },
                    leading: Icon(Icons.bolt, color: Colors.yellow),
                    horizontalTitleGap: 10.0,
                  );
                }).toList(),
              ),
            );
          }
      ),
    );
  }

  //Get url as a string and open inside alert dialog
  Future<void> urlPhoto(BuildContext context,String url) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Row(
                  children:[
                    Image.network(url,
                      width: 250, height: 250, fit: BoxFit.contain,),
                  ]
              ),
            );
          });
        });
  }





}