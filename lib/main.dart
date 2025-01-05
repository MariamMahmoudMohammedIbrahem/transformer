import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:transformer/screens/dashboard.dart';

import 'constants/constants.dart';
import 'mqtt/MQTTAppState.dart';

// import 'mqtt/view_mqtt.dart';
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

final notifications = FlutterLocalNotificationsPlugin();
void main() async {
  final mqttAppState = MQTTAppState.instance;
  currentAppState = MQTTAppState.instance;
  WidgetsFlutterBinding.ensureInitialized();
  configureAndConnect();
  initializeNotifications();
  await initializeService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => mqttAppState,
        ),
      ],
      child: const MyApp(),
    ),
  );
}
void backgroundHandler(NotificationResponse response) async {
  if (response.payload != null) {
    // print("Notification tapped with payload: ${response.payload}");

    // Cancel the notification when tapped/swiped
    await notifications.cancel(response.id!);
  }
}

void initializeNotifications() {
  notifications.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    onDidReceiveBackgroundNotificationResponse: backgroundHandler,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        // print("Notification tapped with payload: ${response.payload}");

        await notifications.cancel(response.id!);
      }
    },
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration:
    AndroidConfiguration(onStart: onStart, isForegroundMode: true),
  );
  await service.startService();
}
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }
  // Start the data update and notification loop
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        // showOngoingNotification(notifications, id: 1, title: 'testing notification within timer1', body: 'ongoing false and auto cancel false');
        // showOngoingNotification(notifications, id: 2, title: 'testing notification within timer2', body: 'ongoing false and auto cancel false');
        // showOngoingNotification(notifications, id: 3, title: 'testing notification within timer3', body: 'ongoing false and auto cancel false');
        // showOngoingNotification(notifications, id: 4, title: 'testing notification within timer4', body: 'ongoing false and auto cancel false');
        // final List<ActiveNotification> pendingNotifications =
        // await notifications.getActiveNotifications();
        // print('notifications inside on start function: $pendingNotifications');
          configureAndConnect();
      }
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    currentAppState = Provider.of<MQTTAppState>(context);
    // state = currentAppState.getAppConnectionState;
    return MaterialApp(
      title: 'Transformer',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.yellow,
        colorScheme: const ColorScheme.dark(
          primary: Colors.yellow,
          onPrimary: Colors.black,
          secondary: Colors.yellow,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        textTheme: TextTheme(
          bodyMedium: const TextStyle(color: Colors.white, fontSize: 16),
          bodySmall: TextStyle(color: Colors.grey[300]),
        ),
        switchTheme: SwitchThemeData(
          splashRadius: 50.0,
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.yellow;
            }
            return Colors.grey.shade300;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.yellow.shade300;
            }
            return Colors.grey.shade800;
          }),
        ),
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const Dashboard(),
    );
  }
}
