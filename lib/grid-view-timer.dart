import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:multi_timer/create-button.dart';
import 'package:multi_timer/data-policy.dart';
import 'package:multi_timer/database.dart';
import 'package:multi_timer/main.dart';
import 'package:multi_timer/model/timer.dart';
import 'package:multi_timer/settings.dart';
import 'package:multi_timer/timer-widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GridViewTimer extends StatefulWidget {
  GridViewTimer({Key key, this.title}) : super(key: key);

  final String title;
  final InAppReview inAppReview = InAppReview.instance;

  @override
  _GridViewTimerState createState() => _GridViewTimerState();
}

class _GridViewTimerState extends State<GridViewTimer> {
  DatabaseHelper db = DatabaseHelper.instance;
  List<MyTimer> timers = new List<MyTimer>();
  int numberOfTimer = 0;

  @override
  void initState() {
    super.initState();
    db.getAllTimers().then((value) {
      timers = value;
      numberOfTimer = value.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    //int numberOfTimer = timers.length;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
            future: db.getAllTimers(),
            initialData: [],
            builder: (ctx, snapshot) {
              numberOfTimer++;
              return _createTimerGridView(ctx, snapshot);
            }),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  Text('Multi Timer'),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: new CircularPercentIndicator(
                      radius: 80.0,
                      lineWidth: 5.0,
                      percent: numberOfTimer / MAXIMUM_NUMBER_OF_TIMER,
                      center: new Text(
                          "$numberOfTimer of $MAXIMUM_NUMBER_OF_TIMER"),
                      progressColor: Colors.white,
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: PRIMARY,
              ),
            ),
            ListTile(
              title: Text('Datapolicy'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataPolicy(),
                      settings: RouteSettings(name: 'Data Policy'),
                    ));
              },
            ),
            ListTile(
              title: Text("Send feedback"),
              onTap: () {
                sendEmailFeedback();
              },
            ),
            ListTile(
                title: Text('Rate the App'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  _rateApp();
                }),
          ],
        ),
      ),
      floatingActionButton: CreateTimerButton(onChanged: _handleChange),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _createTimerGridView(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.25,
          crossAxisCount: 2,
        ),
        itemCount: timers.length,
        itemBuilder: (BuildContext context, int index) {
          return TimerWidget(
              id: timers[index].id,
              name: timers[index].name,
              time: timers[index].time,
              onChanged: _handleChange);
        });
  }

  void _updateGridView() {
    db.getAllTimers().then((value) {
      setState(() {
        timers = value;
      });
    });
  }

  void _handleChange(bool value) {
    if (value) {
      _updateGridView();
    }
  }

  void sendEmailFeedback() async {
    final Email email = Email(
      subject: 'Feedback Multi Timer App',
      recipients: ['multitimerapp@gmail.com'],
      isHTML: false,
    );
    MyApp.analytics.logEvent(name: "Send email");
    await FlutterEmailSender.send(email);
  }

  void _rateApp() {
    widget.inAppReview.openStoreListing(appStoreId: APPSTORE_ID_IOS);
    MyApp.analytics.logEvent(name: "Rate app");
  }
}
