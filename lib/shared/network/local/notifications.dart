import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationsView {
  static FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static initState() async {
    initializeSetting();
    tz.initializeTimeZones();
  }

  static Future<void> displayNotification(
      {required String task, required DateTime dateTime}) async {
    notificationsPlugin
        .zonedSchedule(
            0,
            task,
            'Task deadline',
            tz.TZDateTime.from(dateTime, tz.local),
            NotificationDetails(
              android: AndroidNotificationDetails(
                  'channel id', 'channel name', 'channel description'),
            ),
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true)
        .then((value) {})
        .catchError((error) {});
  }

  static void initializeSetting() async {
    var initializeAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializeSetting = InitializationSettings(android: initializeAndroid);
    await notificationsPlugin.initialize(initializeSetting);
  }
}
