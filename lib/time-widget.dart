import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TimeWidget extends StatefulWidget {

  @override
  _TimeWidgetState createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  int hour = 0;
  int min = 0;
  int sec = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Padding(
      padding: const EdgeInsets.only(
        top:20,
        left: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: 1.0,
                ),
                child: Text("HH"),
              ),
              NumberPicker(
                value: hour,
                minValue: 0,
                maxValue: 23,
                step: 1,
                haptics: true,
                onChanged: (val) => setState(() => hour = val),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: 1.0,
                ),
                child: Text("MM"),
              ),
              NumberPicker(
                value: min,
                minValue: 0,
                maxValue: 59,
                onChanged: (val){
                  setState(() {
                    min = val;
                  });
                },
              )
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: 1.0,
                ),
                child: Text("SS"),
              ),
              NumberPicker(
                value: sec,
                minValue: 0,
                maxValue: 59,
              //  listViewWidth: 60.0,
                onChanged: (val){
                  setState(() {
                    sec = val;
                  });
                },
              )
            ],
          )
        ],
      ),
    );

  }
}
