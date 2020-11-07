import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class FCM {

  void fcmSubscribe(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
  }

  void fcmUnSubscribe(String topic) {
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }

}
