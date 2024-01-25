// To parse this JSON data, do
// final tvCodeModel = tvCodeModelFromJson(jsonString);

import 'dart:convert';

TvCodeModel tvCodeModelFromJson(String str) =>
    TvCodeModel.fromJson(json.decode(str));

String tvCodeModelToJson(TvCodeModel data) => json.encode(data.toJson());

class TvCodeModel {
  int? status;
  String? message;
  List<Result>? result;

  TvCodeModel({
    this.status,
    this.message,
    this.result,
  });

  factory TvCodeModel.fromJson(Map<String, dynamic> json) => TvCodeModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  String? uniqueCode;
  String? deviceToken;
  int? status;
  int? userId;
  String? updatedAt;
  String? createdAt;
  int? id;

  Result({
    this.uniqueCode,
    this.deviceToken,
    this.status,
    this.userId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        uniqueCode: json["unique_code"],
        deviceToken: json["device_token"],
        status: json["status"],
        userId: json["user_id"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "unique_code": uniqueCode,
        "device_token": deviceToken,
        "status": status,
        "user_id": userId,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "id": id,
      };
}
