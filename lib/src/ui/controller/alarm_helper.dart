import 'package:crypto_currency/src/domain/entity/crypto_currency.dart';
import 'package:crypto_currency/src/domain/entity/crypto_currency_rate.dart';
import 'package:crypto_currency/src/ui/models/alarm_info.dart';
import 'package:crypto_currency/src/ui/models/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';


final String tableAlarm = 'alarm';
final String columnId = 'id';
final String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
final String columnCryptoPrice = 'price';
final String columnLimit = 'limitprice';

final String tableFavouriteList = 'favouritelist';
final String columnPrice = 'cryptoprice';
final String columnName = 'name';
final String columnSymbol = 'symbol';

class CryptoHelper {
  static Database _database;
  static CryptoHelper _alarmHelper;

  CryptoHelper._createInstance();

  factory CryptoHelper() {
    if (_alarmHelper == null) {
      _alarmHelper = CryptoHelper._createInstance();
    }
    return _alarmHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }


  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "alarm.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          create table $tableAlarm ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnName text not null,
          $columnCryptoPrice text not null,
          $columnLimit text not null)
        ''');
        await db.execute('''
          create table $tableFavouriteList ( 
          $columnId integer not null, 
          $columnName text not null,
          $columnSymbol text not null,
          $columnPrice double)
        ''');
      },
    );
    return database;
  }

  void insertAlarm(AlarmInfo alarmInfo) async {
    var db = await this.database;
    var result = await db.insert(tableAlarm, alarmInfo.toMap());
    print('result : $result');
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> _alarms = [];

    var db = await this.database;
    var result = await db.query(tableAlarm);
    result.forEach((element) {
      var alarmInfo = AlarmInfo.fromMap(element);
      _alarms.add(alarmInfo);
    });

    return _alarms;
  }

  void insertFavouriteList(CryptoCurrencyRate crypto) async {
    var db = await this.database;
    var result = await db.insert(tableFavouriteList, crypto.toMap());
    print('result : $result');
  }

  Future<List<CryptoCurrencyRate>> getCryptoFavouriteLists() async {
    List<CryptoCurrencyRate> _favouriteLists = [];

    var db = await this.database;
    var result = await db.query(tableFavouriteList);
    result.forEach((element) {
      var crypto = CryptoCurrencyRate.fromMap(element);
        _favouriteLists.add(crypto);
    });

    return _favouriteLists;
  }

  Future delete(int id) async {
    var db = await this.database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }

  Future deleteFav(int id) async {
    var db = await this.database;
    return await db
        .delete(tableFavouriteList, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<bool> isInclued(int id) async {
    var db = await this.database;
    var element = await db.rawQuery('''
          select from $tableFavouriteList where
          $columnId = id
        ''', [id]);
    if (element != null) return Future<bool>.value(true);
    return Future<bool>.value(false);
  }
}
