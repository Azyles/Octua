import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class LogView extends StatefulWidget {
  @override
  _LogViewState createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  CollectionReference users =
      FirebaseFirestore.instance.collection("UserData").doc('${auth.currentUser.uid}').collection("Log");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Octua Log"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.orderBy('timestamp',descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              'Something went wrong',
              style: TextStyle(color: Colors.white),
            ));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            // ignore: deprecated_member_use
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              if (document.data() == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
               
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: ListTile(
                    title: new Text(document.data()['time'],style: TextStyle(color: Colors.blue[100],fontWeight: FontWeight.w400),),
                    subtitle: new Text(document.data()['log'],style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w700)),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete_forever_outlined,
                      onTap: () {
                        users
                            .doc(document.data()['id'])
                            .delete()
                            .then((value) => print("User Deleted"))
                            .catchError((error) =>
                                print("Failed to delete user: $error"));
                      },
                    ),
                  ],
                );
                
              }
            }).toList(),
          );
        },
      ),
    );
  }
}
