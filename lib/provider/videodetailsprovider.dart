import 'dart:developer';

import 'package:dtlive/model/sectiondetailmodel.dart';
import 'package:dtlive/model/successmodel.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class VideoDetailsProvider extends ChangeNotifier {
  SuccessModel successModel = SuccessModel();
  SectionDetailModel sectionDetailModel = SectionDetailModel();

  bool loading = false;
  String tabClickedOn = "related";

  Future<void> getSectionDetails(
      typeId, videoType, videoId, upcomingType) async {
    debugPrint("getSectionDetails typeId :========> $typeId");
    debugPrint("getSectionDetails videoType :=====> $videoType");
    debugPrint("getSectionDetails videoId :=======> $videoId");
    debugPrint("getSectionDetails upcomingType :==> $upcomingType");
    loading = true;
    sectionDetailModel = await ApiService().sectionDetails(typeId, videoType, videoId, upcomingType);
    debugPrint("section_detail status :==> ${sectionDetailModel.status}");
    debugPrint("section_detail message :==> ${sectionDetailModel.message}");
    loading = false;
    notifyListeners();
  }

  Future<void> setBookMark(
      BuildContext context, typeId, videoType, videoId) async {
    if ((sectionDetailModel.result?.isBookmark ?? 0) == 0) {
      sectionDetailModel.result?.isBookmark = 1;
      Utils.showSnackbar(context, "success", "addwatchlistmessage", true);
    } else {
      sectionDetailModel.result?.isBookmark = 0;
      Utils.showSnackbar(context, "success", "removewatchlistmessage", true);
    }
    notifyListeners();
    getAddBookMark(typeId, videoType, videoId);
  }

  Future<void> getAddBookMark(typeId, videoType, videoId) async {
    debugPrint("getAddBookMark typeId :==> $typeId");
    debugPrint("getAddBookMark videoType :==> $videoType");
    debugPrint("getAddBookMark videoId :==> $videoId");
    successModel =
        await ApiService().addRemoveBookmark(typeId, videoType, videoId);
    debugPrint("add_remove_bookmark status :==> ${successModel.status}");
    debugPrint("add_remove_bookmark message :==> ${successModel.message}");
  }

  Future<void> removeFromContinue(videoId, videoType) async {
    sectionDetailModel.result?.stopTime = 0;
    notifyListeners();

    debugPrint("removeFromContinue videoType :==> $videoType");
    debugPrint("removeFromContinue videoId :==> $videoId");
    successModel =
        await ApiService().removeContinueWatching(videoId, videoType);
    debugPrint("removeFromContinue message :==> ${successModel.message}");
  }

  setDownloadComplete(BuildContext context, videoId, videoType, typeId) {
    if ((sectionDetailModel.result?.isDownloaded ?? 0) == 0) {
      sectionDetailModel.result?.isDownloaded = 1;
      Utils.showSnackbar(context, "success", "download_success", true);
    } else {
      sectionDetailModel.result?.isDownloaded = 0;
      Utils.showSnackbar(context, "success", "download_remove_success", true);
    }
    notifyListeners();
    addToDownload(videoId, videoType, typeId);
  }

  Future<void> addToDownload(videoId, videoType, typeId) async {
    debugPrint("addRemoveDownload typeId :==> $typeId");
    debugPrint("addRemoveDownload videoType :==> $videoType");
    debugPrint("addRemoveDownload videoId :==> $videoId");
    successModel =
        await ApiService().addRemoveDownload(videoId, videoType, typeId, "0");
    debugPrint("addRemoveDownload status :==> ${successModel.status}");
    debugPrint("addRemoveDownload message :==> ${successModel.message}");
  }

  updateRentPurchase() {
    if (sectionDetailModel.result != null) {
      sectionDetailModel.result?.rentBuy == 1;
    }
  }

  updatePrimiumPurchase() {
    if (sectionDetailModel.result != null) {
      sectionDetailModel.result?.isBuy == 1;
    }
  }

  setTabClick(clickedOn) {
    log("clickedOn ===> $clickedOn");
    tabClickedOn = clickedOn;
    notifyListeners();
  }

  clearProvider() {
    log("<================ clearProvider ================>");
    sectionDetailModel = SectionDetailModel();
    successModel = SuccessModel();
    tabClickedOn = "related";
  }
}
