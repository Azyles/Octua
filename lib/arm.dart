import 'dart:ui';

import 'package:Octua/scan.dart';
import 'package:Octua/scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';

class ArmView extends StatefulWidget {
  @override
  _ArmViewState createState() => _ArmViewState();
}

class _ArmViewState extends State<ArmView> {
  List<String> data = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              await Future.delayed(const Duration(seconds: 1), () {});
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ScanView()));
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
            onTap: () {},
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
            onTap: () {},
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
