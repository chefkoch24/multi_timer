import 'package:multi_timer/main.dart';

int hourMinSecToInt(int hour, int min, int sec){
  return hour*60*60+min*60+sec;
}

int intToHour(int time){
  // 60*60s
  return time~/3600;
}

int intToMin(int time){
  /*
  7373%3600 =  173
  173 ~/ 60 = 2
   */
  int sec = time%3600;
  return sec~/60;
}

int intToSec(int time){
  int sec = time%3600;
  return sec%60;
}

String timeToStringHMS(time){
  int h = intToHour(time);
  int m = intToMin(time);
  int s = intToSec(time);
  String hour;
  String min;
  String sec;
  // hour
  if(h<10)
    hour = '0$h';
  else
    hour = '$h';
  // min
  if(m<10)
    min = '0$m';
  else
    min = '$m';
  // sec
  if(s<10)
    sec = '0$s';
  else
    sec = '$s';
  return '$hour:$min:$sec';

}

Future<void> logScreen({required String screenName, required String screenClass}) async {
  await MyApp.analytics.setCurrentScreen(screenName: screenName, screenClassOverride: screenClass);
}
Future<void> logEvent(String eventName, parameters) async {
  print(eventName+ parameters.toString());
  await MyApp.analytics.logEvent(name: eventName, parameters: parameters);
}
