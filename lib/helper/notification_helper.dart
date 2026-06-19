import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_delivery_app/controllers/auth_controller.dart';
import 'package:get/get.dart';

class NotificationHelper {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {

    var androidInitialize =
        const AndroidInitializationSettings('notification_icon');

    // DarwinInitializationSettings replaces IOSInitializationSettings
    var iOSInitialize = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );

    // onDidReceiveNotificationResponse replaces onSelectNotification
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        try {
          final payload = response.payload;
          if (payload != null && payload.isNotEmpty) {
            // handle payload
          } else {
            // Get.toNamed(RouteHelper.getNotificationRoute());
          }
        } catch (e) {
          if (kDebugMode) print(e.toString());
        }
      },
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("....................onMessage..........");
      print("onMessage: ${message.notification?.title}"
          "/${message.notification?.body}");

      NotificationHelper.showNotification(
          message, flutterLocalNotificationsPlugin);

      if (Get.find<AuthController>().userLoggerIn()) {
        // Get.find<OrderController>().getRunningOrders(1);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onOpenApp: ${message.notification?.title}"
          "/${message.notification?.body}");
      try {
        if (message.notification?.titleLocKey != null) {
          // handle navigation
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  static Future<void> showNotification(
      RemoteMessage msg, FlutterLocalNotificationsPlugin fln) async {

    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      msg.notification!.body!,
      htmlFormatBigText: true,
      contentTitle: msg.notification!.title!,
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id_1',
      'dbfood',
      importance: Importance.high,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      playSound: true,
    );

    // DarwinNotificationDetails replaces IOSNotificationDetails
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    await fln.show(
      0,
      msg.notification!.title,
      msg.notification!.body,
      platformChannelSpecifics,
    );
  }
}