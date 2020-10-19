import 'package:flutter/material.dart';
import 'package:multi_timer/create-timer.dart';

class CreateTimerButton extends StatelessWidget {

  final ValueChanged<bool> onChanged;

  CreateTimerButton({Key key, @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          _navigateAndDisplaySelection(context);
        },
        child: Icon(Icons.add),
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateTimer(name: null, time:0),
      settings: RouteSettings(name: 'Create Timer'),
    ),
    );
    if(result!= null){
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("$result")));
        onChanged(true);
    }
    onChanged(false);
  }

}
