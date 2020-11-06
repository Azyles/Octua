import 'dart:io';
import 'package:Octua/log.dart';
import 'package:Octua/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';

import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:intl/intl.dart';
import 'package:sensors/sensors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

FirebaseAuth auth = FirebaseAuth.instance;

enum TtsState { playing, stopped, paused, continued }

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference logs = FirebaseFirestore.instance
      .collection("UserData")
      .doc('${auth.currentUser.uid}')
      .collection("Log");

  Future<void> logdata(String log) {
    var uuid = Uuid();
    String uniqueid = uuid.v1().toString();
    // Call the user's CollectionReference to add a new user
    return logs
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
        .then((value) => print("Logged Found User"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  final _scanKey = GlobalKey<CameraMlVisionState>();

  CameraLensDirection cameraLensDirection = CameraLensDirection.front;
  FaceDetector detector =
      FirebaseVision.instance.faceDetector(FaceDetectorOptions(
    enableTracking: true,
    mode: FaceDetectorMode.accurate,
  ));

  static Future<String> getTime() async {
    String nowTime;
    nowTime = DateTime.now().toLocal().toString();
    return nowTime;
  }

  _saveTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nowTime = DateTime.now().toLocal().minute.toString();
    print("Set");
    await prefs.setString('Last_Logged', nowTime);
  }

  Future<bool> _viewTime() async {
    bool a = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('Last_Logged');

    String nowTime = DateTime.now().toLocal().minute.toString();

    if (stringValue == nowTime) {
      print("Did Not Log");
    } else {
      a = true;
      await _saveTime();
    }
    return a;
  }

  static Future<String> getDeviceDetails() async {
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    //if (!mounted) return;
    return identifier;
  }

  Future sleep2() {
    return new Future.delayed(const Duration(seconds: 2), () => "2");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        children: [
          FutureBuilder(
            future: getDeviceDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("UserData")
                      .doc('${auth.currentUser.uid}')
                      .collection("Accessory")
                      .doc(snapshot.data)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Loading");
                    }
                    var userDocument = snapshot.data;
                    if (userDocument["Alarm"]) {
                      return Stack(
                        children: [
                          Container(
                            height: 0.1,
                            width: 0.1,
                            child: CameraMlVision<List<Face>>(
                              key: _scanKey,
                              cameraLensDirection: cameraLensDirection,
                              detector: detector.processImage,
                              onResult: (faces) async {
                                if (faces == null ||
                                    faces.isEmpty ||
                                    !mounted) {
                                  return;
                                }
                                if (await _viewTime()) {
                                  await logdata("Face Detected");
                                } else {
                                  print("Ignored");
                                }
                                //setState(() {
                                //  detector.close();
                                //});
                              },
                              onDispose: () {
                                detector.close();
                              },
                            ),
                          ),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.red),
                              height: MediaQuery.of(context).size.width - 50,
                              width: MediaQuery.of(context).size.width - 50,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black),
                                  child: Center(
                                    child: Text("Octua",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 50,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green),
                          height: MediaQuery.of(context).size.width - 50,
                          width: MediaQuery.of(context).size.width - 50,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.black),
                              child: Center(
                                child: Text("Octua",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 50,
                                        fontWeight: FontWeight.w300)),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              } else if (snapshot.hasError) {
                throw snapshot.error;
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: Text(
                  "Octua",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.w300),
                )),
                SizedBox(
                  height: 1,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogView()),
                    );
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.pink[300], width: 12),
                          shape: BoxShape.circle,
                          color: Colors.pink[200]),
                      height: MediaQuery.of(context).size.width - 130,
                      width: MediaQuery.of(context).size.width - 130,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Text("Log",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    print("Signed Out");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => App()));
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blue[300], width: 12),
                          shape: BoxShape.circle,
                          color: Colors.blue[200]),
                      height: MediaQuery.of(context).size.width - 130,
                      width: MediaQuery.of(context).size.width - 130,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Text("Log Out",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/*
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
                    //do something
                  });
                },
                onDispose: () {
                  detector.close();
                },
              ),
            ),
*/
