// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'dart:convert';

List<HistoryModel> historyModelFromJson(String str) => List<HistoryModel>.from(json.decode(str).map((x) => HistoryModel.fromJson(x)));

String historyModelToJson(List<HistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


List<HistoryModel> historyModelFromMap(String str) => List<HistoryModel>.from(json.decode(str).map((x) => HistoryModel.fromMap(x)));

String historyModelToMap(List<HistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class HistoryModel {
  HistoryModel({
    this.countryCode,
    this.createdDate,
    this.id,
    this.message,
    this.name,
    this.phoneNumber,
    this.type,
  });

  String? countryCode;
  String? createdDate;
  int? id;
  String? message;
  String? name;
  String?phoneNumber;
  String? type;

  factory HistoryModel.fromMap(Map<String, dynamic> json) => HistoryModel(
    countryCode: json["country_code"],
    createdDate: json["created_date"],
    id: json["id"],
    message: json["message"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    type: json["type"],
  );

  Map<String, dynamic> toMap() => {
    "country_code": countryCode,
    "created_date": createdDate,
    "id": id,
    "message": message,
    "name": name,
    "phone_number": phoneNumber,
    "type": type,
  };

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
    countryCode: json["country_code"],
    createdDate: json["created_date"],
    id: json["id"],
    message: json["message"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "country_code": countryCode,
    "created_date": createdDate,
    "id": id,
    "message": message,
    "name": name,
    "phone_number": phoneNumber,
    "type": type,
  };
}
