// enum MQTTAppConnectionState {connected , disconnected, connecting }

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import '../mqtt/MQTTAppState.dart';
import '../mqtt/MQTTManager.dart';
import '../widgets/local_notification_helper.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

var tbClient = ThingsboardClient('https://demo.thingsboard.io');
Future<void> authenticate () async {
  try {
    // var tbClient = ThingsboardClient('https://demo.thingsboard.io');
    await tbClient.login(LoginRequest('tenant@thingsboard.org', 'tenant'));

    // print('isAuthenticated=${tbClient.isAuthenticated()}');

    // print('authUser: ${tbClient.getAuthUser()}');

    var currentUserDetails = await tbClient.getUserService().getUser();
    // print('currentUserDetails: $currentUserDetails');

    await tbClient.logout();

  } catch (e, s) {
    // print('Error: $e');
    // print('Stack: $s');
  }
}

/*final TextEditingController messageTextController = TextEditingController();
late MQTTAppState currentAppState;
late MQTTManager manager;
late MQTTAppConnectionState state;*/
const settingsAndroid = AndroidInitializationSettings('ic_launcher');
/*List<String> devices = [];
String selectedDevice = '';*/

late MQTTAppState currentAppState;
late MQTTManager manager;
void configureAndConnect() {
  manager = MQTTManager(
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

  // Check if topic data exists and contains the key
  if (topicData.isNotEmpty && topicData.containsKey(key)) {
    try {
      final value = double.parse(topicData[key].toString()); // Parse the value as a double
      if (value > threshold) {
        showOngoingNotification(
          notifications,
          title: '$title$id',
          body: body,
          id: id,
        );
      }
    } catch (e) {
      // print('Error parsing data for $topic: $e');
    }
  }
}

