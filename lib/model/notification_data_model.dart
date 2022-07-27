// To parse this JSON data, do
//
//     final notificationDataModel = notificationDataModelFromMap(jsonString);

import 'dart:convert';

List<NotificationDataModel> notificationDataModelFromMap(String str) => List<NotificationDataModel>.from(json.decode(str).map((x) => NotificationDataModel.fromMap(x)));

String notificationDataModelToMap(List<NotificationDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));


List<NotificationDataModel> notificationDataModelFromJson(String str) => List<NotificationDataModel>.from(json.decode(str).map((x) => NotificationDataModel.fromJson(x)));

String notificationDataModelToJson(List<NotificationDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class NotificationDataModel {
  NotificationDataModel({
    this.countryCode,
    this.createdTime,
    this.date,
    this.id,
    this.message,
    this.name,
    this.notificationId,
    this.number,
    this.repeatDay,
    this.time,
    this.title,
    this.type,
  });

  String? countryCode;
  String? createdTime;
  String? date;
  int? id;
  String? message;
  String? name;
  String? notificationId;
  String? number;
  String? repeatDay;
  String? time;
  String? title;
  String? type;
  factory NotificationDataModel.fromJson(Map<String, dynamic> json) => NotificationDataModel(
    countryCode: json["country_code"],
    createdTime: json["created_time"],
    date: json["date"],
    id: json["id"],
    message: json["message"],
    name: json["name"],
    notificationId: json["notification_id"],
    number: json["number"],
    repeatDay: json["repeat_day"],
    time: json["time"],
    title: json["title"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "country_code": countryCode,
    "created_time": createdTime,
    "date": date,
    "id": id,
    "message": message,
    "name": name,
    "notification_id": notificationId,
    "number": number,
    "repeat_day": repeatDay,
    "time": time,
    "title": title,
    "type": type,
  };


factory NotificationDataModel.fromMap(Map<String, dynamic> json) => NotificationDataModel(
    countryCode: json["country_code"],
    createdTime: json["created_time"],
    date: json["date"],
    id: json["id"],
    message: json["message"],
    name: json["name"],
    notificationId: json["notification_id"],
    number: json["number"],
    repeatDay: json["repeat_day"],
    time: json["time"],
    title: json["title"],
    type: json["type"],
  );

  Map<String, dynamic> toMap() => {
    "country_code": countryCode,
    "created_time": createdTime,
    "date": date,
    "id": id,
    "message": message,
    "name": name,
    "notification_id": notificationId,
    "number": number,
    "repeat_day": repeatDay,
    "time": time,
    "title": title,
    "type": type,
  };
}
