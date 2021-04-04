import 'package:billy/components/constants.dart';
import 'package:billy/ocrpage.dart';
import 'package:billy/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MainCompanies extends StatefulWidget {
  final String companyName;
  final String text;
  static Future<String> sharedPrefTxt = SharedPrefs.getKey('filteredTxt');

  MainCompanies({Key key, this.companyName, this.text}) : super(key: key);

  @override
  _MainCompaniesState createState() =>
      _MainCompaniesState(companyName: this.companyName, text: this.text);
}

class _MainCompaniesState extends State<MainCompanies> {
  String companyName;
  String text;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _MainCompaniesState({this.companyName, this.text});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    var uid = user.uid;
    setCompany();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackGroundColor,
        title: Text(companyName),
      ),
      body: new InvoicesList(),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.red,
        closeManually: true,
        child: Icon(Icons.add),
        children: [
          SpeedDialChild(
              child: Icon(Icons.camera),
              label: "Upload Photo",
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OcrPage(
                          companyName: companyName,
                        )));
              }
          ),
          SpeedDialChild(
            child: Icon(Icons.mail),
            label: "Extract From Mail",
            onTap: () => print('a'),
          ),
          SpeedDialChild(
            child: Icon(Icons.assignment_rounded),
            label: "Manually Add",
            onTap: () async {
              await showInformationDialog(context);
            }
          )
        ],
      ),
    );
  }

//Set company name with Shared Preference
  void setCompany() {
    SharedPrefs.setCompanyName('compName', companyName);
  }

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(context: context,
        builder: (context){
          final TextEditingController _textEditingController = TextEditingController();
          bool isChecked = false;
          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value){
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration: InputDecoration(hintText: "Enter Client ID:"),
                      ),
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value){
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration: InputDecoration(hintText: "Enter Invoice ID:"),
                      ),
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value){
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration: InputDecoration(hintText: "Enter Invoice Date:"),
                      ),
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value){
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration: InputDecoration(hintText: "Enter Invoice Total Sum:"),
                      ),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('Okay'),
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      // Do something like updating SharedPreferences or User Settings etc.
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
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    var uid = user.uid;
    return new StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection('IEC')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.docs.map((document) {
            return new ListTile(
              title: new Text(document.data()['date']),
              subtitle: new Text(document.data()['price']),
              trailing: Icon(Icons.image),
            );
          }).toList(),
        );
      },
    );
  }
}
