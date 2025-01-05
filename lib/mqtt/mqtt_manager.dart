
import 'package:transformer/commons.dart';

class MqttManager {
  final MQTTAppState _currentState;
  MqttServerClient? _client;
  final String _identifier;
  final String _host;
  final List<String> _topics;

  MqttManager({
    required String host,
    required List<String> topics,
    required String identifier,
    required MQTTAppState state,
  })  : _identifier = identifier,
        _host = host,
        _topics = topics,
        _currentState = state;

  void initializeMQTTClient() {
    _client = MqttServerClient(_host, _identifier);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 2;
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    _client!.logging(on: true);

    _client!.onConnected = onConnected;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    _client!.connectionMessage = connMess;
  }

  void connect() async {
    assert(_client != null);
    try {
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client!.connect();
    } on Exception {
      disconnect();
    }
    _client?.updates!.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
      final String topic = c![0].topic;

      final parts = topic.split('/');
      if (parts.length > 1) {
        final deviceId = parts[1];
        MQTTAppState.instance.checkData();
        if (!MQTTAppState.instance.devices.contains(deviceId) && deviceId.startsWith('device')) {
          MQTTAppState.instance.addDevice(deviceId);
          MQTTAppState.instance.setSelectedDevice(MQTTAppState.instance.devices[0]);
        }
      }
    });
  }

  void disconnect() {
    _client!.disconnect();
  }

  void publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void onDisconnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    for (var topic in _topics) {
      _client!.subscribe(topic, MqttQos.exactlyOnce);
    }
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
      final recMess = messages![0].payload as MqttPublishMessage;
      final topic = messages[0].topic;
      final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      _currentState.setReceivedText(topic, payload);
    });
  }
}

