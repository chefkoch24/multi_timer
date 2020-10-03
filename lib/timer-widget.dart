import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multi_timer/create-timer.dart';
import 'package:multi_timer/database.dart';
import 'package:multi_timer/settings.dart';
import 'package:multi_timer/utils/helper.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class TimerWidget extends StatefulWidget {
  final int id;
  final String name;
  final int time;
  final ValueChanged<bool> onChanged;

  @required
  TimerWidget({Key key, this.id, this.name, this.time, this.onChanged})
      : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  DatabaseHelper db = DatabaseHelper.instance;
  int _counter;
  bool started = false;
  Timer t;

  @override
  void initState() {
    _counter = widget.time;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (started == false) _startTimer();
        },
        child: Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child:  Center(child: Text(widget.name, style: TextStyle(fontSize: 16),)),
                    ),
                     Expanded(
                      flex: 1,
                      child: Container(
                        height: 25,
                        //color: Color.fromRGBO(255, 0, 0, 1),
                        alignment: Alignment.topLeft,
                        child: !started ? PopupMenuButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: "edit",
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Text('Delete'),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == "edit") {
                              _edit();
                            } else if (value == "delete") {
                              _delete();
                              Scaffold.of(context).showSnackBar(SnackBar(content:Text("Deleted")));
                            }
                          },
                        ) : Container(),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Text(started
                        ? timeToStringHMS(_counter)
                        : timeToStringHMS(widget.time),
                    style: TextStyle(fontSize: 24),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  started
                      ? FlatButton(

                    color: Colors.red,
                    textColor: STANDARD_LIGHT_TEXT,
                    child: Text("STOP", style: TextStyle(fontSize: 14),),
                    onPressed: () {
                      _stop();
                    },
                  )
                      : Container(),
                ],
              ),
            ],
          ),
        ));
  }

  _startTimer() {
    _counter = widget.time;
    started = true;
    t = Timer.periodic(Duration(seconds: 1), (t) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
        widget.onChanged(true);
      } else if (_counter == 0) {
        FlutterRingtonePlayer.play(
          android: AndroidSounds.alarm,
          ios: IosSounds.alarm,
          looping: true,
          // Android only - API >= 28
          volume: 1.0,
          // Android only - API >= 28
          asAlarm: true, // Android only - all APIs
        );
      } else {
        t.cancel();
        setState(() {
          started = false;
        });
      }
    });
  }

  void _delete() {
    db.deleteTimer(widget.id);
    widget.onChanged(true);
  }

  void _edit() {
    _navigateToEdit(
        CreateTimer(
          id: widget.id,
          name: widget.name,
          time: widget.time,
        ),
        context);
  }

  void _navigateToEdit(Widget w, BuildContext context) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => w),
    );
    if (result) {
      widget.onChanged(true);
    }
  }

  void _widgetHasChanged() {
    widget.onChanged(true);
  }

  void _stop() {
    setState(() {
      t.cancel();
      started = false;
      _counter = widget.time;
    });
    FlutterRingtonePlayer.stop();
  }
}
