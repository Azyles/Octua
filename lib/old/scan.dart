import 'dart:async';
import 'dart:ui';

import 'package:Octua/old/alert.dart';
import 'package:Octua/old/arm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';

import 'package:intl/intl.dart';
import 'package:sensors/sensors.dart';
import 'package:uuid/uuid.dart';
import 'log.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class ScanView extends StatefulWidget {
  @override
  _ScanViewState createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  Timer _timer;
  int _start = 30;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users =
      FirebaseFirestore.instance.collection('${auth.currentUser.uid}');
  Future<void> addUser(String log) {
    var uuid = Uuid();
    String uniqueid = uuid.v1().toString();
    // Call the user's CollectionReference to add a new user
    return users
        .doc(uniqueid)
        .set({
          'timestamp': DateTime.now().toLocal().millisecondsSinceEpoch,
          'time': DateFormat.yMMMd('en_US')
              .add_jm()
              .format(new DateTime.now())
              .toString(),
          'log': log,
          'id': uniqueid
        })
        .then((value) => print("Logged failed Attempt"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            //addUser("No issues detected!");
            _start = 30;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  final _scanKey = GlobalKey<CameraMlVisionState>();
  CameraLensDirection cameraLensDirection = CameraLensDirection.front;
  FaceDetector detector =
      FirebaseVision.instance.faceDetector(FaceDetectorOptions(
    enableTracking: true,
    mode: FaceDetectorMode.accurate,
  ));
  bool dark = true;
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void initState() {
    startTimer();
    
    super.initState();
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text("Octua",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w200)),
            ),
            Container(
              height: 0.1,
              width: 0.1,
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
                    _timer.cancel();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AlertView()));
                  });
                },
                onDispose: () {
                  detector.close();
                },
              ),
            ),
          ],
        ));
  }
}
