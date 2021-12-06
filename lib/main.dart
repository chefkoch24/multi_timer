import 'package:flutter/material.dart';
import 'package:multi_timer/grid-view-timer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:multi_timer/settings.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Timer App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: GridViewTimer(title: "Multi Timer",),
      navigatorObservers: <NavigatorObserver>[observer],
      //HomeScreen()
    );
  }
}