import 'dart:convert';
import 'package:flutter/cupertino.dart';

import '../constants/constants.dart';
import '../main.dart';
import '../widgets/local_notification_helper.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class MQTTAppState with ChangeNotifier {
  static MQTTAppState? _instance;

  MQTTAppState._internal();

  static MQTTAppState get instance {
    _instance ??= MQTTAppState._internal();
    return _instance!;
  }

  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;
  String _historyText = '';
  final Map<String, dynamic> _dataByTopic = {};

  List<String> _devices = [];
  String _selectedDevice = '';

  void setReceivedText(String topic, String jsonText) {
    print('topic => $topic, jsonText => $jsonText');
    // Decode the incoming JSON
    try {
      final data = json.decode(jsonText);
      if (data is Map<String, dynamic>) {
        _dataByTopic[topic] = data;
        print('_dataByTopic $_dataByTopic, topic $topic, _dataByTopic[topic] $_dataByTopic[topic]');
        _historyText = '$_historyText\n$jsonText';
        notifyListeners();
      }
    } catch (e) {
      print("Error decoding JSON: $e");
    }
  }

  void checkData() {
    // for (var device in _devices) {
      final data = _dataByTopic['EOIP/dev1/alarm/energy/transformer'];

      if (data != null) {
        checkAndNotify(data, 'V_ph1_Status', 'Voltage Phase 1 Alert', 2);
        checkAndNotify(data, 'V_ph2_Status', 'Voltage Phase 2 Alert', 3);
        checkAndNotify(data, 'V_ph3_Status', 'Voltage Phase 3 Alert',4);
        checkAndNotify(data, 'C_ph1_Status', 'Current Phase 1 Alert', 5);
        checkAndNotify(data, 'C_ph2_Status', 'Current Phase 2 Alert', 6);
        checkAndNotify(data, 'C_ph3_Status', 'Current Phase 3 Alert', 7);
        checkAndNotify(data, 'Bokhlez_Status1', 'Bokhlez Sensor 1 Alert', 7);
        checkAndNotify(data, 'Bokhlez_Status2', 'Bokhlez Sensor 2 Alert', 7);
        checkAndNotify(data, 'Amb_Temp_Status', 'Ambient Temperature Alert', 7);
        checkAndNotify(data, 'Oil_Temp_Status', 'Oil Temperature Alert', 7);

        // Example check for another parameter
        // if (data['load_per'] != null && data['load_per'] > 80) {
        //   showOngoingNotification(notifications, title: 'Load Alert', body: 'High Load Detected', id: 9);
        // }
        // "Oil_Level_Status": "low",
    // "Bokhlez_Status1": "inactive",
    // "Bokhlez_Status2": "inactive",
    // "Amb_Temp_Status": "high",
    // "Oil_Temp_Status": "low",
      }
    // }
  }

  void checkAndNotify(Map<String, dynamic> data, String key, String title, int id) {
    if (data.containsKey(key)) {
      showOngoingNotification(notifications, title: title, body: data[key], id: id);
    }
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  Map<String, dynamic> getDataForTopic(String topic) => _dataByTopic[topic] ?? {};
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
  String get getHistoryText => _historyText;

  List<String> get devices => _devices;
  String get selectedDevice => _selectedDevice;

  void addDevice(String device) {
    _devices.add(device);
    notifyListeners();
  }

  void setSelectedDevice(String device) {
    _selectedDevice = device;
    notifyListeners();
  }

  /*double getDataFromMap (String dataType) {
    final topic = 'remote/$_selectedDevice/$dataType';
    final data = _dataByTopic[topic];
    return data != null ? data[dataType] ?? 0.0 : 0.0;
  }*/

  /*String getDataFromMap(String dataType) {
    final topic = 'EOIP/$_selectedDevice/sensor/data';
    // final topic = 'remote/$_selectedDevice/$dataType';
    final data = _dataByTopic[topic];
    print('data[$dataType] => ${data[dataType]}');
    return data != null ? data[dataType]?.toString() ?? '' : '';
  }*/

  String getDataFromMap(String dataType, String type) {
    final topic = 'EOIP/dev1/$type/energy/transformer';
    final data = _dataByTopic[topic];
    print('Data for topic "$topic": $data');  // Debugging line
    if (data == null) {
      return '';
    }
    return data[dataType]?.toString() ?? '';
  }

}
