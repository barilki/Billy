import 'dart:convert';

import 'package:billy/components/company_list.dart';
import 'file:///D:/flutter_projects/building_key/lib/components/constants.dart';
import 'package:billy/components/pie_chart_page.dart';
import 'package:billy/components/pie_chart_sections.dart';
import 'package:billy/ocrpage.dart';
import 'package:billy/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_picker/Picker.dart';
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
  final TextEditingController _search = new TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');
  final TextEditingController _filter = new TextEditingController();
  String searchInput = "";
  DateTime _dateTime;

  // TextField(
  // decoration: InputDecoration(
  // prefixIcon: Icon(Icons.search), hintText: "Search..."),
  // onChanged: (val){
  // setState(() {
  // searchInput = val;
  // });
  // },
  // )

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kBackGroundColor,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.companyName),
              TextField(
                decoration: InputDecoration(hintText: "Search..."),
                onChanged: (val) {
                  setState(() {
                    searchInput = val;
                  });
                },
              ),
            ],
          )),
      body: company_list(
          companyName: widget.companyName, searchResults: searchInput),
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
                        builder: (context) => OcrPage(
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
          SpeedDialChild(
              child: Icon(Icons.pie_chart),
              backgroundColor: Colors.blue,
              label: "Statistic",
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PieChartPage()));
              }),
        ],
      ),
    );
  }

  Future<Text> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          String clientID, invoiceID, invoiceDate, invoiceSum;
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
