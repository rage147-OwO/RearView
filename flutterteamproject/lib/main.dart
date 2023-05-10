import 'package:flutter/material.dart';
import './CameraView.dart';

void main() {
  //runApp(ChooseDemo());
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Detection App',
      home: CameraView(),
    );
  }
}