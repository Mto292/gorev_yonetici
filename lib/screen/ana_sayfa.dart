import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gorevyonetici/responsive/responsive.dart';
import 'package:gorevyonetici/utiliti/database_helper.dart';
import 'package:gorevyonetici/screen/yeni_gorev.dart';
import 'package:gorevyonetici/models/task.dart';
import 'package:gorevyonetici/yardimci_widgetlar/label.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class AnaSayfa extends StatefulWidget {
  @override
  AnaSayfaState createState() => AnaSayfaState();
}

class AnaSayfaState extends State<AnaSayfa> with TickerProviderStateMixin{
  //sqfl için nesne türetik
  DatabaseHelper databaseHelper = DatabaseHelper();
  AnimationController animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final AppBarController appBarController = AppBarController();

  //task listesi için liste oluşturduk
  List<Task> taskList;

  //arama listesi için liste oluşturduk
  List<Task> searchList;

  //Dismissible sağa kaydırma yapısı için oluşturuldu
  int count = 0;

  var searchMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 100),upperBound: 3.5,
    lowerBound: 0);
    animationController.addListener(() {
      debugPrint(animationController.value.toString());
      setState(() {});
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    //responsive için ekran boyutunu alıyoruz
    SizeConfig().init(context);
    //liste boş ise sqfl ten tabloları getirip dolduracsk
    if (taskList == null) {
      //sqfl başlatıyoruz
      databaseHelper.initializeDatabase();
      //Listeleri başlatık
      taskList = List<Task>();
      searchList = List<Task>();
      getData();
    }
    return Scaffold(
        key: _scaffoldKey,
        appBar: appBar(),
        //yeni task ekranına gitme butonu Alt sağda gösterilir
        floatingActionButton: floatingActionButton(),
        body: searchMode == false
            ? FutureBuilder(
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
                    //gelen veriyi boş değil ise gösterilen ekran
                    return taskCart(taskList);
                  } else {
                    return mesajGoster("Hata");
                  }
                },
              )
            : taskCart(searchList));
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
        radius: SizeConfig.safeBlockVertical * animationController.value,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: Icon(Icons.add,size: SizeConfig.safeBlockVertical * 0.8 * animationController.value,),
      ),
      onTap: () {
        //tıklandığında gidilen ekran
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    YeniGorev(Task("", "", "", "", 3, ""), this)));
      },
    );
  }

  //taskları listelemek için oluşturuldu
  Widget taskCart(list) {
    return list.length != 0
        ? ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: list.length,
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
                            text: list[index].title + "\n" + list[index].task,
                            size: SizeConfig.safeBlockHorizontal * 4,
                          ),
                          subtitle: Label(
                            text: list[index].date + " " + list[index].time,
                            size: SizeConfig.safeBlockHorizontal * 4,
                            color: Colors.teal,
                          ),
                          trailing: Icon(
                            Icons.note,
                            color: list[index].oncelik == 1
                                ? Colors.red
                                : list[index].oncelik == 2
                                    ? Colors.amber
                                    : Colors.blue,
                          )),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  YeniGorev(list[index], this)));
                    },
                  ),
                  //kaydırma yapısının arka planı
                  background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding:
                          EdgeInsets.only(right: SizeConfig.screenWidth * 0.03),
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
          )
        :
        //gelen veriyi boş  ise gösterilen ekran
    list.length == 0
            ? Center(
      child: Icon(Icons.speaker_notes_off,
      color: Colors.black12,
      size: SizeConfig.safeBlockHorizontal * 15,),
    ): mesajGoster("Lütfen Tekrar Deneyiniz");
  }

  //hata olduğu zaman ekrana gösterilecek
  Widget mesajGoster(mesaj) {
    return Center(
      child: Label(text: mesaj, size: SizeConfig.safeBlockHorizontal * 5),
    );
  }

  //appbar ve arama için oluşturuldu
  Widget appBar() {
    return SearchAppBar(
      //appbara primeri color rengini verdik
      primary: Theme.of(context).primaryColor,
      appBarController: appBarController,
      autoSelected: false,
      searchHint: "Ara",
      mainTextColor: Colors.white,
      onChange: (String value) {
        //her gitişte bi önceki listey siliyoruz
        searchList.clear();
        //listenin uzunulugu kadar döndürüuoruz
        taskList.forEach((element) {
          //Girilen değer listede var ise arama listesine atıyoryz
          if (element.title.toUpperCase().startsWith(value.toUpperCase())) {
            searchList.add(element);
          }
        });
        //arama modunu kontrol ediyoruz
        if (value == "") {
          searchMode = false;
          searchList.clear();
        } else {
          searchMode = true;       //tekrar build ediyoruz
          setState(() {});
        }

      },
      //Ana app bar
      mainAppBar: AppBar(
        title: Label(
          text: "Görevlerim",
          color: Colors.white,
        ),
        actions: <Widget>[
          InkWell(
            child: Container(
              width: SizeConfig.screenWidth * 0.16,
              child: Icon(Icons.search),
            ),
            onTap: () {
              //arama modunu aktif ediyoruz
              appBarController.stream.add(true);
            },
          ),
        ],
      ),
    );
  }
//endregion
}
