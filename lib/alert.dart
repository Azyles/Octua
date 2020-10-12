import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'arm.dart';
import 'package:intl/intl.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class AlertView extends StatefulWidget {
  @override
  _AlertViewState createState() => _AlertViewState();
}

class _AlertViewState extends State<AlertView> {
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
        .then((value) => print("Logged failed Attempt"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  final TextEditingController _emailController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  bool cooldown = false;
  String error = "";
  int failed = 0;
  Timer _timer;
  int _start = 30;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            addUser("Failed to end alarm in time.");
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void initState() {
    startTimer();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 90,
                ),
                Center(
                  child: Text("Octua",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.w300)),
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Container(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Email'),
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
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          dismissAlert(context),
        ],
      ),
    );
  }

  Widget dismissAlert(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('UserData');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc('${auth.currentUser.uid}').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Center(
            child: Container(
              child: new Material(
                child: new InkWell(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      if (_emailController.text == data['pwd']) {
                        _timer.cancel();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ArmView()));
                      } else {
                        await addUser("Incorrect email entered");
                      }
                    }
                  },
                  child: new Container(
                    child: Center(
                      child: Text(
                        'Login',
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
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.transparent,
              ),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.deepOrange[200],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }

        return Center(
            child: Container(
              child: new Material(
                child: new InkWell(
                  onTap: () async {
                  },
                  child: new Container(
                    child: Center(
                      child: Text(
                        'Login',
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
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.transparent,
              ),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.deepOrange[200],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
      },
    );
  }
}
