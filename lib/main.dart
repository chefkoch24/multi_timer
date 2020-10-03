import 'package:flutter/material.dart';
import 'package:multi_timer/grid-view-timer.dart';
import 'package:multi_timer/settings.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Timer App',
      theme: ThemeData(
        primarySwatch: PRIMARY,
      ),
      home: GridViewTimer(title: "Multi Timer",),
      //HomeScreen()
    );
  }
}