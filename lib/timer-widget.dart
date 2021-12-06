import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:multi_timer/create-timer.dart';
import 'package:multi_timer/database.dart';
import 'package:multi_timer/settings.dart';
import 'package:multi_timer/utils/helper.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimerWidget extends StatefulWidget {
  final int? id;
  final String name;
  final int time;
  final ValueChanged<bool> onChanged;

  @required
  TimerWidget({Key? key, this.id, required this.name, required this.time, required this.onChanged})
      : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  DatabaseHelper db = DatabaseHelper.instance;
  late int _counterTimer;
  bool started = false;
  late Timer t;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int timerId = 0;
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
                                    _delete(widget.id!);
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
                                fontSize: 14, color: Settings.STANDARD_LIGHT_TEXT),
                          ),
                          onPressed: () {
                            _stop();
                          },
                        )
                      : TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          onPressed: () {
                            _startTimer();
                          },
                          child: Text(
                            "START",
                            style: TextStyle(
                                fontSize: 14, color: Settings.STANDARD_LIGHT_TEXT),
                          )),
                ],
              ),
            ],
          ),
        ));
  }

  _startTimer() async{
    logEvent("start_timer", {"time": widget.time});
    _counterTimer = widget.time;
    int counterIntern = _counterTimer;
    started = true;
    print(_counterTimer);
    flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
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
        //showNotification();
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

  void _stop() {
    AndroidAlarmManager.cancel(0);
    logEvent("stop_timer", {"time": widget.time});
    setState(() {
      t.cancel();
      started = false;
      _counterTimer = widget.time;
    });
    FlutterRingtonePlayer.stop();
  }

  showNotification() {
    print("timer");
    var android = AndroidNotificationDetails('id', 'channel ',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.show(
        0, 'Multi Timer', widget.name + ' is finished', platform,
        payload: 'Welcome to the Local Notification demo');
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }
}
