import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('UserData')
                .doc("${auth.currentUser.uid}")
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Text("Loading");
              }
              var userDocument = snapshot.data;
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://mobilehd.blob.core.windows.net/main/2015/09/luxury-dark-house-lights-architecture.jpg"),
                        fit: BoxFit.cover,
                        alignment: Alignment.center)),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    Center(
                      child: Text(
                        'OCTUA VISION',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 45.0,
                            sigmaY: 45.0,
                          ),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20)),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width*0.8,
                              height: 80.0,
                              child: Row( 
                                children: [

                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              );
              //return Text(userDocument["pwd"]);
            })
        /*
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage("https://media.architecturaldigest.com/photos/5802ba6ecdff3c07101dee46/master/pass/Rafauli-Toronto-House-Tour_01.jpg"),fit: BoxFit.cover,alignment: Alignment.centerRight)
        ),
        child: Column(
          children: [
            Center()
          ],
        ),
      ),*/
        );
  }
}
