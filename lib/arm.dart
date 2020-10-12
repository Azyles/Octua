import 'dart:ui';

import 'package:Octua/log.dart';
import 'package:Octua/scan.dart';
import 'package:Octua/scan.dart';
import 'package:Octua/timerview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:uuid/uuid.dart';

import 'package:intl/intl.dart';

class ArmView extends StatefulWidget {
  @override
  _ArmViewState createState() => _ArmViewState();
}

class _ArmViewState extends State<ArmView> {
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
        .then((value) => print("Logged button Press"))
        .catchError((error) => print("Failed to add user: $error"));
  } 
  bool soundplaying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text("Octua",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.w300)),
          ),
          GestureDetector(
            onTap: () async {
              /*
              showDialog(
                barrierColor: Colors.transparent,
                context: context,
                builder: (_) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRect(
                              child: new BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 40.0, sigmaY: 40.0),
                                  child: new Container(
                                    height: 160.0,
                                    decoration: new BoxDecoration(
                                        color:
                                            Colors.grey[900].withOpacity(0.7),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Starting in 10 seconds",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Colors.deepOrange[200]),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "This window will close automatically in 10 seconds and the app will be armed.",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
              */
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TimerDelay()));
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue[100]),
              child: Center(
                child: Text("Arm",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w300)),
              ),
              height: MediaQuery.of(context).size.width * 0.45,
              width: MediaQuery.of(context).size.width * 0.45,
            ),
          ),
          GestureDetector(
            onTap: () async {
              addUser("Pressed Alert Button");
              print("Button Pressed");
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.deepOrangeAccent[100]),
              child: Center(
                child: Text("Alert",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w300)),
              ),
              height: MediaQuery.of(context).size.width * 0.45,
              width: MediaQuery.of(context).size.width * 0.45,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LogView()));
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.pink[100]),
              child: Center(
                child: Text("Log",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w300)),
              ),
              height: MediaQuery.of(context).size.width * 0.45,
              width: MediaQuery.of(context).size.width * 0.45,
            ),
          )
        ],
      ),
    );
  }
}
