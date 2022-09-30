import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/notify.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: Text('allow notification'),
                content: Text('we want to send you some notifications'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('no')),
                  TextButton(
                      onPressed: () {
                        AwesomeNotifications()
                            .requestPermissionToSendNotifications()
                            .then((value) => Navigator.pop(context));
                      },
                      child: Text('yes'))
                ],
              )),
        );
      }
    });

    AwesomeNotifications().createdStream.listen((notification) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'notification created ${notification.channelKey}',
        ),
      ));
    });

// // for counter
    AwesomeNotifications().actionStream.listen((action) {
      if (action.channelKey == 'key1' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
            (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1));
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MyWidget()),
          (route) => route.isFirst);
    });
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: Image.network(
                    'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      notify();
                      print('_________________________>');
                    },
                    child: const Text('basic'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // cancel();
                    },
                    child: const Text('cancel shedule'),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back_outlined),
        onPressed: () {
          Navigator.pop(context);
        },
      )),
      body: Center(
        child: Container(
          width: 200,
          color: Colors.pink,
          child: Image.network(
              'https://cdn.shopify.com/s/files/1/0231/9450/1197/files/Morning-Bird-Animated-Bird-4.15.20-White.gif?v=1586988077'),
        ),
      ),
    );
  }
}
