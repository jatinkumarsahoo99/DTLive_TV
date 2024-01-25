// To parse this JSON data, do
// final sectionBannerModel = sectionBannerModelFromJson(jsonString);

import 'dart:convert';

SectionBannerModel sectionBannerModelFromJson(String str) =>
    SectionBannerModel.fromJson(json.decode(str));

String sectionBannerModelToJson(SectionBannerModel data) =>
    json.encode(data.toJson());

class SectionBannerModel {
  SectionBannerModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory SectionBannerModel.fromJson(Map<String, dynamic> json) =>
      SectionBannerModel(
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
  int? id;
  String? name;
  String? categoryId;
  String? description;
  int? videoType;
  int? typeId;
  String? thumbnail;
  String? landscape;
  String? trailerType;
  int? stopTime;
  int? isDownloaded;
  int? isBookmark;
  int? rentBuy;
  int? isRent;
  int? rentPrice;
  int? isBuy;
  String? categoryName;
  String? sessionId;
  int? upcomingType;
  String? videoUploadType;
  String? video320;
  String? subtitleType;
  String? video480;
  String? video720;
  String? video1080;

  Result({
    this.id,
    this.name,
    this.categoryId,
    this.description,
    this.videoType,
    this.typeId,
    this.thumbnail,
    this.landscape,
    this.trailerType,
    this.stopTime,
    this.isDownloaded,
    this.isBookmark,
    this.rentBuy,
    this.isRent,
    this.rentPrice,
    this.isBuy,
    this.categoryName,
    this.sessionId,
    this.upcomingType,
    this.videoUploadType,
    this.video320,
    this.subtitleType,
    this.video480,
    this.video720,
    this.video1080,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        categoryId: json["category_id"],
        description: json["description"],
        videoType: json["video_type"],
        typeId: json["type_id"],
        thumbnail: json["thumbnail"],
        landscape: json["landscape"],
        trailerType: json["trailer_type"],
        stopTime: json["stop_time"],
        isDownloaded: json["is_downloaded"],
        isBookmark: json["is_bookmark"],
        rentBuy: json["rent_buy"],
        isRent: json["is_rent"],
        rentPrice: json["rent_price"],
        isBuy: json["is_buy"],
        categoryName: json["category_name"],
        sessionId: json["session_id"],
        upcomingType: json["upcoming_type"],
        videoUploadType: json["video_upload_type"],
        video320: json["video_320"],
        subtitleType: json["subtitle_type"],
        video480: json["video_480"],
        video720: json["video_720"],
        video1080: json["video_1080"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category_id": categoryId,
        "description": description,
        "video_type": videoType,
        "type_id": typeId,
        "thumbnail": thumbnail,
        "landscape": landscape,
        "trailer_type": trailerType,
        "stop_time": stopTime,
        "is_downloaded": isDownloaded,
        "is_bookmark": isBookmark,
        "rent_buy": rentBuy,
        "is_rent": isRent,
        "rent_price": rentPrice,
        "is_buy": isBuy,
        "category_name": categoryName,
        "session_id": sessionId,
        "upcoming_type": upcomingType,
        "video_upload_type": videoUploadType,
        "video_320": video320,
        "subtitle_type": subtitleType,
        "video_480": video480,
        "video_720": video720,
        "video_1080": video1080,
      };
}
