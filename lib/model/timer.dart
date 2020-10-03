class MyTimer {
  final int id;
  final String name;
  final int time;

  MyTimer({this.id, this.name, this.time});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
    };
  }



// Implement toString to make it easier to see information about
// each dog when using the print statement.
  @override
  String toString() {
    return 'MyTimer{id: $id, name: $name, time: $time}';
  }
}
