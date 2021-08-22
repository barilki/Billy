import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:billy/constants/constants.dart';
import 'package:image/image.dart' as imagePack;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'ocr_companies.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;
  final String companyName;

  DetailScreen({this.imagePath, this.companyName});

  @override
  _DetailScreenState createState() => _DetailScreenState(imagePath);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(this.path);

  final String path;

  Size _imageSize;
  String recognizedText = "loading..";

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    // Fetching image from path
    final Image image = Image.file(imageFile);

    // Retrieving its size
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  void _initializeVision() async {
    final File imageFile = File(path);

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    //Support Language: Hebrew, English
    const options = CloudDocumentRecognizerOptions(
      hintedLanguages: ['iw', 'en'],
    );

    final recognizerWithOptions =
        FirebaseVision.instance.cloudDocumentTextRecognizer(options);

    final visionText = await recognizerWithOptions.processImage(visionImage);

    if (this.mounted) {
      setState(() {
        recognizedText = visionText.text;
      });
    }
    log(recognizedText);
    getDetails();
  }

  // //Regex getting string
  // strReg(String str) async {
  //   String newStr = str.replaceAll(RegExp('[a-zA-Z!-,:-@[-`{-~]'), '');
  //   log(newStr);
  //   //await SharedPrefs.setKey('filteredTxt', newStr);
  //   //getDetails();
  // }

  //Retrieving information according to the company required
  void getDetails() async {
    if (widget.companyName == 'חשמל') {
      OcrCompanies(
          companyName: widget.companyName,
          pickedImage: File(path),
          text: recognizedText,
          contextOcr: this.context,
          firstWordSum: 'לתשלום',
          lastWordSum: 'הודעות',
          firstWordBillNo: 'מקור ',
          lastWordBillNo: 'מספר',
      firstWordDate: 'מ-',
      lastWordDate: 'עד',
      firstWordExpDate: 'לשלם חשבון',
      lastWordExpDate: 'מבוצע');
    }
    if (widget.companyName == 'מים') {
      OcrCompanies(
          companyName: widget.companyName,
          pickedImage: File(path),
          text: recognizedText,
          contextOcr: this.context,
          firstWordSum: 'תאריך אחרון',
          lastWordSum: 'בתקופה זו',
          firstWordBillNo: 'מספר ספח',
          lastWordBillNo: 'מספר ימים',
          firstWordDate: 'כמה מים',
          lastWordDate: 'כמות צריכה',
          firstWordExpDate: 'אחרון לתשלום',
          lastWordExpDate: 'בתקופה זו');
    }
    if (widget.companyName == 'גז') {
      OcrCompanies(
          companyName: widget.companyName,
          pickedImage: File(path),
          text: recognizedText,
          contextOcr: this.context,
          firstWordSum: 'סה"כ לתשלום',
          lastWordSum: 'מחיר ממוצע משוקלל',
          firstWordBillNo: 'חשבונית מס קבלה',
          lastWordBillNo: 'שם הצרכן',
          firstWordDate: 'מיקוד',
          lastWordDate: 'מרכזיה',
          firstWordExpDate: 'טלפון חירום',
          lastWordExpDate: 'מועד אחרון');
    }

    if (widget.companyName == 'ארנונה') {
      OcrCompanies(
          companyName: widget.companyName,
          pickedImage: File(path),
          text: recognizedText,
          contextOcr: this.context,
          firstWordSum: 'מספר מסלקה',
          lastWordSum: 'הוראות החוק',
          firstWordBillNo: 'מספר מסלקה',
          lastWordBillNo: 'החוק',
          firstWordDate: 'ארנונה ואגרת שמירה',
          lastWordDate: 'חשבון מיסים',
          firstWordExpDate: 'לתשלום עד',
          lastWordExpDate: 'הוראות');
    }
  }

  @override
  void initState() {
    _initializeVision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
              color: kBackGroundColor,
              child: Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [SizedBox(width: 30, height: 30, child: CircularProgressIndicator()), kLoadingLogo]),
              ),
            ),
    );
  }
}
