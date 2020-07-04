class Task {
  int _id;
  String _task, _date, _time;

  Task(this._task, this._date, this._time);

  Task.withId(this._id, this._task, this._date, this._time);

  int get id => _id;

  String get task => _task;

  String get date => _date;

  String get time => _time;

  set task(String newTask) {
    if (newTask.length <= 255) {
      this._task = newTask;
    }
  }

  set date(String newDate) => this._date = newDate;

  set time(String newTime) => this._time = newTime;

  //task listesinden map'a çevirmekte
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = _id;
    map['task'] = _task;
    map['date'] = _date;
    map['time'] = _time;
    return map;
  }

  //Map'tan cevirip task listesini elde ederiz
  Task.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._task = map['task'];
    this._date = map['date'];
    this._time = map['time'];
  }
}
