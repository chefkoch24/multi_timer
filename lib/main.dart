import 'package:flutter/material.dart';
import 'package:multi_timer/grid-view-timer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Timer App',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.green,
          secondaryHeaderColor: Colors.green,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.green,
          ),
          textTheme: TextTheme(
              button: TextStyle(color: Colors.white),
              headline1: TextStyle(color: Colors.green),
            bodyText1: TextStyle(color: Colors.black)
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.black87),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
          )),
      /* light theme settings */
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.green[700],
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.green[700],
          ),
          /* dark theme settings */
          textTheme: TextTheme(
              button: TextStyle(color: Colors.white),
              headline1: TextStyle(color: Colors.green[700]),
              bodyText1: TextStyle(color: Colors.white)
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          )),
      themeMode: ThemeMode.system,
      /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
      debugShowCheckedModeBanner: false,
      home: GridViewTimer(
        title: "Multi Timer",
      ),
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}
