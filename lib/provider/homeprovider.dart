import 'package:dtlive/model/sectiontypemodel.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

import '../model/VersionModel.dart' as ver;

class HomeProvider extends ChangeNotifier {
  SectionTypeModel sectionTypeModel = SectionTypeModel();

  bool loading = false, isTypeFocused = false;
  int selectedIndex = 0;
  String currentPage = "";

  Future<void> getSectionType() async {
    List<String> otherPages = [
      "Channels",
      "Store",
      "Search",
      Constant.userID != null ? "Logout" : "Login"

    ];
    List<Result>? pagesList = [];
    loading = true;
    sectionTypeModel = await ApiService().sectionType();
    debugPrint("get_type status :==> ${sectionTypeModel.status}");
    debugPrint("get_type message :==> ${sectionTypeModel.message}");
    if (sectionTypeModel.result != null) {
      if ((sectionTypeModel.result?.length ?? 0) > 0) {
        debugPrint(
            "sectionTypeModel length :=1=> ${sectionTypeModel.result?.length}");
        for (var i = 0; i < otherPages.length; i++) {
          Result pageResult = Result(
            id: (i + 1),
            name: otherPages[i].toString(),
            type: (i + 1),
            createdAt: "",
            updatedAt: "",
          );
          pagesList.add(pageResult);
        }
        for (var j = 0; j < pagesList.length; j++) {
          sectionTypeModel.result?.add(pagesList[j]);
        }
      }
    }
    debugPrint("pagesList :==> ${pagesList.length}");
    debugPrint(
        "sectionTypeModel length :=2=> ${sectionTypeModel.result?.length}");
    loading = false;
    notifyListeners();
  }

  Future<void> updateSideMenu() async {
    List<String> otherPages = [
      "Channels",
      "Store",
      "Search",
      Constant.userID != null ? "Logout" : "Login"
    ];
    List<Result>? pagesList = [];
    loading = true;
    if (sectionTypeModel.result != null) {
      if ((sectionTypeModel.result?.length ?? 0) > 0) {
        debugPrint(
            "sectionTypeModel length :=1=> ${sectionTypeModel.result?.length}");
        Result pageResult = Result(
          id: 0,
          name: Constant.userID != null ? "Logout" : "Login",
          type: 0,
          createdAt: "",
          updatedAt: "",
        );
        pagesList.add(pageResult);
        for (var j = 0; j < pagesList.length; j++) {
          sectionTypeModel.result?.add(pagesList[j]);
        }
      }
    } else {
      sectionTypeModel = await ApiService().sectionType();
      debugPrint("get_type status :==> ${sectionTypeModel.status}");
      debugPrint("get_type message :==> ${sectionTypeModel.message}");
      if (sectionTypeModel.result != null) {
        if ((sectionTypeModel.result?.length ?? 0) > 0) {
          debugPrint(
              "sectionTypeModel length :=1=> ${sectionTypeModel.result?.length}");
          for (var i = 0; i < otherPages.length; i++) {
            Result pageResult = Result(
              id: (i + 1),
              name: otherPages[i].toString(),
              type: (i + 1),
              createdAt: "",
              updatedAt: "",
            );
            pagesList.add(pageResult);
          }
          for (var j = 0; j < pagesList.length; j++) {
            sectionTypeModel.result?.add(pagesList[j]);
          }
        }
      }
    }
    debugPrint("pagesList :==> ${pagesList.length}");
    debugPrint(
        "sectionTypeModel length :=2=> ${sectionTypeModel.result?.length}");
    loading = false;
    notifyListeners();
  }



  Future<ver.VersionModel> getVersion() async {
    ver.VersionModel versionData;
    loading = true;
    versionData = await ApiService().getVersion();
    debugPrint("get_type status :==> ${sectionTypeModel.status}");
    debugPrint("get_type message :==> ${sectionTypeModel.message}");
    loading = false;
    notifyListeners();
    return versionData;
  }

  setLoading(bool isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  setSelectedTab(index) {
    selectedIndex = index;
    notifyListeners();
  }

  setFocused(bool isFocused) {
    isTypeFocused = isFocused;
    notifyListeners();
  }

  setCurrentPage(String pageName) {
    currentPage = pageName;
    notifyListeners();
  }

  homeNotifyProvider() {
    notifyListeners();
  }
}
