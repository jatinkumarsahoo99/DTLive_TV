// To parse this JSON data, do
// final subscriptionModel = subscriptionModelFromJson(jsonString);

import 'dart:convert';

SubscriptionModel subscriptionModelFromJson(String str) =>
    SubscriptionModel.fromJson(json.decode(str));

String subscriptionModelToJson(SubscriptionModel data) =>
    json.encode(data.toJson());

class SubscriptionModel {
  SubscriptionModel({
    this.code,
    this.status,
    this.message,
    this.result,
  });

  int? code;
  int? status;
  String? message;
  List<Result>? result;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  Result({
    this.id,
    this.name,
    this.price,
    this.time,
    this.type,
    this.typeId,
    this.data,
    this.isBuy,
  });

  int? id;
  String? name;
  int? price;
  String? time;
  String? type;
  String? typeId;
  List<Datum>? data;
  int? isBuy;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        time: json["time"],
        type: json["type"],
        typeId: json["type_id"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        isBuy: json["is_buy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "time": time,
        "type": type,
        "type_id": typeId,
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
        "is_buy": isBuy,
      };
}

class Datum {
  Datum({
    this.id,
    this.packageId,
    this.packageKey,
    this.packageValue,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? packageId;
  String? packageKey;
  String? packageValue;
  String? createdAt;
  String? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        packageId: json["package_id"],
        packageKey: json["package_key"],
        packageValue: json["package_value"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_id": packageId,
        "package_key": packageKey,
        "package_value": packageValue,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
