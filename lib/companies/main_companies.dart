import 'dart:io';
import 'package:billy/chart/pie_chart_page.dart';
import 'package:billy/companies/company_list.dart';
import 'package:billy/constants/constants.dart';
import 'package:billy/ocrpage.dart';
import 'package:billy/scraper/main_scraping.dart';
import 'package:billy/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';

class MainCompanies extends StatefulWidget {
  final String companyName;
  final String text;
  static Future<String> sharedPrefTxt = SharedPrefs.getKey('filteredTxt');

  MainCompanies({Key key, this.companyName, this.text}) : super(key: key);

  @override
  _MainCompaniesState createState() => _MainCompaniesState();
}

class _MainCompaniesState extends State<MainCompanies> {
  static String clientID, invoiceID, invoiceDate, invoiceSum;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _search = new TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _filter = new TextEditingController();
  String searchInput = "";
  File _pickedImage;
  static const List<String> choices = <String>['invoiceID','invoiceSum','invoiceDate'];
  String sortBy = "invoiceID";

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
              SizedBox(height: 10),
              Text(widget.companyName),
              TextField(
                decoration: InputDecoration(hintText: "Search"),
                onChanged: (val) {
                  setState(() {
                    searchInput = val;
                  });
                },
              ),
            ],
          ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: CompanyList(companyName: widget.companyName, searchResults: searchInput, sortBy: sortBy),
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
          SpeedDialChild(
              child: Icon(Icons.details),
              backgroundColor: Colors.blueGrey,
              label: "About Us",
              onTap: () async {
                //aboutUs(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainScraping()));
              }),
        ],
      ),
    );
  }

  Future<Text> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
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
                Row(
                  children: [
                    //Image picker from gallery
                    IconButton(icon: Icon(Icons.upload_file,color: Colors.orangeAccent), onPressed: () async{
                      _pickedImage = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                    }),
                    //Image picker from camera
                    IconButton(icon: Icon(Icons.camera_alt,color: Colors.orangeAccent), onPressed: () async{
                      _pickedImage = await ImagePicker.pickImage(
                          source: ImageSource.camera);
                    }),
                    Row(
                      children: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Done'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(user.uid)
                                  .collection(widget.companyName)
                                  .add({
                                "clientID": clientID,
                                "invoiceID": invoiceID,
                                "invoiceDate": invoiceDate,
                                "invoiceSum": invoiceSum,
                                "invoiceUrl": await photoStorage(),
                              });
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }

  //Get url as a string and open inside alert dialog
  Future<void> aboutUs(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Application Build by Shay Manasherov & Bar-ilan Kimbarovski'),
                  Text('Contact us via mail: billy@gmail.com'),
                ],
              ),
            );
          });
        });
  }

  //Upload photo to storage from manual add
  photoStorage() async{
    if (_pickedImage != null) {
      String comp = widget.companyName;
      String path = "$user/$comp/$invoiceID.jpeg"; //String of path
      var storageRef = FirebaseStorage.instance.ref("$path".replaceAll(
          RegExp("\\s+"), "")); //Create a Storage Ref / username
      await storageRef.putFile(_pickedImage); //Upload photo to firebase storage
      String url = await (storageRef.getDownloadURL());
      return url;
    }
  }

  // get user choice from filter list
  void choiceAction(String choice) {
    if (choice == 'invoiceID') {
      sortBy = 'invoiceID';
    } else if (choice == 'invoiceDate') {
      sortBy = 'invoiceDate';
    } else if (choice == 'invoiceSum') {
      sortBy = 'invoiceSum';
    }
  }
}
