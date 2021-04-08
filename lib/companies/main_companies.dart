import 'package:billy/components/constants.dart';
import 'package:billy/ocrpage.dart';
import 'package:billy/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MainCompanies extends StatefulWidget {
  final String companyName;
  final String text;
  static Future<String> sharedPrefTxt = SharedPrefs.getKey('filteredTxt');
  MainCompanies({Key key, this.companyName, this.text}) : super(key: key);

  @override
  _MainCompaniesState createState() => _MainCompaniesState();
}

class _MainCompaniesState extends State<MainCompanies> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackGroundColor,
        title: Text(widget.companyName),
      ),
      body: new InvoicesList(
        companyName: widget.companyName,
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.red,
        closeManually: true,
        child: Icon(Icons.add),
        children: [
          SpeedDialChild(
              child: Icon(Icons.camera),
              backgroundColor: Colors.green,
              label: "Upload Photo",
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            OcrPage(
                              companyName: widget.companyName,
                            )));
              }),
          SpeedDialChild(
            child: Icon(Icons.mail),
            backgroundColor: Colors.yellow,
            label: "Extract From Mail",
            onTap: () => print('a'),
          ),
          SpeedDialChild(
              child: Icon(Icons.assignment_rounded),
              backgroundColor: Colors.black,
              label: "Manually Add",
              onTap: () async {
                await showInformationDialog(context);
              }),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Text("Total Invoices sum: " + InvoicesList.sum.toString() + " ₪")
          ],
        ),
      ),
    );
  }

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          String clientID, invoiceID, invoiceDate,invoiceSum;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        validator: (value) {
                          clientID = value;
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration:
                        InputDecoration(hintText: "Enter Client ID:"),
                      ),
                      TextFormField(
                        validator: (value) {
                          invoiceID = value;
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration:
                        InputDecoration(hintText: "Enter Invoice ID:"),
                      ),
                      TextFormField(
                        validator: (value) {
                          invoiceDate = value;
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration:
                        InputDecoration(hintText: "Enter Invoice Date:"),
                      ),
                      TextFormField(
                        validator: (value) {
                          invoiceSum = value;
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Invoice Total Sum:"),
                      ),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.uid)
                          .collection(widget.companyName)
                          .add({
                        "clientID": clientID,
                        "invoiceID": invoiceID,
                        "invoiceDate": invoiceDate,
                        "invoiceSum": invoiceSum
                      });
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }
}

class InvoicesList extends StatelessWidget {
  final String companyName;
  static int sum = 0; //sum for counting total invoices sum
  InvoicesList({this.companyName});
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(_MainCompaniesState.user.uid)
            .collection(companyName)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          //snapshot to calculate invoices total sum
          snapshot.data.docs.forEach((element) {
            sum = sum + int.parse(element.data()['invoiceSum']);
          });
          return new ListView(
            children: snapshot.data.docs.map((document) {
              return new ListTile(
                title: new Text("Date: " + document.data()['invoiceDate']),
                subtitle: Row(
                  children: [
                    new Text("Price: " + document.data()['invoiceSum']),
                    SizedBox(width: 10.0),
                    new Text("Invoice ID: " + document.data()['invoiceID']),
                    SizedBox(width: 10.0),
                    new Text("Client ID: " + document.data()['clientID']),
                  ],
                ),
                trailing: IconButton(
                  icon: new Icon(Icons.image),
                  onPressed: () async {
                    //print(await document.data()['url']);
                  },
                  color: Colors.orange,
                ),
                leading: Icon(Icons.bolt, color: Colors.yellow),
                horizontalTitleGap: 10.0,
              );
            }).toList(),

          );
        }
    );
  }



}

