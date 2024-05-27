import 'dart:developer';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> initNotification() async {
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    tz.initializeTimeZones();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('launch_background');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('reminder_notify', 'task_reminder',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

//-------------------------------------------------------------------delete notifications
  Future deleteNotification({required String id}) {
    return notificationsPlugin
        .cancel(int.parse(id))
        .onError((error, stackTrace) {
      log('notification not cancelled');
    });
  }

  Future updateNotification(
      {required String id, required DateTime datatime}) async {
    await notificationsPlugin
        .cancel(int.parse(id))
        .onError((error, stackTrace) {
      log('notification not cancelled');
    }).then((value) async {
      await scheduleNotification(
          scheduledNotificationDateTime: datatime, id: int.parse(id));
    });
  }

  Future scheduleNotification(
      {required int id,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    DateTime notificationTime =
        scheduledNotificationDateTime.subtract(const Duration(minutes: 5));

    return notificationsPlugin
        .zonedSchedule(
            id,
            'task reminder',
            body,
            tz.TZDateTime.from(
              notificationTime,
              tz.getLocation('Asia/Kolkata'),
            ),
            await notificationDetails(),
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime)
        .onError((error, stackTrace) {
      log('Notifications wont happend');
    });
  }
}
