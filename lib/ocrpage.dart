import 'dart:io';
import 'package:billy/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'companies/ocr_companies.dart';

class OcrPage extends StatefulWidget {
  String companyName;
  OcrPage({this.companyName});

  @override
  _OcrPageState createState() => _OcrPageState(companyName: companyName);
}

class _OcrPageState extends State<OcrPage> {
  bool _scanning = false;
  String _extractText = '';
  String companyName;
  File _pickedImage;

  _OcrPageState({@required this.companyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text('Tesseract OCR'),
      ),
      body: ListView(
        children: [
          _pickedImage == null
              ? Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image,
                    size: 100,
                  ),
                )
              : Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: FileImage(_pickedImage),
                        fit: BoxFit.fill,
                      )),
                ),
          Row(
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: Text(
                    'Add file',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  child: Text(
                    'Open camera to scan',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      _scanning = true;
                    });
                    _pickedImage = await ImagePicker.pickImage(
                        source: ImageSource.gallery);

                    //Get current user name
                    var user = FirebaseAuth.instance.currentUser;

                    // //Create a Storage Ref / username
                    // var storageRef = FirebaseStorage.instance
                    //     .ref("$user/$companyName/partner.pdf");
                    // storageRef.putFile(_pickedImage);

                    _extractText = await TesseractOcr.extractText(
                        _pickedImage.path,
                        language: "Hebrew");
                    await strReg(_extractText);
                    setState(() {
                      _scanning = false;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _scanning
              ? Center(child: CircularProgressIndicator())
              : Icon(
                  Icons.done,
                  size: 40,
                  color: Colors.green,
                ),
          SizedBox(height: 20),
          Center(
            child: FutureBuilder<String>(
                future: SharedPrefs.getKey("filteredTxt"),
                builder: (context, snapshot) {
                  return Text(snapshot.data ?? ""
                      // strReg(_extractText).toString(),
                      // textAlign: TextAlign.center,
                      // style: TextStyle(
                      //   fontSize: 30,
                      //   fontWeight: FontWeight.bold,
                      );
                }),
          )
        ],
      ),
    );
  }

//Retrieving information according to the company required
  void getDetails() async {
    Future<String> companyName = SharedPrefs.getCompanyName('compName');
    if (await companyName == 'IEC') {
      OcrCompanies(
          pickedImage: _pickedImage,
          companyName: await companyName,
          text: await SharedPrefs.getKey('filteredTxt'),
          startWordForSum: 'לתשלום שח',
          endWordForSum: 'בהוצאות',
          startWordForDate: 'מ-',
          endWordForDate: 'תאריך עריכת החשבון',
          startWordForID: 'חשבון חוזה',
          endWordForID: 'חשבון לתקופה')
          .insertDetails();
    } else if (await companyName == 'Water company') {
      print("a");
    } else if (await companyName == 'Gas company') {
      print("b");
    } else if (await companyName == 'Property Taxes company') {
      print("c");
    } else if (await companyName == 'Cellular company') {
      print("d");
    } else if (await companyName == 'TV company') {
      print("e");
    }
  }


  //Regex getting string
  strReg(String str) async {
    String newStr = str.replaceAll(RegExp('[a-zA-Z!-,:-@[-`{-~]'), '');
    await SharedPrefs.setKey('filteredTxt', newStr);
    getDetails();
  }
}


