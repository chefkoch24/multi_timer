import 'package:flutter/material.dart';

class DataPolicy extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Data Policy"),
      ),
      body: Container(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text("Data Policy"),
      )),
    );
  }
}
