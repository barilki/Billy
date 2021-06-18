import 'dart:io';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:billy/chart/pie_chart_page.dart';
import 'package:billy/companies/company_list.dart';
import 'package:billy/constants/constants.dart';
import 'package:billy/ocr/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class MainCompanies extends StatefulWidget {
  final String companyName;
  final String text;

  MainCompanies({Key key, this.companyName, this.text}) : super(key: key);

  @override
  _MainCompaniesState createState() => _MainCompaniesState();
}

class _MainCompaniesState extends State<MainCompanies> {
  static String clientID, invoiceID, invoiceDate, invoiceSum, invoiceDueDate;
  String companyName;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;
  String searchInput = "";
  File _pickedImage;
  static const List<String> choices = <String>[
    'מספר חשבונית',
    'סכום',
    'תאריך',
    'תאריך פירעון'
  ];
  String sortBy = "invoiceID";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackGroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.companyName,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
            Spacer(
              flex: 1,
            ),
            Row(
              children: [
                SizedBox(
                  width: 130,
                  height: 40,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.datetime,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                        hintText: "חיפוש",
                        prefixIcon: Icon(Icons.search, size: 25),
                        fillColor: Colors.white70),
                    onChanged: (val) {
                      setState(() {
                        searchInput = val;
                      });
                    },
                  ),
                ),
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
            )
          ],
        ),
      ),
      body: CompanyList(
          companyName: widget.companyName,
          searchResults: searchInput,
          sortBy: sortBy),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.red,
        closeManually: true,
        child: Icon(Icons.add),
        children: [
          SpeedDialChild(
            child: Icon(Icons.camera),
            backgroundColor: Colors.green,
            label: "העלאת תמונה",
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MainOcr(companyName: widget.companyName)));
            },
          ),
          SpeedDialChild(
              child: Icon(Icons.assignment_rounded),
              backgroundColor: Colors.black,
              label: "הוספה ידנית",
              onTap: () async {
                await showInformationDialog(context);
              }),
          SpeedDialChild(
              child: Icon(Icons.pie_chart),
              backgroundColor: Colors.blue,
              label: "סטטיסטיקה",
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PieChartPage()));
              }),
          SpeedDialChild(
              child: Icon(Icons.details),
              backgroundColor: Colors.blueGrey,
              label: "עלינו",
              onTap: () async {
                aboutUs(context);
              }),
        ],
      ),
    );
  }

  //Manually add invoices Dialog
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
                        maxLength: 9,
                        validator: (value) {
                          clientID = value;
                          return value.isNotEmpty ? null : "שדה שגוי";
                        },
                        decoration:
                        InputDecoration(hintText: " :מספר לקוח"),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                      ),
                      TextFormField(
                        maxLength: 9,
                        validator: (value) {
                          invoiceID = value;
                          return value.isNotEmpty ? null : "שדה שגוי";
                        },
                        decoration:
                        InputDecoration(hintText: " :מספר חשבונית"),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                      ),
                      TextFormField(
                        validator: (value) {
                          String regForDate = '((0[1-9])|([1-2][0-9])|(3[0-1]))/((0[1-9])|(1[0-2]))/[0-9]{4}';
                          RegExp regExp = RegExp(regForDate);
                          invoiceDate = value;
                          return regExp.hasMatch(value)
                              ? null
                              : "שדה שגוי";
                        },
                        decoration:
                        InputDecoration(
                            hintText: "(dd/mm/yyyy) :תאריך"),
                        textAlign: TextAlign.right,
                      ),
                      TextFormField(
                        validator: (value) {
                          String regForDate = '((0[1-9])|([1-2][0-9])|(3[0-1]))/((0[1-9])|(1[0-2]))/[0-9]{4}';
                          RegExp regExp = RegExp(regForDate);
                          invoiceDueDate = value;
                          return regExp.hasMatch(value)
                              ? null
                              : "שדה שגוי";
                        },
                        decoration:
                        InputDecoration(
                            hintText: "(dd/mm/yyyy) :תאריך פירעון"),
                        textAlign: TextAlign.right,
                      ),
                      TextFormField(
                        maxLength: 5,
                        validator: (value) {
                          invoiceSum = value;
                          return value.isNotEmpty ? null : "שדה שגוי";
                        },
                        decoration: InputDecoration(
                            hintText: " :סכום"),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  )),
              actions: <Widget>[
                Row(
                  children: [
                    //Image picker from gallery
                    IconButton(
                        icon:
                        Icon(Icons.upload_file, color: Colors.orangeAccent),
                        onPressed: () async {
                          _pickedImage = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                        }),
                    //Image picker from camera
                    IconButton(
                        icon:
                        Icon(Icons.camera_alt, color: Colors.orangeAccent),
                        onPressed: () async {
                          _pickedImage = await ImagePicker.pickImage(
                              source: ImageSource.camera);
                        }),
                    Row(
                      children: [
                        TextButton(
                          child: Text('ביטול'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('בוצע'),
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
                                "invoiceDueDate": invoiceDueDate,
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
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      borderSide: BorderSide(color: Colors.lightBlue, width: 3),
      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      title: 'עלינו',
      desc: 'האפליקציה נוצרה ע"י שי מנשרוב ובר אילן קימברובסקי, לפרטים נוספים ניתן לפנות אלינו בדואר אלקטרוני: billy@gmail.com',
      showCloseIcon: true,
      //btnCancelOnPress: () {},
      btnOkOnPress: () {},
    )..show();
  }

//Upload photo to storage from manual add
photoStorage() async {
  if (_pickedImage != null) {
    String comp = widget.companyName;
    String userNew = user.uid;
    String path = "$userNew/$comp/$invoiceID.jpeg"; //String of path
    var storageRef = FirebaseStorage.instance.ref("$path"
        .replaceAll(RegExp("\\s+"), "")); //Create a Storage Ref / username
    await storageRef.putFile(_pickedImage); //Upload photo to firebase storage
    String url = await (storageRef.getDownloadURL());
    return url;
  }
}

// get user choice from filter list
void choiceAction(String choice) {
  if (choice == 'מספר חשבונית') {
    sortBy = 'invoiceID';
  } else if (choice == 'תאריך') {
    sortBy = 'invoiceDate';
  } else if (choice == 'תאריך פירעון') {
    sortBy = 'invoiceDueDate';
  } else if (choice == 'סכום') {
    sortBy = 'invoiceSum';
  }
}


}
