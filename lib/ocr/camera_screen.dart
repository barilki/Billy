import 'package:billy/companies/main_companies.dart';
import 'package:billy/constants/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
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
    _controller.setFocusMode(FocusMode.auto);
    _controller.setExposureMode(ExposureMode.auto);
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
      // await Future.delayed(Duration(milliseconds: 200));
      // Captures the image and saves it to the
      // provided path
      final XFile picture = await _controller.takePicture();
      imagePath = picture.path;
      // picture.saveTo(imagePath);
    } on CameraException catch (e) {
      print("Camera Exception: $e");
    }
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    var camera = _controller.value;
    print("CAMERA: "+ camera.toString());
    // fetch screen size
    final size = MediaQuery.of(context).size;
    print("SIZE" + size.toString());
    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;
    print("SCALE: " + scale.toString());
    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      backgroundColor: kBackGroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      MainCompanies(companyName: widget.title)));
            }),
      ),
      body: _controller.value.isInitialized
          ? Stack(
              children: <Widget>[
                Transform.scale(
                  scale: scale,
                  child: Center(
                    child: CameraPreview(_controller),
                  ),
                ),
                Center(
                    child: Container(
                  height: 630,
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0)),
                )),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 95,
                      height: 60,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.camera),
                        label: Text("צלם", style: TextStyle(fontSize: 20)),
                        onPressed: () async {
                          await _takePicture().then((String path) {
                            if (path != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                        imagePath: path,
                                        companyName: widget.title)),
                              );
                            }
                          });
                        },
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
