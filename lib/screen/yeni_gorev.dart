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
  TextEditingController titleController = new TextEditingController();

  //sqfl için nesne türetik
  DatabaseHelper databaseHelper = DatabaseHelper();

  //Utils için nesne türetik
  Utils utils = Utils();

  //Task Modulu başlatık
  Task task = Task("", "", "", "", 0, "");
  AnaSayfaState anaSayfa;

  FocusNode taskFocus = FocusNode();
  FocusNode titleFocus = FocusNode();

  //onecelik Radio için oluştruldu
  int radioDeger = 3;

  YeniGorevState(this.task, this.anaSayfa);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Gelen taskı degerlerini atıyoruz
    titleController.text = task.title;
    taskController.text = task.task;
    radioDeger = task.oncelik;
    task.date = utils.formatDate(DateTime.now());
    task.time = DateTime.now().toString().toString().substring(11, 16) +
        " " +
        TimeOfDay.now().period.toString().substring(10).toUpperCase();
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
        title: Label(
          text: "Yeni Görev",
          color: Colors.white,
        ),
        actions: <Widget>[
          InkWell(
            child: Container(
              width: SizeConfig.screenWidth * 0.16,
              child: Icon(Icons.check),
            ),
            onTap: kayitIslemleri,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(SizeConfig.screenWidth * 0.03),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 0.5,
                      color: Colors.black12,
                      offset: Offset(0, 0),
                    )
                  ]),
              child: Column(
                children: <Widget>[
                  //title TextField
                  titleTextField(),
                  //task TextField
                  taskTextField(),
                  //dropdown
                  oncelikCeckbox(),
                  //Tarih satırı
                  tarih(),
                  //Saat satırı
                  saat(),
                ],
              ),
            ),
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
    if (titleController.text.trim().isEmpty) {
      utils.showSnackBar(scaffoldKey, 'Lütfen Başlık Giriniz');
    } else if (taskController.text.trim().isEmpty) {
      utils.showSnackBar(scaffoldKey, 'Lütfen Not Giriniz');
    } else if (task.date.isEmpty) {
      utils.showSnackBar(scaffoldKey, 'Lütfen Tarih Seçiniz');
    } else if (task.time.isEmpty) {
      utils.showSnackBar(scaffoldKey, 'Lütfen Saat Seçiniz');
    } else {
      task.title = titleController.text.trim();
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

  //title TextField
  Widget titleTextField() {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.screenWidth * 0.05,
        right: SizeConfig.screenWidth * 0.05,
        top: SizeConfig.screenHeight * 0.05,
        bottom: SizeConfig.screenHeight * 0.02,
      ),
      child: MyTextField(
        maxLines: 1,
        maxLength: 30,
        focusNode: titleFocus,
        controller: titleController,
        autofocus: false,
        filled: true,
        textInputAction: TextInputAction.next,
        onSubmitted: (next) => taskFocus.requestFocus(),
        fillColor: Colors.teal.shade50,
        border: UnderlineInputBorder(
          borderSide: BorderSide(width: SizeConfig.screenWidth * 0.001),
        ),
        suffixIcon: Icon(
          Icons.title,
          color: Colors.black,
        ),
      ),
    );
  }

  //task TextField
  Widget taskTextField() {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.screenWidth * 0.05,
          right: SizeConfig.screenWidth * 0.05,
          bottom: SizeConfig.screenHeight * 0.03),
      child: MyTextField(
        maxLength: 250,
        maxLines: 3,
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

  //Radio Öncelik işlemi için oluşturuldu
  Widget oncelikCeckbox() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.05),
      height: SizeConfig.screenHeight * 0.07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Label(
            text: "Öcelik",
          ),
          //Radio öcelik sonda
          Row(
            children: <Widget>[
              Radio(
                value: 3,
                activeColor: Colors.blue,
                focusColor: Colors.blue,
                hoverColor: Colors.blue,
                groupValue: radioDeger,
                //radio secildiğinde yapılan işlem
                onChanged: (deger) {
                  radioDeger = deger;
                  setState(() {
                    task.oncelik = deger;
                  });
                },
              ),
              //Radio öcelik ortada
              Radio(
                value: 2,
                activeColor: Colors.yellow,
                focusColor: Colors.yellow,
                hoverColor: Colors.yellow,
                groupValue: radioDeger,
                //radio secildiğinde yapılan işlem
                onChanged: (deger) {
                  radioDeger = deger;
                  setState(() {
                    task.oncelik = deger;
                  });
                },
              ),
              //Radio öcelik başta
              Radio(
                value: 1,
                activeColor: Colors.red,
                focusColor: Colors.red,
                hoverColor: Colors.red,
                groupValue: radioDeger,
                //radio secildiğinde yapılan işlem
                onChanged: (deger) {
                  radioDeger = deger;
                  setState(() {
                    task.oncelik = deger;
                  });
                },
              ),
              //Seçilen radionun degerini Gösteren Text
              Container(
                  width: SizeConfig.screenWidth * 0.08,
                  child: Label(
                    text:
                        radioDeger == 3 ? "I" : radioDeger == 2 ? "II" : "III",
                  ))
            ],
          ),
        ],
      ),
    );
  }

  //tarih için oluşturuldu
  Widget tarih() {
    return InkWell(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.05),
        height: SizeConfig.screenHeight * 0.07,
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
              size: SizeConfig.safeBlockHorizontal * 7,
            ),
          ],
        ),
      ),
      onTap: () async {
        //textField tan focuslamayı kaldırıyoruz
        FocusScope.of(context).unfocus();
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

  //saat için oluşturuldu
  Widget saat() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(
          right: SizeConfig.screenWidth * 0.05,
          left: SizeConfig.screenWidth * 0.05,
          bottom: SizeConfig.screenHeight * 0.05,
        ),
        height: SizeConfig.screenHeight * 0.07,
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
              size: SizeConfig.safeBlockHorizontal * 7,
            ),
          ],
        ),
      ),
      onTap: () async {
        //textField tan focuslamayı kaldırıyoruz
        FocusScope.of(context).unfocus();
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

  //buton için oluşturuldu
  Widget buton() {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenWidth * 0.05,
          vertical: SizeConfig.screenWidth * 0.05),
      height: SizeConfig.screenHeight * 0.08,
      width: SizeConfig.screenWidth,
      child: RaisedButton(
        elevation: 2,
        onPressed: kayitIslemleri,
        child: Label(
          text: "Kayıt et",
          color: Colors.white,
        ),
      ),
    );
  }

//endregion

}
