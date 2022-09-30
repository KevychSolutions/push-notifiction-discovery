import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void notify() async {
  String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  NotificationContent cont = NotificationContent(
    id: 1,
    backgroundColor: Colors.pink,
    channelKey: 'basic_channel',
    title: "Test notify",
    body:
        'This notification was created to test an opportunity to get awesome notifications',
    notificationLayout: NotificationLayout.BigPicture,
    bigPicture:
        'https://images.freeimages.com/images/previews/b0e/reggie-side-profile-1547758.jpg',
  );

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 1,
    backgroundColor: Colors.pink,
    channelKey: 'key1',
    title: "Test notify",
    body:
        'This notification was created to test an opportunity to get awesome notifications',
    notificationLayout: NotificationLayout.BigPicture,
    bigPicture:
        'https://images.freeimages.com/images/previews/b0e/reggie-side-profile-1547758.jpg',
  ));
}

Future<void> cancel() async {
  await AwesomeNotifications().cancelAllSchedules();
}
