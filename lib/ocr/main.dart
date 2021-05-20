import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera_screen.dart';


List<CameraDescription> cameras = [];

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Retrieve the device cameras
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CameraScreen(),
    );
  }
}