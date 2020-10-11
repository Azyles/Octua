import 'package:Octua/arm.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
      home: ArmView(),
    );
  }
}