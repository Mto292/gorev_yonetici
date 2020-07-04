import 'package:flutter/cupertino.dart';
import 'package:gorevyonetici/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:gorevyonetici/yardimci_widgetlar/label.dart';
import 'package:gorevyonetici/screen/ana_sayfa.dart';
import 'package:gorevyonetici/utiliti/database_helper.dart';
import 'package:gorevyonetici/utiliti/utils.dart';
import 'package:gorevyonetici/yardimci_widgetlar/textfield.dart';
import '../yardimci_widgetlar/label.dart';
import '../models/task.dart';

class YeniGorev extends StatefulWidget {
  Task task;
  AnaSayfaState anaSayfa;

  YeniGorev(this.task, this.anaSayfa);

  @override
  YeniGorevState createState() => YeniGorevState(this.task, this.anaSayfa);
}

class YeniGorevState extends State<YeniGorev> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //Text Field kontrollunu başlatık
  TextEditingController taskController = new TextEditingController();

  //sqfl için nesne türetik
  DatabaseHelper databaseHelper = DatabaseHelper();

  //Utils için nesne türetik
  Utils utils = Utils();

  //Task Modulu başlatık
  Task task = Task("", "", "");
  AnaSayfaState anaSayfa;

  FocusNode taskFocus = FocusNode();

  YeniGorevState(this.task, this.anaSayfa);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Gelen taskı textfielde atıyoruz
    taskController.text = task.task;
  }

  @override
  Widget build(BuildContext context) {
    //sqfl başlatıyoruz
    DatabaseHelper().initializeDatabase();
    //responsive için ekran boyutunu alıyoruz
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Label(
          text: "Yeni Görev",
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //task TextField
            taskTextField(),
            //Tarih satırı
            tarih(),
            //Saat satırı
            saat(),
            //Kaydet butonu
            buton(),
          ],
        ),
      ),
    );
  }

  void kayitIslemleri() async {
    int result;
    //Durumlara göre SnackBar gösteriyoruz ve kayıt edip geri dönüyoruz
    if (taskController.text.trim().isEmpty) {
      utils.showSnackBar(scaffoldKey, 'Lütfen Not Giriniz');
    } else if (task.date.isEmpty) {
      utils.showSnackBar(scaffoldKey, 'Lütfen Tarih Seçiniz');
    } else if (task.time.isEmpty) {
      utils.showSnackBar(scaffoldKey, 'Lütfen Saat Seçiniz');
    } else {
      task.task = taskController.text.trim();
      if (task.id != null) {
        result = await databaseHelper.updateTask(task);
      } else {
        result = await databaseHelper.insertTask(task);
      }
      if (result != 0) {
        anaSayfa.getData();
        Navigator.pop(context);
      } else {
        utils.showAlertDialog(context, 'Hata', 'Lütfen tekrar deneyiniz');
      }
    }
  }

  //region Widgetler
  Widget saat() {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.05),
        height: SizeConfig.screenHeight * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Label(
              text: "Saat",
            ),
            Label(
              text: task.time.toString(),
              color: Colors.teal,
              size: SizeConfig.safeBlockHorizontal * 5,
            ),
            Icon(
              Icons.access_time,
              size: SizeConfig.safeBlockHorizontal * 10,
            ),
          ],
        ),
      ),
      onTap: () async {
        //textField tan focuslamayı kaldırıyoruz
        taskFocus.unfocus();
        //Saat popunu acmak için oluşturuldu
        var pickedTime = await utils.selectTime(context);
        if (pickedTime != null && pickedTime.isNotEmpty)
          setState(() {
            //seçilen saat gözükmesi için tekrar build ediyoruz
            task.time = pickedTime.toString();
          });
      },
    );
  }

  Widget tarih() {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.05),
        height: SizeConfig.screenHeight * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Label(
              text: "Tarih",
            ),
            Label(
              text: task.date.toString(),
              color: Colors.teal,
              size: SizeConfig.safeBlockHorizontal * 5,
            ),
            Icon(
              Icons.date_range,
              size: SizeConfig.safeBlockHorizontal * 10,
            ),
          ],
        ),
      ),
      onTap: () async {
        //textField tan focuslamayı kaldırıyoruz
        taskFocus.unfocus();
        //Tarih popunu acmak için oluşturuldu
        var pickedDate = await utils.selectDate(context, task.date);
        //seçilen Tarih gözükmesi için tekrar build ediyoruz
        if (pickedDate != null && pickedDate.isNotEmpty)
          setState(() {
            task.date = pickedDate.toString();
          });
      },
    );
  }

  Widget buton() {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenWidth * 0.05,
          vertical: SizeConfig.screenWidth * 0.05),
      height: SizeConfig.screenHeight * 0.08,
      width: SizeConfig.screenWidth,
      child: RaisedButton(
        onPressed: kayitIslemleri,
        child: Label(
          text: "Kayıt et",
          color: Colors.white,
        ),
      ),
    );
  }

  //task TextField
  Widget taskTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenWidth * 0.05,
          vertical: SizeConfig.screenHeight * 0.05),
      child: MyTextField(
        maxLength: 250,
        focusNode: taskFocus,
        controller: taskController,
        autofocus: false,
        suffixIcon: Icon(
          Icons.add_comment,
          color: Colors.black,
        ),
      ),
    );
  }


//endregion

}
