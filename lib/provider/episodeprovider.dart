
import 'package:dtlive/model/episodebyseasonmodel.dart';
import 'package:dtlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class EpisodeProvider extends ChangeNotifier {
  EpisodeBySeasonModel episodeBySeasonModel = EpisodeBySeasonModel();

  bool loading = false;

  Future<void> getEpisodeBySeason(seasonId, showId) async {
    loading = true;
    episodeBySeasonModel = await ApiService().episodeBySeason(seasonId, showId);
    loading = false;
    notifyListeners();
  }

  clearProvider() {
    debugPrint("<================ clearProvider ================>");
    episodeBySeasonModel = EpisodeBySeasonModel();
  }
}
