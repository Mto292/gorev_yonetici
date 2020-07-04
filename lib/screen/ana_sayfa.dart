import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gorevyonetici/responsive/responsive.dart';
import 'package:gorevyonetici/utiliti/database_helper.dart';
import 'package:gorevyonetici/screen/yeni_gorev.dart';
import 'package:gorevyonetici/models/task.dart';
import 'package:gorevyonetici/yardimci_widgetlar/label.dart';

class AnaSayfa extends StatefulWidget {
  @override
  AnaSayfaState createState() => AnaSayfaState();
}

class AnaSayfaState extends State<AnaSayfa> {
  //sqfl için nesne türetik
  DatabaseHelper databaseHelper = DatabaseHelper();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //task listesi için liste oluşturduk
  List<Task> taskList;

  //Dismissible sağa kaydırma yapısı için oluşturuldu
  int count = 0;

  @override
  Widget build(BuildContext context) {
    //sqfl başlatıyoruz
    databaseHelper.initializeDatabase();
    //responsive için ekran boyutunu alıyoruz
    SizeConfig().init(context);
    //liste boş ise sqfl ten tabloları getirip dolduracsk
    if (taskList == null) {
      taskList = List<Task>();
      getData();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Label(
          text: "Görevlerim",
          color: Colors.white,
        ),
      ),
      //yeni task ekranına gitme butonu Alt sağda gösterilir
      floatingActionButton: floatingActionButton(),
      body: FutureBuilder(
        future: databaseHelper.getTaskList(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //veri beklemede ise gösterilen yülkenme ekranı
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              !snapshot.hasError) {
            // veri geldi ise
            //gelen veriyi taskliste atıyoruz
            taskList = snapshot.data;
            if (taskList.length != 0) {
              //gelen veriyi boş değil ise gösterilen ekran
              return taskCart();
            } else {
              //gelen veriyi boş  ise gösterilen ekran
              return gorevYok();
            }
          } else {
            return hata();
          }
        },
      ),
    );
  }

//sqfl den tabloyu getirmek için oluşturuldu
  void getData() async {
    //databaseHelper başlatık
    await databaseHelper.initializeDatabase();
    //gelen veriyi listeye atıyoruz
    List<Task> list = await databaseHelper.getTaskList();
    //veri geldikten sonra ekranı tekrar build ediyoruz
    setState(() {
      taskList = list;
    });
  }

  //region Widgetlar

  //yeni task ekranına gitme butonu Alt sağda gösterilir
  Widget floatingActionButton() {
    return GestureDetector(
      child: CircleAvatar(
        radius: SizeConfig.safeBlockVertical * 3.5,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      onTap: () {
        //tıklandığında gidilen ekran
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => YeniGorev(Task("", "", ""),this)));
      },
    );
  }

  //taskları listelemek için oluşturuldu
  Widget taskCart() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: taskList.length,
      itemBuilder: (BuildContext context, index) {
        count++;
        //kaydırma yapısı
        return Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.screenHeight * 0.01,
              left: SizeConfig.screenWidth * 0.01,
              right: SizeConfig.screenWidth * 0.01),
          child: Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(count.toString()),
            //listenin kartı
            child: GestureDetector(
              child: Card(
                //listeye gölgelik veriyoruz
                elevation: 4,
                child: ListTile(
                  title: Label(
                    text: taskList[index].task,
                    size: SizeConfig.safeBlockHorizontal * 4,
                  ),
                  subtitle: Label(
                    text: taskList[index].date + " " + taskList[index].time,
                    size: SizeConfig.safeBlockHorizontal * 4,
                    color: Colors.teal,
                  ),
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> YeniGorev(taskList[index],this)));
              },
            ),
            //kaydırma yapısının arka planı
            background: Container(
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.only(right: SizeConfig.screenWidth * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: SizeConfig.safeBlockHorizontal * 8,
                    ),
                    Label(
                      text: "Sil",
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            //kaydırma eğlemi
            onDismissed: (delete) async {
              //kaydrırıldığı zaman taskı siliyoru
              await databaseHelper.deleteTask(taskList[index].id);
              setState(() {});
            },
          ),
        );
      },
    );
  }

  //task olmadığı zaman ekrana gösterilecek
  Widget gorevYok() {
    return Center(
      child: Label(
        text: "Eklenmiş Görev Bulunmamaktadır",
        size: SizeConfig.safeBlockHorizontal * 5,
      ),
    );
  }

  //hata olduğu zaman ekrana gösterilecek
  Widget hata() {
    return Center(
      child: Label(text: "Hata", size: SizeConfig.safeBlockHorizontal * 5),
    );
  }

//endregion
}
