import 'package:crypto_currency/src/domain/entity/crypto_currency.dart';
import 'package:crypto_currency/src/domain/entity/crypto_currency_rate.dart';
import 'package:crypto_currency/src/ui/models/alarm_info.dart';
import 'package:crypto_currency/src/ui/models/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';


const String tableAlarm = 'alarm';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnCryptoPrice = 'price';
const String columnLimit = 'limitprice';

const String tableFavouriteList = 'favouritelist';
const String columnPrice = 'cryptoprice';
const String columnName = 'name';
const String columnSymbol = 'symbol';

class CryptoHelper {
  static Database _database;
  static CryptoHelper _alarmHelper;

  CryptoHelper._createInstance();

  factory CryptoHelper() {
    _alarmHelper ??= CryptoHelper._createInstance();
    return _alarmHelper;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }


  Future<Database> initializeDatabase() async {
    final dir = await getDatabasesPath();
    final path = "${dir}alarm.db";

    final database = await openDatabase(
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
    final db = await this.database;
    final result = await db.insert(tableAlarm, alarmInfo.toMap());
    print('result : $result');
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> _alarms = [];

   final db = await this.database;
   final result = await db.query(tableAlarm);
    result.forEach((element) {
      var alarmInfo = AlarmInfo.fromMap(element);
      _alarms.add(alarmInfo);
    });

    return _alarms;
  }

  void insertFavouriteList(CryptoCurrencyRate crypto) async {
    final db = await database;
    final result = await db.insert(tableFavouriteList, crypto.toMap());
  }

  Future<List<CryptoCurrencyRate>> getCryptoFavouriteLists() async {
    final List<CryptoCurrencyRate> _favouriteLists = [];

   final db = await database;
   final result = await db.query(tableFavouriteList);
    result.forEach((element)  {
      final crypto = CryptoCurrencyRate.fromMap(element);
        _favouriteLists.add(crypto);
    });


    return _favouriteLists;
  }

  Future delete(int id) async {
    var db = await this.database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }

  Future deleteFav(int id) async {
    print("deleteeeed");
    var db = await this.database;
    return await db.delete(tableFavouriteList, where: '$columnId = ?', whereArgs: [id]);
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
