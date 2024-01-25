import 'dart:developer';

import 'package:dtlive/model/sectionbannermodel.dart';
import 'package:dtlive/model/sectionlistmodel.dart';
import 'package:dtlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class SectionDataProvider extends ChangeNotifier {
  SectionBannerModel sectionBannerModel = SectionBannerModel();
  SectionListModel sectionListModel = SectionListModel();

  bool loadingBanner = false, loadingSection = false;
  int? cBannerIndex = 0, lastTabPosition;

  Future<void> getSectionBanner(typeId, isHomePage) async {
    debugPrint("getSectionBanner typeId :==> $typeId");
    debugPrint("getSectionBanner isHomePage :==> $isHomePage");
    loadingBanner = true;
    sectionBannerModel = await ApiService().sectionBanner(typeId, isHomePage);
    debugPrint("get_banner status :==> ${sectionBannerModel.status}");
    debugPrint("get_banner message :==> ${sectionBannerModel.message}");
    loadingBanner = false;
    notifyListeners();
  }

  setLoading(bool flagLoading) {
    loadingBanner = flagLoading;
    loadingSection = flagLoading;
    notifyListeners();
  }

  setTabPosition(position) {
    lastTabPosition = position;
    notifyListeners();
  }

  setCurrentBanner(index) {
    cBannerIndex = index;
    notifyListeners();
  }

  Future<void> getSectionList(typeId, isHomePage) async {
    debugPrint("getSectionList typeId :==> $typeId");
    debugPrint("getSectionList isHomePage :==> $isHomePage");
    loadingSection = true;
    sectionListModel = await ApiService().sectionList(typeId, isHomePage);
    debugPrint("section_list status :==> ${sectionListModel.status}");
    debugPrint("section_list message :==> ${sectionListModel.message}");
    loadingSection = false;
    notifyListeners();
  }

  clearProvider() {
    log("<================ clearProvider ================>");
    loadingBanner = false;
    loadingSection = false;
    sectionBannerModel = SectionBannerModel();
    sectionListModel = SectionListModel();
    cBannerIndex = 0;
    lastTabPosition = 0;
  }
}
