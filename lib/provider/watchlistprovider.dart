import 'dart:developer';

import 'package:dtlive/model/successmodel.dart';
import 'package:dtlive/model/watchlistmodel.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class WatchlistProvider extends ChangeNotifier {
  WatchlistModel watchlistModel = WatchlistModel();
  SuccessModel successModel = SuccessModel();

  bool loading = false;

  Future<void> getWatchlist() async {
    debugPrint("getWatchlist userID :==> ${Constant.userID}");
    loading = true;
    watchlistModel = await ApiService().watchlist();
    debugPrint("get_bookmark_video status :==> ${watchlistModel.status}");
    debugPrint("get_bookmark_video message :==> ${watchlistModel.message}");
    loading = false;
    notifyListeners();
  }

  Future<void> setBookMark(
      BuildContext context, position, typeId, videoType, videoId) async {
    loading = true;
    debugPrint("setBookMark typeId :==> $typeId");
    debugPrint("setBookMark videoType :==> $videoType");
    debugPrint("setBookMark videoId :==> $videoId");
    debugPrint(
        "watchlistModel videoId :==> ${(watchlistModel.result?[position].id ?? 0)}");
    if ((watchlistModel.result?[position].isBookmark ?? 0) == 0) {
      watchlistModel.result?[position].isBookmark = 1;
      Utils.showSnackbar(context, "success", "addwatchlistmessage", true);
    } else {
      watchlistModel.result?[position].isBookmark = 0;
      watchlistModel.result?.removeAt(position);
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

  clearProvider() {
    log("<================ clearProvider ================>");
    watchlistModel = WatchlistModel();
    successModel = SuccessModel();
  }
}
