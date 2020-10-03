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
  final int id;

  CreateTimer({Key key, @required this.id, this.name, this.time})
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
  int maximumNuberOfTimer;

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
        body: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: "Timername"),
                    key: _timernameForm,
                    controller: nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  /* isError
                      ? Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Please enter a time",
                                style: TextStyle(color: ERROR_TEXT, fontSize: 12),
                              )
                            ],
                          ),
                        )
                      : Container(),*/
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
                                "HH",
                               // style: isError ? errorStyle() : normalStyle(),
                              ),
                            ),
                            NumberPicker.integer(
                              initialValue: hour,
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
                              child: Text("MM",
                                 // style: isError ? errorStyle() : normalStyle()
                              ),
                            ),
                            NumberPicker.integer(
                              initialValue: min,
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
                              child: Text("SS",
                                  //style: isError ? errorStyle() : normalStyle()
                              ),
                            ),
                            NumberPicker.integer(
                              initialValue: sec,
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
                      child: FlatButton(
                        color: PRIMARY,
                        textColor: STANDARD_LIGHT_TEXT,
                        disabledTextColor: STANDARD_DARK_TEXT,
                        padding: EdgeInsets.all(8.0),
                        splashColor: PRIMARY,
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
                          if (_timernameForm.currentState.validate() &&
                              isError != true) {
                            isError = false;
                            if (editMode) {
                              _update();
                            } else {
                              _save();
                            }
                            maximumNuberOfTimer < MAXIMUM_NUMBER_OF_TIMER ? Navigator.pop(context, "Timer successful created"): Navigator.pop(context, "You have already maximum nuber of timer");
                          }
                          // showSnackBar(context, "Created");
                        },
                        child: Text(
                          editMode ? "Update" : "Create",
                          style: TextStyle(fontSize: 20.0),
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
    if (MAXIMUM_NUMBER_OF_TIMER > maximumNuberOfTimer) {
      MyTimer t = new MyTimer(
          name: nameController.text, time: hourMinSecToInt(hour, min, sec));
      db.insert(t);
    }
  }

  void _update() {
    MyTimer t = new MyTimer(
        id: widget.id,
        name: nameController.text,
        time: hourMinSecToInt(hour, min, sec));
    db.updateTimer(t);
  }

  void showSnackBar(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  TextStyle normalStyle() {
    return TextStyle(
      color: STANDARD_DARK_TEXT,
    );
  }

  TextStyle errorStyle() {
    return TextStyle(color: ERROR_TEXT);
  }

  void showErrorMessage(){
    Fluttertoast.showToast(
      msg: "Please set a timer",
      backgroundColor: ERROR_TEXT,
    );
  }
}
