import 'package:flutter/material.dart';
import 'package:multi_timer/settings.dart';
import 'package:multi_timer/utils/helper.dart';

class Imprint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logScreen(screenName: "Imprint", screenClass: "Imprint");
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Imprint"),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: STANDARD_DARK_TEXT),
              children: const <TextSpan>[
                TextSpan(
                    text: "Information in accordance with section 5 TMG:\n",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        "Felix Künnecke\nNadlerstr. 44\n68259 Mannheim\nE-Mail: multitimerapp@gmail.com")
              ],
            ),
          ),
        )));
  }
}
