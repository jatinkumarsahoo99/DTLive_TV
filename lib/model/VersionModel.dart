class VersionModel {
  int? status;
  String? message;
  List<Result>? result;

  VersionModel({this.status, this.message, this.result});

  VersionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? slNo;
  String? androidVersionName;
  String? iosVersionName;
  String? androidVersionCode;
  String? tvAndroidVersionCode;
  String? tvAndroidVersionName;
  String? iosVersionCode;
  String? androidVersionLinkurl;
  String? tvAndroidVersionLinkurl;
  String? iosVersionLinkurl;
  String? createdAt;

  Result(
      {this.slNo,
      this.androidVersionName,
      this.tvAndroidVersionCode,
      this.iosVersionName,
      this.androidVersionCode,
      this.iosVersionCode,
      this.androidVersionLinkurl,
      this.iosVersionLinkurl,
      this.createdAt});

  Result.fromJson(Map<String, dynamic> json) {
    slNo = json['sl_no'];
    androidVersionName = json['android_version_name'];
    tvAndroidVersionName = json['tv_android_version_name'];
    iosVersionName = json['ios_version_name'];
    androidVersionCode = json['android_version_code'];
    tvAndroidVersionCode = json['tv_android_version_code'];
    iosVersionCode = json['ios_version_code'];
    androidVersionLinkurl = json['android_version_linkurl'];
    iosVersionLinkurl = json['ios_version_linkurl'];
    tvAndroidVersionLinkurl = json['tv_android_version_linkurl'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sl_no'] = this.slNo;
    data['android_version_name'] = this.androidVersionName;
    data['ios_version_name'] = this.iosVersionName;
    data['android_version_code'] = this.androidVersionCode;
    data['ios_version_code'] = this.iosVersionCode;
    data['android_version_linkurl'] = this.androidVersionLinkurl;
    data['ios_version_linkurl'] = this.iosVersionLinkurl;
    data['created_at'] = this.createdAt;
    return data;
  }
}
