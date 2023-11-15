import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:thakafah_reports/pages/main_page.dart';

import 'package:timezone/timezone.dart' as tz;
import 'dart:io' show Platform;
import '../main.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService notificationService =
      NotificationService._internal();


  factory NotificationService() {
    return notificationService;
  }


  NotificationService._internal();





   final AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    "123",
    "report",
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

   final DarwinNotificationDetails iOSNotificationDetails =
      DarwinNotificationDetails();

  // final NotificationDetails notificationDetails = NotificationDetails(
  //   android: androidNotificationDetails,
  //   iOS: iOSNotificationDetails,
  // );
 static  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  Future<void> init() async {

    final AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
      defaultPresentAlert: false,
      defaultPresentBadge: false,
      defaultPresentSound: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );


    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            onSelectNotification(notificationResponse);
            break;
          case NotificationResponseType.selectedNotificationAction:
            onSelectNotification(notificationResponse);
            break;
        }
      },
    );

    await flutterLocalNotificationsPlugin.pendingNotificationRequests().then((value) {
      if(value.isEmpty){
        NotificationService.notificationService.scheduleDailyTenAMNotification();
      }
    });
  }



  // @pragma('vm:entry-point')
  // void notificationTapBackground(NotificationResponse notificationResponse) {
  //   // ignore: avoid_print
  //   print('notification(${notificationResponse.id}) action tapped: '
  //       '${notificationResponse.actionId} with'
  //       ' payload: ${notificationResponse.payload}');
  //   if (notificationResponse.input?.isNotEmpty ?? false) {
  //     // ignore: avoid_print
  //     print(
  //         'notification action tapped with input: ${notificationResponse.input}');
  //   }
  // }

   Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();


          await androidImplementation?.requestNotificationsPermission();

    }
  }
  Future<void> scheduleFromNotification() async {
    await flutterLocalNotificationsPlugin.pendingNotificationRequests().then((value) {
      if(value.isEmpty){
        NotificationService.notificationService.scheduleDailyTenAMNotification();
      }
    });
}
  Future<void> scheduleDailyTenAMNotification() async {

    await flutterLocalNotificationsPlugin.zonedSchedule(
        123,
        'تذكير',
        'لا تنسى تعبئة تقرير العمل ... بارك الله بك',
       await _nextInstanceOfTenAM(),
         NotificationDetails(
          android: androidNotificationDetails,
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<tz.TZDateTime> _nextInstanceOfTenAM() async {


    final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
    final tz.TZDateTime now = tz.TZDateTime.now(tz.getLocation(timeZoneName!));
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 20);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }


  Future<void> cancelAllNotifications() async {

    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> onSelectNotification(NotificationResponse payload) async {
    await navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (_) => MainPage()));
  }

// @override
// void dispose() {
//   didReceiveLocalNotificationStream.close();
//   selectNotificationStream.close();
//   super.dispose();
// }
}
