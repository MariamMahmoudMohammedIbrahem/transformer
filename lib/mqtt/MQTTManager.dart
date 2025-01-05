import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../constants/constants.dart';
import 'MQTTAppState.dart';

class MQTTManager {
  // Private instance of client
  final MQTTAppState _currentState;
  MqttServerClient? _client;
  final String _identifier;
  final String _host;
  final List<String> _topics; // Changed from single topic to list of topics

  // Constructor
  MQTTManager({
    required String host,
    required List<String> topics,
    required String identifier,
    required MQTTAppState state,
  })  : _identifier = identifier,
        _host = host,
        _topics = topics, // Store the list of topics
        _currentState = state;

  void initializeMQTTClient() {
    _client = MqttServerClient(_host, _identifier);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 2;
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    _client!.logging(on: true);

    // Add the successful connection callback
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    _client!.connectionMessage = connMess;
  }

  // Connect to the host
  void connect() async {
    assert(_client != null);
    try {
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client!.connect();
    } on Exception catch (e) {
      // print('EXAMPLE::client exception - $e');
      disconnect();
    }
    _client?.updates!.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
      final String topic = c![0].topic;

      final parts = topic.split('/');
      // print('topic => $topic');
      // print('parts => $parts');
      if (parts.length > 1) {
        final deviceId = parts[1];
        MQTTAppState.instance.checkData();
        if (!MQTTAppState.instance.devices.contains(deviceId) && deviceId.startsWith('device')) {
          MQTTAppState.instance.addDevice(deviceId);
          MQTTAppState.instance.setSelectedDevice(MQTTAppState.instance.devices[0]); // Set the selected device
          // print('devices ${MQTTAppState.instance.devices}');
          // print('selectedDevice ${MQTTAppState.instance.selectedDevice}');
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

  // The subscribed callback
  void onSubscribed(String topic) {
    // print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  // The unsolicited disconnect callback
  void onDisconnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  // The successful connect callback
  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    // print('Connected to MQTT broker');
    for (var topic in _topics) {
      _client!.subscribe(topic, MqttQos.exactlyOnce);
    }
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
      final recMess = messages![0].payload as MqttPublishMessage;
      final topic = messages[0].topic;
      final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      // Set the received data for each topic separately in the app state
      _currentState.setReceivedText(topic, payload);
    });
  }
}

