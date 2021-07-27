import 'dart:async';
import 'dart:developer';
import 'dart:io';
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
    if (widget.companyName == 'חברת חשמל') {
      OcrCompanies(
          companyName: widget.companyName,
          text: recognizedText,
          firstWordSum: 'לתשלום',
          lastWordSum: 'הודעות',
          firstWordBillNo: 'מקור ',
          lastWordBillNo: 'מספר',
      firstWordDate: 'מ-',
      lastWordDate: 'עד',
      firstWordExpDate: 'לשלם חשבון',
      lastWordExpDate: 'מבוצע');
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
      body: _imageSize != null
          ? Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    width: double.maxFinite,
                    color: Colors.black,
                    child: AspectRatio(
                      aspectRatio: _imageSize.aspectRatio,
                      child: Image.file(
                        File(path),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    elevation: 8,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Identified text",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            child: SingleChildScrollView(
                              child: Text(
                                recognizedText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
