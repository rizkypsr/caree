import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessageHandler extends StatefulWidget {
  const FirebaseMessageHandler({Key? key}) : super(key: key);

  @override
  _FirebaseMessageHandlerState createState() => _FirebaseMessageHandlerState();
}

class _FirebaseMessageHandlerState extends State<FirebaseMessageHandler> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });

    FirebaseMessaging.onMessage.listen((event) {
      print("message received");
      print(event.notification!.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('Message Cllicked!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
