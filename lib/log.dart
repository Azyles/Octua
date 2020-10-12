import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class LogView extends StatefulWidget {
  @override
  _LogViewState createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  Query collectionReference  =
      FirebaseFirestore.instance.collection('${auth.currentUser.uid}').orderBy("timestamp");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Octua Log"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionReference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading..."));
          }

          return new ListView(
            // ignore: deprecated_member_use
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return  ListTile(
                title: new Text(document.data()['time']),
                subtitle: new Text(document.data()['log']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
