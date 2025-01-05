import '../commons.dart';

part 'dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  createState() => _DashboardScreen();
}

class _DashboardScreen extends DashboardController {
  @override
  Widget build(BuildContext context) {
    final MQTTAppConnectionState state = currentAppState.getAppConnectionState;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.yellow.shade300,
        elevation: 3,
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
          Expanded(
            child: Consumer<MQTTAppState>(
              builder: (context, appState, child) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation:2.0,
                        shadowColor: Colors.black,
                        margin: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        color: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color:Colors.yellow,
                            width: 0.0,
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
                          ),
                          DataCard(
                            title: "Voltage Phase 2",
                            value: appState.getDataFromMap('volt_p2', 'data'),
                            unit: "V",
                            isAlert: appState.getDataFromMap('V_ph2_Status','alarm'),
                          ),
                          DataCard(
                            title: "Voltage Phase 3",
                            value: appState.getDataFromMap('volt_p3', 'data'),
                            unit: "V",
                            isAlert: appState.getDataFromMap('V_ph3_Status','alarm'),
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
                          ),
                          DataCard(
                            title: "Current Phase 2",
                            value: appState.getDataFromMap('cur_p2', 'data'),
                            unit: "A",
                            isAlert: appState.getDataFromMap('C_ph2_Status','alarm'),
                          ),
                          DataCard(
                            title: "Current Phase 3",
                            value: appState.getDataFromMap('cur_p3', 'data'),
                            unit: "A",
                            isAlert: appState.getDataFromMap('C_ph3_Status','alarm'),
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
}