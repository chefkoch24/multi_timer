import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_timer/database.dart';
import 'package:multi_timer/model/timer.dart';
import 'package:multi_timer/utils/helper.dart';
import 'package:numberpicker/numberpicker.dart';
import 'settings.dart';

class CreateTimer extends StatefulWidget {
  final String name;
  final int time;
  final int? id;

  CreateTimer({Key? key, this.id, required this.name, required this.time})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTimerState();
}

class _CreateTimerState extends State<CreateTimer> {
  final DatabaseHelper db = DatabaseHelper.instance;
  final nameController = TextEditingController();
  int hour = 0;
  int min = 0;
  int sec = 0;
  bool editMode = false;
  final _timernameForm = GlobalKey<FormFieldState>();
  bool isError = false;
  late int maximumNuberOfTimer;

  @override
  void initState() {
    if (widget.time != 0) {
      this.hour = intToHour(widget.time);
      this.min = intToMin(widget.time);
      this.sec = intToSec(widget.time);
      editMode = true;
      nameController.text = widget.name;
    }
    db.getNumberOfTimer().then((value) {
      maximumNuberOfTimer = value;
    });
    super.initState();
    if (editMode) {
      logScreen(screenName: "Edit Timer", screenClass: "CreateTimer");
    } else {
      logScreen(screenName: "Create Timer", screenClass: "CreateTimer");
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(editMode ? "Edit" : "Create"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10,),
                TextFormField(
                  cursorColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                  decoration: InputDecoration(
                    labelText: "Timername",
                  ),
                  key: _timernameForm,
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a timer name';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 25,
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
                            child: Text(
                              "hours",
                              // style: isError ? errorStyle() : normalStyle(),
                            ),
                          ),
                          NumberPicker(
                            selectedTextStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color,
                                fontSize: 24),
                            value: hour,
                            minValue: 0,
                            maxValue: 23,
                            onChanged: (val) {
                              setState(() {
                                hour = val;
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
                            child: Text(
                              "minutes",
                              // style: isError ? errorStyle() : normalStyle()
                            ),
                          ),
                          NumberPicker(
                            selectedTextStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color,
                                fontSize: 24),
                            value: min,
                            minValue: 0,
                            maxValue: 59,
                            onChanged: (val) {
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
                            child: Text(
                              "seconds",
                              //style: isError ? errorStyle() : normalStyle()
                            ),
                          ),
                          NumberPicker(
                            selectedTextStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color,
                                fontSize: 24),
                            value: sec,
                            minValue: 0,
                            maxValue: 59,
                            onChanged: (val) {
                              setState(() {
                                sec = val;
                              });
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width) / 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (hour + min + sec <= 0) {
                          setState(() {
                            isError = true;
                            showErrorMessage();
                          });
                        } else {
                          setState(() {
                            isError = false;
                          });
                        }
                        if (_timernameForm.currentState!.validate() &&
                            isError != true) {
                          isError = false;
                          if (editMode) {
                            _update();
                            Navigator.pop(context, true);
                          } else {
                            _save();
                            maximumNuberOfTimer <
                                    Settings.MAXIMUM_NUMBER_OF_TIMER
                                ? Navigator.pop(
                                    context, "Timer successful created")
                                : Navigator.pop(context,
                                    "You have already maximum number of timer");
                          }
                        }
                        // showSnackBar(context, "Created");
                      },
                      child: Text(
                        editMode ? "Update" : "Create",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context).textTheme.button?.color),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _save() {
    if (Settings.MAXIMUM_NUMBER_OF_TIMER > maximumNuberOfTimer) {
      MyTimer t = new MyTimer(
          name: nameController.text, time: hourMinSecToInt(hour, min, sec));
      db.insert(t);
    }
    logEvent("timer_created", {'time': hourMinSecToInt(hour, min, sec)});
  }

  void _update() {
    MyTimer t = new MyTimer(
        id: widget.id,
        name: nameController.text,
        time: hourMinSecToInt(hour, min, sec));
    db.updateTimer(t);
    logEvent("timer_updated", {'time': hourMinSecToInt(hour, min, sec)});
  }

  void showSnackBar(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage() {
    Fluttertoast.showToast(
      msg: "Please set a timer",
    );
  }
}
