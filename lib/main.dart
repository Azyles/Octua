import 'package:Octua/Camera/Camera.dart';
import 'package:Octua/Controller/Home.dart';
import 'package:Octua/arm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/registerview.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  CollectionReference users = FirebaseFirestore.instance.collection('UserData');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc("${auth.currentUser.uid}").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            if (data["Type"] == "Camera") {
              return CameraView();
            } else if (data["Type"] == "App") {
              return HomeView();
            }
          }
          return Text("loading");
        },
      ),
    );
  }
}
