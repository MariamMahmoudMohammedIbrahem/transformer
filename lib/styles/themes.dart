import '../commons.dart';

ThemeData darkTheme = ThemeData(
brightness: Brightness.dark,
primaryColor: Colors.yellow,
colorScheme: const ColorScheme.dark(
primary: Colors.yellow,
onPrimary: Colors.black,
secondary: Colors.yellow,
),
scaffoldBackgroundColor: Colors.black,
appBarTheme: const AppBarTheme(
backgroundColor: Colors.black,
titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
),
textTheme: TextTheme(
bodyMedium: const TextStyle(color: Colors.white, fontSize: 16),
bodySmall: TextStyle(color: Colors.grey[300]),
),
switchTheme: SwitchThemeData(
splashRadius: 50.0,
thumbColor: MaterialStateProperty.resolveWith((states) {
if (states.contains(MaterialState.selected)) {
return Colors.yellow;
}
return Colors.grey.shade300;
}),
trackColor: MaterialStateProperty.resolveWith((states) {
if (states.contains(MaterialState.selected)) {
return Colors.yellow.shade300;
}
return Colors.grey.shade800;
}),
),
);