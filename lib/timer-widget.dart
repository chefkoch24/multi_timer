import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:multi_timer/create-timer.dart';
import 'package:multi_timer/database.dart';
import 'package:multi_timer/utils/helper.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimerWidget extends StatefulWidget {
  final int id;
  final String name;
  final int time;
  final ValueChanged<bool> onChanged;

  @required
  TimerWidget({Key? key, required this.id, required this.name, required this.time, required this.onChanged})
      : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  DatabaseHelper db = DatabaseHelper.instance;
  late int _counterTimer;
  bool started = false;
  late Timer t;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _counterTimer = widget.time;
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                      child: Center(
                          child: Text(
                        widget.name,
                        style: TextStyle(fontSize: 16),
                      )),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 25,
                        //color: Color.fromRGBO(255, 0, 0, 1),
                        alignment: Alignment.topLeft,
                        child: !started
                            ? PopupMenuButton(
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
                                    _delete(widget.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Timer deleted")));
                                  }
                                },
                              )
                            : Container(),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    started
                        ? timeToStringHMS(_counterTimer)
                        : timeToStringHMS(widget.time),
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  started
                      ? TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          child: Text(
                            "STOP",
                            style: TextStyle(
                                fontSize: 14, color: Theme.of(context).textTheme.button?.color),
                          ),
                          onPressed: () {
                            _stop();
                          },
                        )
                      : TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            _startTimer();
                          },
                          child: Text(
                            "START",
                            style: TextStyle(
                                fontSize: 14, color: Theme.of(context).textTheme.button?.color),
                          )),
                ],
              ),
            ],
          ),
        ));
  }

  _scheduleNotification(){
    flutterLocalNotificationsPlugin.zonedSchedule(
        widget.id, 'Multi Timer', widget.name + ' is finished',
        tz.TZDateTime.now(tz.local).add(Duration(seconds: widget.time)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'full screen channel id', 'full screen channel name',
                channelDescription: 'full screen channel description',
                priority: Priority.high,
                importance: Importance.high,
                fullScreenIntent: true)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  _startTimer() async{
    logEvent("start_timer", {"time": widget.time});
    _counterTimer = widget.time;
    int counterIntern = _counterTimer;
    started = true;
    _scheduleNotification();
    t = Timer.periodic(Duration(seconds: 1), (t) {
      if (_counterTimer > 0) {
        if (this.mounted) {
          // check whether the state object is in tree
          setState(() {
            _counterTimer--;
          });
        }
        counterIntern--;
        // widget.onChanged(true);
      } else if (_counterTimer == 0 && counterIntern >= 0) {
        FlutterRingtonePlayer.play(
          android: AndroidSounds.alarm,
          ios: IosSounds.alarm,
          looping: true,
          // Android only - API >= 28
          volume: 1.0,
          // Android only - API >= 28
          asAlarm: true, // Android only - all APIs
        );

        counterIntern--;
      }
    });
  }

  void _delete(int id) {
    db.deleteTimer(id);
    widget.onChanged(true);
    logEvent("timer_deleted",{});

  }

  void _edit() {
    _navigateToEdit(
        CreateTimer(
          id: widget.id,
          name: widget.name,
          time: widget.time,
        ),
        context);
    logEvent("timer_edited", {'time': widget.time});
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

  Future<void> _stop() async {
    logEvent("stop_timer", {"time": widget.time});
    await flutterLocalNotificationsPlugin.cancel(widget.id);
    setState(() {
      t.cancel();
      started = false;
      _counterTimer = widget.time;
    });
    FlutterRingtonePlayer.stop();
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }
}
