// To parse this JSON data, do
// final pagesModel = pagesModelFromJson(jsonString);

import 'dart:convert';

PagesModel pagesModelFromJson(String str) =>
    PagesModel.fromJson(json.decode(str));

String pagesModelToJson(PagesModel data) => json.encode(data.toJson());

class PagesModel {
  int? status;
  String? message;
  List<Result>? result;

  PagesModel({
    this.status,
    this.message,
    this.result,
  });

  factory PagesModel.fromJson(Map<String, dynamic> json) => PagesModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null
            ? []
            : List<Result>.from(
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
  String? pageName;
  String? url;

  Result({
    this.pageName,
    this.url,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        pageName: json["page_name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "page_name": pageName,
        "url": url,
      };
}
