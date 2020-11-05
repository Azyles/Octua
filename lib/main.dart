import 'dart:io';

import 'package:Octua/Camera/Camera.dart';
import 'package:Octua/Controller/Home.dart';
import 'package:Octua/arm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/registerview.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

Future<void> main() async {
  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Octua',
      theme: ThemeData(
        splashColor: Colors.deepOrangeAccent[100],
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: App(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          FirebaseAuth auth = FirebaseAuth.instance;

          if (auth.currentUser != null) {
            print("Logged In");
            return RouteView();
          } else {
            print("Logged Out");
            return SignUpView();
          }
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

class RouteView extends StatefulWidget {
  @override
  _RouteViewState createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateStatus(String acctype) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('UserData');
    // Call the user's CollectionReference to add a new user
    return users
        .doc("${auth.currentUser.uid}")
        .update({'Type': "$acctype"})
        .then((value) => print("Logged failed Attempt"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  CollectionReference users =
      FirebaseFirestore.instance.collection('DeviceData');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getDeviceDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder<DocumentSnapshot>(
              future: users.doc(snapshot.data).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container(color: Colors.black,child: Center(child: Text("Error",style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.w300),)));
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data = snapshot.data.data();
                  if (data["Type"] == "Accessory") {
                    return CameraView();
                  } else if (data["Type"] == "App") {
                    return HomeView();
                  }
                }
                return Container(color: Colors.black,child: Center(child: Text("Octua",style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.w300),)));
              },
            );
          } else if (snapshot.hasError) {
            throw snapshot.error;
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
