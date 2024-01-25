import 'dart:developer';

import 'package:dtlive/model/successmodel.dart';
import 'package:dtlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class PlayerProvider extends ChangeNotifier {
  SuccessModel successModel = SuccessModel();
  SuccessModel videoViewSuccessModel = SuccessModel();
  String currentSubtitle = "";
  String currentQuality = "";

  bool loading = false;

  Future<void> addVideoView(videoId, videoType, otherId) async {
    debugPrint("addVideoView videoId :====> $videoId");
    debugPrint("addVideoView otherId :====> $otherId");
    debugPrint("addVideoView videoType :==> $videoType");
    loading = true;
    videoViewSuccessModel = await ApiService().videoView(videoId, videoType, otherId);
    debugPrint("addVideoView message :==> ${videoViewSuccessModel.message}");
    loading = false;
    notifyListeners();
  }

  Future<void> addToContinue(videoId, videoType, stopTime) async {
    debugPrint("addToContinue stopTime :==> $stopTime");
    debugPrint("addToContinue videoType :==> $videoType");
    debugPrint("addToContinue videoId :==> $videoId");
    loading = true;
    successModel =
        await ApiService().addContinueWatching(videoId, videoType, stopTime);
    debugPrint("addToContinue message :==> ${successModel.message}");
    loading = false;
    notifyListeners();
  }

  Future<void> removeFromContinue(videoId, videoType) async {
    debugPrint("removeFromContinue videoType :==> $videoType");
    debugPrint("removeFromContinue videoId :==> $videoId");
    loading = true;
    successModel =
        await ApiService().removeContinueWatching(videoId, videoType);
    debugPrint("remove_continue_watching message :==> ${successModel.message}");
    loading = false;
    notifyListeners();
  }

  clearProvider() {
    log("<================ clearProvider ================>");
    successModel = SuccessModel();
    videoViewSuccessModel = SuccessModel();
  }


  setCurrentSubtitle(String subtitleName) {
    currentSubtitle = subtitleName;
    notifyListeners();
  }

  setCurrentQuality(String qualityName) {
    currentQuality = qualityName;
    notifyListeners();
  }

}
