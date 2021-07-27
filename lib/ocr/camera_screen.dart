import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'detail_screen.dart';
import 'main.dart';
import 'package:image/image.dart' as img;


class CameraScreen extends StatefulWidget {
  final String title;
  CameraScreen({this.title});
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  String _imagePath;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    _controller.initialize().then((_) {
      //_controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _takePicture() async {
    String imagePath;

    // Checking whether the controller is initialized
    if (!_controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    // Checking whether the picture is being taken
    // to prevent execution of the function again
    // if previous execution has not ended
    if (_controller.value.isTakingPicture) {
      print("Processing is in progress...");
      return null;
    }


    try {
      // Captures the image and saves it to the
      // provided path
      final XFile picture = await _controller.takePicture();
      imagePath = picture.path;
      picture.saveTo(imagePath);
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? Stack(
        children: <Widget>[
          CameraPreview(_controller),
          Center(child: Container(
            margin: EdgeInsets.all(25.0),
            height: 500,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15.0)),
          )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                icon: Icon(Icons.camera),
                label: Text("Click"),
                onPressed: () async {
                  await _takePicture().then((String path) {
                    if (path != null) {
                      img.Image image = img.decodeJpg(File(path).readAsBytesSync());
                      print("Read image from file and made a img.Image object");
                      print(image.getBytes());
                      image = img.grayscale(image);
                      image = img.gaussianBlur(image, 2);
                      image = img.copyResize(image, height:3508 , width: 2480);
                      image = img.contrast(image, 140);
                      image = img.brightness(image, 41);
                      print("Grayscaled");
                      final toBeSavedImage = img.encodePng(image);
                      print("Converted image to bytes");
                      File(path).writeAsBytesSync(toBeSavedImage);
                      _imagePath = path;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(imagePath: _imagePath, companyName: widget.title)
                        ),
                      );
                    }
                  });
                },
              ),
            ),
          )
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
