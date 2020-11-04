import 'dart:ui';

import 'package:Octua/arm.dart';
import 'package:Octua/auth/loginview.dart';
import 'package:Octua/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info/device_info.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = new GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool controlPanel = true;

  signInEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // ignore: unnecessary_statements
      userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> setPwd(String pwd, String typee, String name) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('UserData');
    // Call the user's CollectionReference to add a new user
    return users
        .doc("${auth.currentUser.uid}")
        .set({
          'pwd': pwd,
          'pwdLock': false,
          'Type': typee,
          'Name': name,
          'Alarm': false
        })
        .then((value) => print("Logged failed Attempt"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addCamera(String name) async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    CollectionReference users = FirebaseFirestore.instance
        .collection('UserData')
        .doc("${auth.currentUser.uid}")
        .collection('Cameras');
    // Call the user's CollectionReference to add a new user
    return users
        .doc("${androidInfo.id}")
        .set({'Name': name, 'Alarm': false})
        .then((value) => print("Logged failed Attempt"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  String _feedback = '';
  bool checkValue = false;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  signUpEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // ignore: unnecessary_statements
      userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Center(
            child: Text(
              'Register',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 46,
                  fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Container(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              hintText: 'UserName'),
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Email cannot be blank';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.85,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Center(
                  child: Container(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              hintText: 'Email'),
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Email cannot be blank';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.85,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Center(
                  child: Container(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                              hintText: 'Password'),
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Password cannot be blank';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.85,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Center(
            child: Container(
              child: new Material(
                child: new InkWell(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.transparent,
                              content: Container(
                                height: 300,
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 45.0,
                                        sigmaY: 45.0,
                                      ),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.05),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          alignment: Alignment.center,
                                          width: 300.0,
                                          height: 150.0,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Container(
                                                  child: new Material(
                                                    child: new InkWell(
                                                      onTap: () async {
                                                        await signUpEmail(
                                                          _emailController.text,
                                                          _passwordController.text,
                                                        );
                                                        await setPwd(
                                                            _passwordController
                                                                .text,
                                                            "App",
                                                            _nameController
                                                                .text);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        App()));
                                                      },
                                                      child: new Container(
                                                        child: Center(
                                                          child: Text(
                                                            'Continue',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.03,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.06,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    color: Colors.transparent,
                                                  ),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[400],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Container(
                                                  child: new Material(
                                                    child: new InkWell(
                                                      onTap: () async {
                                                        await signInEmail(
                            _emailController.text, _passwordController.text);
                                                        await addCamera(_nameController
                                                                .text);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        App()));
                                                      },
                                                      child: new Container(
                                                        child: Center(
                                                          child: Text(
                                                            'Accessory',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.03,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.06,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.85,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    color: Colors.transparent,
                                                  ),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.85,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.deepOrange[400],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  },
                  child: new Container(
                    child: Center(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height * 0.03,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                color: Colors.transparent,
              ),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                _feedback,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.redAccent[400], fontSize: 15.5),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignInView()));
        },
        backgroundColor: Colors.blue[400],
        child: Icon(Icons.swap_calls),
      ),
    );
  }
}
