import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera_screen.dart';


List<CameraDescription> cameras = [];



class MainOcr extends StatefulWidget {
  final String companyName;
  MainOcr({this.companyName});

  @override
  _MainOcrState createState() => _MainOcrState();


}

class _MainOcrState extends State<MainOcr> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CameraScreen(title: widget.companyName),
    );
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    openCamera();
  }

  void openCamera() async{
    WidgetsFlutterBinding.ensureInitialized();
    try {
      if(cameras != null) {
        // Retrieve the device cameras
        cameras = await availableCameras();
      }
    } on CameraException catch (e) {
      print(e);
    }
    setState(() {

    });
  }



}







