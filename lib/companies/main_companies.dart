import 'package:billy/components/constants.dart';
import 'package:billy/ocrpage.dart';
import 'package:billy/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:search_app_bar/search_app_bar.dart';


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
  final TextEditingController _search = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackGroundColor,
        title: Text(widget.companyName),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {
            setState(() {
              searchList();
            });
          })
        ],
      ),
      body: InvoicesList(companyName: widget.companyName),
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
    );
  }





  Future<Text> showInformationDialog(BuildContext context) async {
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

  void searchList() {
    TextField(
      controller: _search,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Search',
        prefixIcon: Icon(Icons.scanner),
      ),
    );
  }

}

class InvoicesList extends StatelessWidget {
  final String companyName;
  double count = 0;//sum for counting total invoices sum
  InvoicesList({this.companyName});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(_MainCompaniesState.user.uid)
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
                      FirebaseFirestore.instance.collection('users').doc(_MainCompaniesState.user.uid).collection(companyName).doc(document.id).delete();
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