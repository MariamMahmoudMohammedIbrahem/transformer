
import '../commons.dart';

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

  final List<String> _devices = [];
  String _selectedDevice = '';

  void setReceivedText(String topic, String jsonText) {
    try {
      final data = json.decode(jsonText);
      if (data is Map<String, dynamic>) {
        _dataByTopic[topic] = data;
        _historyText = '$_historyText\n$jsonText';
        notifyListeners();
      }
    } catch (e) {
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

      }
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


  String getDataFromMap(String dataType, String type) {
    final topic = 'EOIP/dev1/$type/energy/transformer';
    final data = _dataByTopic[topic];
    if (data == null) {
      return '';
    }
    return data[dataType]?.toString() ?? '';
  }

}
