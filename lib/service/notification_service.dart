import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:path/path.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:todo_list_app/model/custom_notification.dart';
import 'package:todo_list_app/pages/tarefas/ver_tarefas.dart';
import 'package:todo_list_app/routes.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundNotification(NotificationResponse response) async {
  var payload = response.payload;
  if (payload != null && payload.isNotEmpty) {
    Navigator.of(Routes.navigatorKey.currentContext!).pushReplacementNamed(payload);
  }
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidNotificationDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _setupTimezone();
    await _createNotificationChannel();
    await _initializeNotifications();
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: handleBackgroundNotification,
    );
  }

  _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'lembretes_notifications', // ID do canal
      'Lembretes', // Nome do canal
      description: 'Este canal é para lembretes.', // Descrição
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> showNotification(CustomNotification notification) async {
    androidNotificationDetails = const AndroidNotificationDetails(
      'lembretes_notifications',
      'Lembretes',
      channelDescription: 'Este canal é para lembretes.',
      icon: '@mipmap/ic_launcher',
      importance: Importance.max,
      priority: Priority.max,
    );

    await localNotificationsPlugin.periodicallyShow(
      notification.id,
      notification.title,
      notification.body,
      RepeatInterval.everyMinute,
      NotificationDetails(android: androidNotificationDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: notification.payload,
    );
  }

  checkForNotifications() async {
    final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      handleBackgroundNotification(details.notificationResponse!);
    }
  }
}
