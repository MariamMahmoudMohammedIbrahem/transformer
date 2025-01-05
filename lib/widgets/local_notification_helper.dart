import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> showOngoingNotification(
    FlutterLocalNotificationsPlugin notifications, {
      required int id,
      required String title,
      required String body,
      String? payload,
    }) async {
  try {
    await Future.delayed(const Duration(milliseconds: 200));

    final List<ActiveNotification> activeNotifications =
    await notifications.getActiveNotifications();
    // print('notifications: $activeNotifications');
    // Check if a notification with the same ID is already pending
    bool notificationExists =
    activeNotifications.any((notification) => notification.id == id);

    // Only show the notification if it doesn't exist
    if (!notificationExists) {
      await notifications.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            channelDescription: 'channel_description',
            importance: Importance.max,
            priority: Priority.high,
            ongoing: false,
            autoCancel: false,
          ),
        ),
        payload: payload,
      );
    }
  } catch (e) {
    // /print('Error showing notification: $e');
  }
}

