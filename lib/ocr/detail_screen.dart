import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:billy/constants/constants.dart';
import 'package:flutter/scheduler.dart';
import 'package:image/image.dart' as img;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'ocr_companies.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;
  final String companyName;

  DetailScreen({this.imagePath, this.companyName});

  @override
  _DetailScreenState createState() => _DetailScreenState(imagePath);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(this.pathBefore);

  final String pathBefore;

  Size _imageSize;
  String recognizedText = "loading..";
  String pathAfter;
  String pathImageWithColors = '/data/user/0/com.example.billy/cache/color.jpg';

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

  //Convert image to Grayscale
  void grayScaleImage(){
    //Get original image with color and copy to another path
    File(pathBefore).copy('/data/user/0/com.example.billy/cache/color.jpg');
    print("PATH:" + pathBefore);
    img.Image image = img.decodeJpg(File(pathBefore).readAsBytesSync());
    print("Read image from file and made a img.Image object");
    print(image.getBytes());
    var grayScale = img.grayscale(image);
    var gaussianBlur = img.gaussianBlur(grayScale, 2);
    var imageCrop = img.copyCrop(gaussianBlur,780, 150, 1776, 1826);
    var contrast = img.contrast(imageCrop, 160);
    print("Grayscaled");
    final toBeSavedImage = img.encodePng(contrast);
    print("Converted image to bytes");
    File(pathBefore).writeAsBytesSync(toBeSavedImage);
    pathAfter = pathBefore;

  }

  void _initializeVision() async {
    final File imageFile = File(pathAfter);

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

  //Retrieving information according to the company required
  void getDetails() async {
    if (widget.companyName == 'חשמל') {
      OcrCompanies(
          companyName: widget.companyName,
          pickedImage: File(pathImageWithColors),
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
          pickedImage: File(pathImageWithColors),
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
          pickedImage: File(pathImageWithColors),
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
          pickedImage: File(pathImageWithColors),
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

  void imageWithColor() async{
    Directory directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    await File(path).copy('/data/user/0/com.example.billy/cache/color.jpg');
  }

  @override
  void initState() {
    super.initState();
      grayScaleImage();
      _initializeVision();

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
