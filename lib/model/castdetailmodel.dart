// To parse this JSON data, do
// final castDetailModel = castDetailModelFromJson(jsonString);

import 'dart:convert';

CastDetailModel castDetailModelFromJson(String str) =>
    CastDetailModel.fromJson(json.decode(str));

String castDetailModelToJson(CastDetailModel data) =>
    json.encode(data.toJson());

class CastDetailModel {
  CastDetailModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory CastDetailModel.fromJson(Map<String, dynamic> json) =>
      CastDetailModel(
        status: json["status"],
        message: json["message"],
        result: List<Result>.from(
            json["result"]?.map((x) => Result.fromJson(x)) ?? []),
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
  Result({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.personalInfo,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  String? name;
  String? image;
  String? type;
  String? personalInfo;
  int? status;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        personalInfo: json["personal_info"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
        "personal_info": personalInfo,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
