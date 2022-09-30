import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notify/firebase_options.dart';
import 'package:notify/screens/home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

// Set up background message handler

Future<void> notificationHandler(RemoteMessage message) async {
  log('Message from firebase ${message.data}');
  log('\x1B[31m ${message.messageId}  ');
  log('\x1B[31m ${message.contentAvailable}  ');
  log('\x1B[31m ${message.notification}  ');
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "notifyproject",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelGroupKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
        ),
      ],
      debug: true);
  FirebaseMessaging.onBackgroundMessage(notificationHandler);

  // TODO: Request permission
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  // TODO: Register with FCM
  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token=$token');
  }

// used to pass messages from event handler to the UI
  final _messageStreamController = BehaviorSubject<RemoteMessage>();

  // TODO: Set up foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');

      log('\x1B[32mMessage notification: ${message.notification?.body}');
      log(' \x1B[36m----------->Message data  : ${message.data}');
      log('\x1B[32m ----------->Message data  content: ${message.data['content']}');
      log(' \x1B[36m----------->Message data  shedule: ${message.data['schedule']}');
      log('\x1B[32m----------->Message data  action buttons: ${message.data['actionButtons']}');
      AwesomeNotifications().createNotificationFromJsonData(message.data);
    }

    _messageStreamController.sink.add(message);
  });

// Definition the background message handler
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();

    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }
  }

  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
