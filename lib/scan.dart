import 'dart:ui';

import 'package:Octua/arm.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';

class ScanView extends StatefulWidget {
  @override
  _ScanViewState createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  List<Face> _faces = [];
  final _scanKey = GlobalKey<CameraMlVisionState>();
  CameraLensDirection cameraLensDirection = CameraLensDirection.front;
  FaceDetector detector =
      FirebaseVision.instance.faceDetector(FaceDetectorOptions(
    enableTracking: true,
    mode: FaceDetectorMode.accurate,
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: CameraMlVision<List<Face>>(
          key: _scanKey,
          cameraLensDirection: cameraLensDirection,
          detector: detector.processImage,
          onResult: (faces) {
            if (faces == null || faces.isEmpty || !mounted) {
              return;
            }
            setState(() {
              detector.close();
              //Navigator.push(
              //    context, MaterialPageRoute(builder: (context) => ArmView()));
            });
          },
          onDispose: () {
            detector.close();
          },
        ),
      ),
    );
  }
}
