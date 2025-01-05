import 'dart:ffi';

import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../main.dart';
import '../mqtt/MQTTAppState.dart';
import '../mqtt/MQTTManager.dart';
import '../widgets/local_notification_helper.dart';
import 'historical_data_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // final notifications = FlutterLocalNotificationsPlugin();
  /*@override
  void initState() {
    super.initState();
    */ /*notifications.initialize(
      const InitializationSettings(android: settingsAndroid),
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );*/ /*
    // Call _configureAndConnect after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      configureAndConnect();
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final MQTTAppConnectionState state = currentAppState.getAppConnectionState;

    return Scaffold(
      appBar: AppBar(
        // surfaceTintColor: Colors.yellow.shade300,
        shadowColor: Colors.yellow.shade300,
        elevation: 3,
        // backgroundColor: Colors.yellow,
        // foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: const Text(
          'Dashboard',
        ),
        titleTextStyle: const TextStyle(
          color: Colors.yellow,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoricalDataScreen()));
            },
            icon: const Icon(Icons.history_rounded),
          ),
            Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: state == MQTTAppConnectionState.disconnected
                  ? configureAndConnect
                  : disconnect,
              child: Text(state == MQTTAppConnectionState.disconnected
                  ? 'Connect'
                  : 'Disconnect'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          /*if (MQTTAppState.instance.devices.length > 1)
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 16.0,
                bottom: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select the device'),
                  DropdownButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    value: MQTTAppState.instance.devices.isNotEmpty
                        ? MQTTAppState.instance.selectedDevice ??
                            MQTTAppState.instance.devices[0]
                        : "",
                    items: MQTTAppState.instance.devices
                        .map<DropdownMenuItem<String>>((device) {
                      return DropdownMenuItem<String>(
                        value: device,
                        child: Text(device),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        MQTTAppState.instance.setSelectedDevice(newValue!);
                        // print(
                        //     'MQTTAppState.instance.selectedDevice ${MQTTAppState.instance.selectedDevice}');
                      });
                    },
                  ),
                ],
              ),
            ),*/
          Expanded(
            child: Consumer<MQTTAppState>(
              builder: (context, appState, child) {
                // bool isAlert = appState.getDataFromMap("b")
                //         .isNotEmpty &&
                //     int.parse(appState.getDataFromMap("b")) <
                //         20 &&
                //     int.parse(appState.getDataFromMap("b")) >
                //         0.0;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: /*isAlert ? 8.0 : */2.0,
                        shadowColor:
                            /*isAlert ? Colors.red.shade900 : */Colors.black,
                        margin: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        color: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color:
                               /* isAlert ? Colors.red.shade900 : */Colors.yellow,
                            width: /*isAlert ? 1.0 : */0.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Battery',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow.shade200,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '100',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey.shade100,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    '%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                        ),
                        child: Divider(
                          indent: 20,
                          endIndent: 20,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      // Voltage GridView
                      GridView.count(
                        crossAxisCount: 3,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          DataCard(
                            title: "Voltage Phase 1",
                            value: appState.getDataFromMap('volt_p1', 'data'),
                            unit: "V",

                            isAlert: appState.getDataFromMap('V_ph1_Status','alarm'),
                            // lowThreshold: double.parse(appState.getDataFromMap('under_thr_volt', 'data')),
                            // highThreshold: double.parse(appState.getDataFromMap('over_thr_volt', 'data')),
                          ),
                          DataCard(
                            title: "Voltage Phase 2",
                            value: appState.getDataFromMap('volt_p2', 'data'),
                            unit: "V",
                            isAlert: appState.getDataFromMap('V_ph2_Status','alarm'),
                            // lowThreshold: double.parse(appState.getDataFromMap('under_thr_volt', 'data')),
                            // highThreshold: double.parse(appState.getDataFromMap('over_thr_volt', 'data')),
                          ),
                          DataCard(
                            title: "Voltage Phase 3",
                            value: appState.getDataFromMap('volt_p3', 'data'),
                            unit: "V",
                            isAlert: appState.getDataFromMap('V_ph3_Status','alarm'),
                            // lowThreshold: double.parse(appState.getDataFromMap('under_thr_volt', 'data')),
                            // highThreshold: double.parse(appState.getDataFromMap('over_thr_volt', 'data')),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Divider(
                          indent: 20,
                          endIndent: 20,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      // Current GridView
                      GridView.count(
                        crossAxisCount: 3,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          DataCard(
                            title: "Current Phase 1",
                            value: appState.getDataFromMap('cur_p1', 'data'),
                            unit: "A",
                            isAlert: appState.getDataFromMap('C_ph1_Status','alarm'),
                            // lowThreshold: double.parse(appState.getDataFromMap('under_thr_current', 'data')),
                            // highThreshold: double.parse(appState.getDataFromMap('over_thr_current', 'data')),
                          ),
                          DataCard(
                            title: "Current Phase 2",
                            value: appState.getDataFromMap('cur_p2', 'data'),
                            unit: "A",
                            isAlert: appState.getDataFromMap('C_ph2_Status','alarm'),
                            // lowThreshold: double.parse(appState.getDataFromMap('under_thr_current', 'data')),
                            // highThreshold: double.parse(appState.getDataFromMap('over_thr_current', 'data')),
                          ),
                          DataCard(
                            title: "Current Phase 3",
                            value: appState.getDataFromMap('cur_p3', 'data'),
                            unit: "A",
                            isAlert: appState.getDataFromMap('C_ph3_Status','alarm'),
                            // lowThreshold: double.parse(appState.getDataFromMap('under_thr_current', 'data')),
                            // highThreshold: double.parse(appState.getDataFromMap('over_thr_current', 'data')),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Divider(
                          indent: 20,
                          endIndent: 20,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      // Temperature GridView
                      GridView.count(
                        crossAxisCount: 3,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: DataCard(
                              title: "Ambient Temperature",
                              value: appState.getDataFromMap('amb_temp','data'),
                              unit: "°C",
                              isAlert: appState.getDataFromMap('Amb_Temp_Status','alarm'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16.0,
                            ),
                            child: Card(
                              elevation: appState.getDataFromMap('Oil_Level_Status','alarm') ==
                                          'low' ||
                                  appState.getDataFromMap('Oil_Level_Status','alarm') ==
                                          'high'
                                  ? 8.0
                                  : 2.0,
                              shadowColor: appState.getDataFromMap('Oil_Level_Status','alarm') ==
                                          'low' ||
                                  appState.getDataFromMap('Oil_Level_Status','alarm') ==
                                          'high'
                                  ? Colors.red.shade900
                                  : Colors.black,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: appState.getDataFromMap('Oil_Level_Status','alarm') ==
                                              'low' ||
                                      appState.getDataFromMap('Oil_Level_Status','alarm') ==
                                              'high'
                                      ? Colors.red.shade900
                                      : Colors.yellow,
                                  width: appState.getDataFromMap('Oil_Level_Status','alarm') ==
                                              'low' ||
                                      appState.getDataFromMap('Oil_Level_Status','alarm') ==
                                              'high'
                                      ? 1.0
                                      : 0.0,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              color: Theme.of(context).cardColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Oil\n Level',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow.shade200,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8.0),
                                    if (appState.getDataFromMap('Oil_Level_Status','alarm')
                                        .isNotEmpty)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          /*if (appState.getDataFromMap('ola') !=
                                                  'normal' ||
                                              appState.getDataFromMap('ola')
                                                  .isNotEmpty)*/
                                            if (appState.getDataFromMap('Oil_Level_Status','alarm') !=
                                                'inactive')
                                              Icon(
                                                appState.getDataFromMap('Oil_Level_Status','alarm') ==
                                                        'high'
                                                    ? Icons.arrow_upward_rounded
                                                    : appState.getDataFromMap('Oil_Level_Status','alarm') ==
                                                    'low'?Icons
                                                        .arrow_downward_rounded:null,
                                                color: Colors.red.shade900,
                                                size: 30,
                                              ),
                                          Text(
                                            appState.getDataFromMap('Oil_Level_Status','alarm'),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                          /*const SizedBox(
                                            width: 5,
                                          ),
                                          const Text(
                                            'l',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),*/
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16.0,
                            ),
                            child: Card(
                              elevation: appState.getDataFromMap('Oil_Temp_Status','alarm') ==
                                          'low' ||
                                      appState.getDataFromMap('Oil_Temp_Status','alarm') ==
                                          'high'
                                  ? 8.0
                                  : 2.0,
                              shadowColor: appState.getDataFromMap('Oil_Temp_Status','alarm') ==
                                          'low' ||
                                      appState.getDataFromMap('Oil_Temp_Status','alarm') ==
                                          'high'
                                  ? Colors.red.shade900
                                  : Colors.black,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color:appState.getDataFromMap('Oil_Temp_Status','alarm') ==
                                              'low' ||
                                      appState.getDataFromMap('Oil_Temp_Status','alarm') ==
                                              'high'
                                      ? Colors.red.shade900
                                      : Colors.yellow,
                                  width: appState.getDataFromMap('Oil_Temp_Status','alarm') ==
                                              'low' ||
                                      appState.getDataFromMap('Oil_Temp_Status','alarm') ==
                                              'high'
                                      ? 1.0
                                      : 0.0,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              color: Theme.of(context).cardColor,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Oil\n Temperature',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow.shade200,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8.0),
                                    // if (appState.getDataFromMap('Oil_Temp_Status','alarm')
                                    //     .isNotEmpty)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (appState.getDataFromMap('Oil_Temp_Status','alarm') !=
                                                  'inactive' /*&&
                                              appState.getDataFromMap('ota')
                                                  .isNotEmpty*/)
                                            if(appState.getDataFromMap('Oil_Temp_Status','alarm').isNotEmpty || appState.getDataFromMap('Oil_Temp_Status','alarm') ==
                                                'inactive') Icon(
                                              appState.getDataFromMap('Oil_Temp_Status','alarm') ==
                                                      'high'
                                                  ? Icons.arrow_upward_rounded
                                                  : Icons
                                                      .arrow_downward_rounded,
                                              color: Colors.red.shade900,
                                              size: 30,
                                            ),
                                          Text(
                                            appState.getDataFromMap('amb_temp','data'),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text(
                                            '°C',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Divider(
                          indent: 20,
                          endIndent: 20,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      GridView.count(
                        crossAxisCount: 2,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16.0,
                            ),
                            child: Card(
                              elevation: appState.getDataFromMap('Bokhlez_Status1','alarm') ==
                                  'low' ||
                                  appState.getDataFromMap('Bokhlez_Status1','alarm') ==
                                      'high'
                                  ? 8.0
                                  : 2.0,
                              shadowColor: appState.getDataFromMap('Bokhlez_Status1','alarm') ==
                                  'low' ||
                                  appState.getDataFromMap('Bokhlez_Status1','alarm') ==
                                      'high'
                                  ? Colors.red.shade900
                                  : Colors.black,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: appState.getDataFromMap('Bokhlez_Status1','alarm') ==
                                      'low' ||
                                      appState.getDataFromMap('Bokhlez_Status1','alarm') ==
                                          'high'
                                      ? Colors.red.shade900
                                      : Colors.yellow,
                                  width: appState.getDataFromMap('Bokhlez_Status1','alarm') ==
                                      'low' ||
                                      appState.getDataFromMap('Bokhlez_Status1','alarm') ==
                                          'high'
                                      ? 1.0
                                      : 0.0,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              margin:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              color: Theme.of(context).cardColor,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Bokhlez\n Sensor 1',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow.shade200,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8.0),
                                    if (appState.getDataFromMap('Bokhlez_Status1','alarm') !=
                                        'inactive' &&
                                        appState.getDataFromMap('Bokhlez_Status1','alarm')
                                            .isNotEmpty)
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [

                                          Icon(
                                            appState.getDataFromMap('Bokhlez_Status1','alarm') ==
                                                'high'
                                                ? Icons.arrow_upward_rounded
                                                : Icons.arrow_downward_rounded,
                                            color: Colors.red.shade900,
                                            size: 30,
                                          ),
                                          Text(
                                            appState.getDataFromMap('Bokhlez_Status1','alarm'),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16.0,
                            ),
                            child: Card(
                              elevation: appState.getDataFromMap('Bokhlez_Status2','alarm') ==
                                  'low' ||
                                  appState.getDataFromMap('Bokhlez_Status2','alarm') ==
                                      'high'
                                  ? 8.0
                                  : 2.0,
                              shadowColor: appState.getDataFromMap('Bokhlez_Status2','alarm') ==
                                  'low' ||
                                  appState.getDataFromMap('Bokhlez_Status2','alarm') ==
                                      'high'
                                  ? Colors.red.shade900
                                  : Colors.black,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: appState.getDataFromMap('Bokhlez_Status2','alarm') ==
                                      'low' ||
                                      appState.getDataFromMap('Bokhlez_Status2','alarm') ==
                                          'high'
                                      ? Colors.red.shade900
                                      : Colors.yellow,
                                  width: appState.getDataFromMap('Bokhlez_Status2','alarm') ==
                                      'low' ||
                                      appState.getDataFromMap('Bokhlez_Status2','alarm') ==
                                          'high'
                                      ? 1.0
                                      : 0.0,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              margin:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              color: Theme.of(context).cardColor,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Bokhlez\n Sensor 2',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow.shade200,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8.0),
                                    if (appState.getDataFromMap('Bokhlez_Status2','alarm') !=
                                        'inactive' &&
                                        appState.getDataFromMap('Bokhlez_Status2','alarm')
                                            .isNotEmpty)
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [

                                          Icon(
                                            appState.getDataFromMap('Bokhlez_Status2','alarm') ==
                                                'high'
                                                ? Icons.arrow_upward_rounded
                                                : Icons.arrow_downward_rounded,
                                            color: Colors.red.shade900,
                                            size: 30,
                                          ),
                                          Text(
                                            appState.getDataFromMap('Bokhlez_Status2','alarm'),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController _messageTextController = TextEditingController();

  @override
  void dispose() {
    _messageTextController.dispose();
    manager.disconnect();
    super.dispose();
  }
  /*void _publishMessage(String text) {
    manager.publish(text);
    currentAppState.addSentMessage(text); // Add the sent message to the history
    _messageTextController.clear();
  }*/
}

class DataCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String isAlert;
  // final double lowThreshold;
  // final double highThreshold;

  const DataCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.isAlert,
    // required this.lowThreshold,
    // required this.highThreshold,
  });

  @override
  Widget build(BuildContext context) {
    // print('value $value');
    final double valueNumeric = double.tryParse(value.split(' ')[0]) ?? 0.0;

    // final bool isAlert =
    //     ((valueNumeric > highThreshold) || (valueNumeric < lowThreshold)) &&
    //         valueNumeric != 0.0;
    return Card(
      elevation: /*isAlert ? 8.0 : */2.0,
      shadowColor: isAlert!='inactive'&&isAlert.isNotEmpty ? Colors.red.shade900 : Colors.black,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isAlert!='inactive'&&isAlert.isNotEmpty ? Colors.red.shade900 : Colors.yellow,
          width: isAlert!='inactive'&&isAlert.isNotEmpty ? 1.0 : 0.0,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.yellow.shade200,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            if (valueNumeric != 0.0)
              Row(
                mainAxisAlignment:
                    /*valueNumeric > highThreshold || valueNumeric < lowThreshold
                      ? MainAxisAlignment.start
                      : */
                    MainAxisAlignment.center,
                children: [
                  if (isAlert!='inactive'&&isAlert.isNotEmpty)
                    Icon(
                      isAlert == 'high'
                          ? Icons.arrow_upward_rounded
                          : isAlert == 'low'
                              ? Icons.arrow_downward_rounded
                              : null,
                      color: Colors.red.shade900,
                      size: 25,
                    ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
