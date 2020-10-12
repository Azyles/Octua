import 'dart:async';

import 'package:Octua/arm.dart';
import 'package:Octua/scan.dart';
import 'package:flutter/material.dart';

class TimerDelay extends StatefulWidget {
  @override
  TimerDelayState createState() => TimerDelayState();
}

class TimerDelayState extends State<TimerDelay> {
  Timer _timer;
  int _start = 5;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ScanView()));
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
              child: Text(
            "$_start",
            style: TextStyle(
                color: Colors.white, fontSize: 50, fontWeight: FontWeight.w300),
          )),
          Padding(
            padding: const EdgeInsets.only(top: 500),
            child: Center(
                child: FlatButton(
                  onPressed: (){
                    _timer.cancel();
                    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ArmView()));
                  },
                  color: Colors.deepOrangeAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
            "Cancel",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
          ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
