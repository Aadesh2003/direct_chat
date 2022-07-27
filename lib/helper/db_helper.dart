// ignore_for_file: constant_identifier_names, avoid_print, unused_local_variable

import 'dart:io';

import 'package:direct_chat/model/history_model.dart';
import 'package:direct_chat/model/notification_data_model.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static const DBName = 'db.db';
  static const DBVersion = 1;

  DB._privateConstructor();
  static final DB instance = DB._privateConstructor();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, DBName);

    if (!(await databaseExists(path))) {

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        // print(e);
      }

      ByteData data = await rootBundle.load(join("assets/database", DBName));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
    }
    return await openDatabase(path, version: DBVersion);
  }

  Future<List<HistoryModel>?> getAll() async {
    Database db = await instance.database;
    var result = await db.rawQuery(
        'SELECT * FROM historyTable');
    return result.map((e) => HistoryModel.fromMap(e)).toList();
  }
  Future<List<NotificationDataModel>?> getAllNotificationData() async {
    Database db = await instance.database;
    var result = await db.rawQuery(
        'SELECT * FROM notificationTable');
    return result.map((e) => NotificationDataModel.fromMap(e)).toList();
  }

  Future<void> insertInHistory(HistoryModel value) async {
    // INSERT INTO historyTable (countryCode, name, number, message, textORwa)
    // VALUES ('aadi', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', 'Norway');
    Database db = await instance.database;
    var result = await db.rawInsert(
        'INSERT INTO historyTable (name, phone_number, message, type,country_code,created_date)  VALUES(?, ?, ?, ?, ?, ?)', [value.name.toString(), value.phoneNumber.toString(), value.message.toString(), value.type.toString(),value.countryCode.toString(),value.createdDate.toString()]);
  }
  Future<void> insertInNotification(NotificationDataModel value) async {
    // INSERT INTO historyTable (countryCode, name, number, message, textORwa)
    // VALUES ('aadi', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', 'Norway');
    Database db = await instance.database;
    var result = await db.rawInsert(
        'INSERT INTO notificationTable (country_code, message, name,notification_id,number,repeat_day,type,time,title,date,created_time)  VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [value.countryCode.toString(), value.message.toString(), value.name.toString(), value.notificationId.toString(),value.number.toString(),value.repeatDay.toString(),value.type.toString(),value.time.toString(),value.title.toString(),value.date.toString(),value.createdTime.toString()]);
  }

  Future<void> deleteSingleFromNotification(id) async {
    Database db = await instance.database;
    var result = await db.rawDelete(
        // 'INSERT INTO historyTable (name, number, message, textORwa)  VALUES(?, ?, ?, ?)', [value.name.toString(), value.number.toString(), value.message.toString(), value.textORwa.toString()]
      'DELETE FROM notificationTable WHERE id=$id'
    );
  }Future<void> deleteSingle(id) async {
    Database db = await instance.database;
    var result = await db.rawDelete(
        // 'INSERT INTO historyTable (name, number, message, textORwa)  VALUES(?, ?, ?, ?)', [value.name.toString(), value.number.toString(), value.message.toString(), value.textORwa.toString()]
      'DELETE FROM historyTable WHERE id=$id'
    );
  }

}