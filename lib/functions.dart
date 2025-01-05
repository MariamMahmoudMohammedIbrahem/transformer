
import'package:transformer/commons.dart';

late MQTTAppState currentAppState;
late MqttManager manager;
void configureAndConnect() {
  manager = MqttManager(
    host: 'broker.emqx.io',
    topics: ['EOIP/+/data/#','EOIP/+/alarm/#'],
    identifier: 'message',
    state: MQTTAppState.instance,
  );
  manager.initializeMQTTClient();
  manager.connect();
}

void disconnect() {
  manager.disconnect();
}

void checkAndNotify(
    String topic, String key, double threshold, String title, String body, int id) {
  final topicData = MQTTAppState.instance.getDataForTopic(topic);

  if (topicData.isNotEmpty && topicData.containsKey(key)) {
    try {
      final value = double.parse(topicData[key].toString());
      if (value > threshold) {
        showOngoingNotification(
          notifications,
          title: '$title$id',
          body: body,
          id: id,
        );
      }
    } catch (e) {
    }
  }
}

void backgroundHandler(NotificationResponse response) async {
  if (response.payload != null) {
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
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        configureAndConnect();
      }
    }
  });
}

Future<void> initialization() async {
  currentAppState = MQTTAppState.instance;
  WidgetsFlutterBinding.ensureInitialized();
  configureAndConnect();
  initializeNotifications();
  await initializeService();
}