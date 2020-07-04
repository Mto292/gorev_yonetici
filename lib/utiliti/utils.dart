import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static Utils _utils;

  Utils._createInstance();

  factory Utils() {
    if (_utils == null) {
      _utils = Utils._createInstance();
    }
    return _utils;
  }

  // ekranda gösterilen dialog için oluşturuldu
  void showAlertDialog(BuildContext context, String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  //Ekranın alt kısmında gösterilen barr
  void showSnackBar(var scaffoldkey, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1, milliseconds: 500),
    );
    scaffoldkey.currentState.showSnackBar(snackBar);
  }

  //task ekleme ekranında tarih için oluşturuldu
  Future<String> selectDate(BuildContext context, String date) async {
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: date.isEmpty
            ? DateTime.now()
            : new DateFormat("d MMM, y").parse(date),
        lastDate: DateTime(2021));
    if (picked != null) return formatDate(picked);

    return "";
  }

  //task ekleme ekranında Saat için oluşturuldu
  Future<String> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (picked != null) {
      return timeFormat(picked);
    }
    return "";
  }

  //saatin formatını düzenliyoruz
  String timeFormat(TimeOfDay picked) {
    //saatin formatını 24 saatten 12 saatte çeviriyoruz
    var hour = picked.replacing(hour: picked.hourOfPeriod);
    var time = "PM";
    if (picked.hour >= 12) {
      time = "PM";
    } else {
      time = "AM";
    }
    var h = hour.hour.toString();
    if (hour.hour.toString().length == 1) {
      h = "0" + h;
    }
    var m = hour.minute.toString();
    if (hour.minute.toString().length == 1) {
      m = "0" + m;
    }

    return h + ":" + m + " " + time;
  }

  String formatDate(DateTime selectedDate) =>
      new DateFormat("d MMM, y").format(selectedDate);
}
