import 'dart:developer';

import 'package:dtlive/model/episodebyseasonmodel.dart';
import 'package:dtlive/model/sectiondetailmodel.dart';
import 'package:dtlive/model/successmodel.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class ShowDetailsProvider extends ChangeNotifier {
  SuccessModel successModel = SuccessModel();
  SectionDetailModel sectionDetailModel = SectionDetailModel();
  EpisodeBySeasonModel episodeBySeasonModel = EpisodeBySeasonModel();

  bool loading = false;
  int seasonPos = 0, mCurrentEpiPos = -1;
  String tabClickedOn = "related";

  Future<void> getSectionDetails(
      typeId, videoType, videoId, upcomingType) async {
    debugPrint("getSectionDetails typeId :========> $typeId");
    debugPrint("getSectionDetails videoType :=====> $videoType");
    debugPrint("getSectionDetails videoId :=======> $videoId");
    debugPrint("getSectionDetails upcomingType :==> $upcomingType");
    loading = true;
    sectionDetailModel = SectionDetailModel();
    sectionDetailModel = await ApiService()
        .sectionDetails(typeId, videoType, videoId, upcomingType);
    loading = false;
    notifyListeners();
  }

  setEpisodeBySeason(episodeModel) async {
    episodeBySeasonModel = EpisodeBySeasonModel();
    episodeBySeasonModel = episodeModel;
    log("setEpisodeBySeason episodeBySeasonModel ================> ${episodeBySeasonModel.result?.length}");
    await getLastWatchedEpisode();
    notifyListeners();
  }

  getLastWatchedEpisode() {
    for (var i = 0; i < (episodeBySeasonModel.result?.length ?? 0); i++) {
      if ((episodeBySeasonModel.result?[i].stopTime ?? 0) > 0) {
        if (episodeBySeasonModel.result?[i].videoDuration != null) {
          if ((episodeBySeasonModel.result?[i].videoDuration ?? 0) > 0 &&
              (episodeBySeasonModel.result?[i].videoDuration ?? 0) !=
                  (episodeBySeasonModel.result?[i].stopTime ?? 0) &&
              (episodeBySeasonModel.result?[i].videoDuration ?? 0) >
                  (episodeBySeasonModel.result?[i].stopTime ?? 0)) {
            mCurrentEpiPos = i;
            return;
          } else {
            mCurrentEpiPos = 0;
          }
        }
      }
    }
    if ((episodeBySeasonModel.result?.length ?? 0) > 0 &&
        mCurrentEpiPos == -1) {
      mCurrentEpiPos = 0;
    }
    log("mCurrentEpiPos ========> $mCurrentEpiPos");
  }

  Future<void> setBookMark(
      BuildContext context, typeId, videoType, videoId) async {
    loading = true;
    if ((sectionDetailModel.result?.isBookmark ?? 0) == 0) {
      sectionDetailModel.result?.isBookmark = 1;
      Utils.showSnackbar(context, "success", "addwatchlistmessage", true);
    } else {
      sectionDetailModel.result?.isBookmark = 0;
      Utils.showSnackbar(context, "success", "removewatchlistmessage", true);
    }
    loading = false;
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

  setDownloadComplete(
      BuildContext context, videoId, videoType, typeId, otherId) {
    if ((sectionDetailModel.session?[seasonPos].isDownloaded ?? 0) == 0) {
      sectionDetailModel.session?[seasonPos].isDownloaded = 1;
      Utils.showSnackbar(context, "success", "download_success", true);
    } else {
      sectionDetailModel.session?[seasonPos].isDownloaded = 0;
      Utils.showSnackbar(context, "success", "download_remove_success", true);
    }
    notifyListeners();
    addToDownload(videoId, videoType, typeId, otherId);
  }

  Future<void> addToDownload(videoId, videoType, typeId, otherId) async {
    debugPrint("addRemoveDownload videoId :==> $videoId");
    debugPrint("addRemoveDownload videoType :==> $videoType");
    debugPrint("addRemoveDownload typeId :==> $typeId");
    debugPrint("addRemoveDownload otherId :==> $otherId");
    successModel = await ApiService()
        .addRemoveDownload(videoId, videoType, typeId, otherId);
    debugPrint("addRemoveDownload status :==> ${successModel.status}");
    debugPrint("addRemoveDownload message :==> ${successModel.message}");
  }

  setSeasonPosition(int position) async {
    log("setSeasonPosition ===> $position");
    mCurrentEpiPos = -1;
    await getLastWatchedEpisode();
    seasonPos = position;
    notifyListeners();
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
    episodeBySeasonModel = EpisodeBySeasonModel();
    successModel = SuccessModel();
    seasonPos = 0;
    mCurrentEpiPos = -1;
    tabClickedOn = "related";
  }
}
