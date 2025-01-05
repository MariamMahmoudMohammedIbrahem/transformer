
import 'package:transformer/screens/dashboard_screen.dart';

import 'commons.dart';

final notifications = FlutterLocalNotificationsPlugin();
void main() {
  initialization();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MQTTAppState.instance,
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    currentAppState = Provider.of<MQTTAppState>(context);
    return MaterialApp(
      title: 'Transformer',
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}
