import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:gorevyonetici/models/task.dart';

// Database sınıfı
class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton DatabaseHelper
  static Database _database; //Singleton Database

  String taskTable = "task_table";
  String colId = "id";
  String colTask = "task";
  String colDate = "date";
  String colTime = "time";

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
// Veritabanını depolamak için hem Android hem de iOS için dizin yolunu getiriyor.
    Directory directory = await getApplicationDocumentsDirectory();
    print("dosya yolu getirildi");
    String path = directory.path + "task.db";
    print(path);
// Veritabanında belirtilen dizini ac yok ise oluştur
    var taskDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return taskDatabase;
  }

  //tablo oluşturma sorgusu
  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $taskTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTask TEXT, $colDate TEXT, $colTime TEXT)');
    print("Tablo oluşturuldu");
  }

// Alma İşlemi: Tüm Görev nesnelerini veritabanından alma
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.database;
    var result = db.query(taskTable, orderBy: '$colId, $colDate, $colTime');
    return result;
  }

// Ekle İşlemi: Veritabanına bir Görev nesnesi ekle
  Future<int> insertTask(Task task) async {
    Database db = await this.database;
    var result = await db.insert(taskTable, task.toMap());
    print("Task kayıt edildi");
    print("task: " + task.task.toString());
    return result;
  }

  //taskı güncellemek için oluşturuldu
  Future<int> updateTask(Task task) async {
    var db = await this.database;
    //Sqfl Sorgusu
    var result = await db.update(taskTable, task.toMap(), where: '$colId = ?', whereArgs: [task.id] );
    return result;
  }

// Silme İşlemi: Bir Görev nesnesini veritabanından silme
  Future<int> deleteTask(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $taskTable WHERE $colId=$id');
    print(id.toString() + "id'li Silindi");
    return result;
  }

  //tüm listeyi almak için oluşturuldu
  Future<List<Task>> getTaskList() async {
    var taskMapList = await getTaskMapList();
    int count = taskMapList.length;

    List<Task> taskList = List<Task>();
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }
    return taskList;
  }
}
