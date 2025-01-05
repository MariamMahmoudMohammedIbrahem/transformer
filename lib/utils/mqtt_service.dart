/*
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;
  Function(String)? onMessageReceived;

  MqttService(String broker, String clientId) {
    client = MqttServerClient(broker, clientId);
    client.port = 1883;
    client.keepAlivePeriod = 60;
    client.logging(on: true);
    client.onDisconnected = onDisconnected;
  }

  Future<MqttClient> connect() async {
    MqttServerClient client = MqttServerClient.withPort('broker.emqx.io', 'flutter_client', 1883);
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .authenticateAs("username", "password")
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;
    try {
      print('Connecting');
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }
    print("connected");

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMessage = c![0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

      print('Received message:$payload from topic: ${c[0].topic}');
    });

    return client;
  }


  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }
// Connected callback
  void onConnected() {
    print('Connected');
  }
  void onDisconnected() {
    print('Disconnected');
  }

  void disconnect() {
    client.disconnect();
  }

  // Subscribed callback
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

// Subscribed failed callback
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// Unsubscribed callback
  void onUnsubscribed(String? topic) {
    print('Unsubscribed topic: $topic');
  }

  // Ping callback
  void pong() {
    print('Ping response client callback invoked');
  }
}

class MQTTAppState with ChangeNotifier{
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;
  String _receivedText = "";
  String _historyText = "";

  void setReceivedText(String text) {
    _receivedText = text;
    _historyText = _historyText + '\n' + _receivedText;
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
}

*/
