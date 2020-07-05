import 'dart:ffi';

class Task {
  int _id,_oncelik;
  String _task, _title, _date, _time, _tur;

  Task(this._task, this._title, this._date, this._time,this._oncelik, this._tur);

  Task.withId(
      this._id, this._title, this._task, this._date, this._time,this._oncelik, this._tur);

  int get id => _id;

  String get task => _task;

  String get title => _title;

  String get date => _date;

  String get time => _time;

  int get oncelik => _oncelik;

  String get tur => _tur;


  set task(String newTask) {
    if (newTask.length <= 255) {
      this._task = newTask;
    }
  }

  set title(String newDate) => this._title = newDate;

  set date(String newDate) => this._date = newDate;

  set time(String newTime) => this._time = newTime;

  set oncelik(int newDate) => this._oncelik = newDate;

  set tur(String newDate) => this._tur = newDate;

  //task listesinden map'a çevirmekte
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = _id;
    map['task'] = _task;
    map['title'] = _title;
    map['date'] = _date;
    map['time'] = _time;
    map['oncelik'] = _oncelik;
    map['tur'] = _tur;

    return map;
  }

  //Map'tan cevirip task listesini elde ederiz
  Task.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._task = map['task'];
    this._title = map['title'];
    this._date = map['date'];
    this._time = map['time'];
    this._oncelik = map['oncelik'];
    this._tur = map['tur'];

  }
}
