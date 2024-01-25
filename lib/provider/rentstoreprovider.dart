import 'dart:developer';

import 'package:dtlive/model/rentmodel.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class RentStoreProvider extends ChangeNotifier {
  RentModel rentModel = RentModel();

  bool loading = false;

  Future<void> getRentVideoList() async {
    debugPrint("getRentVideoList userID :==> ${Constant.userID}");
    loading = true;
    rentModel = await ApiService().rentVideoList();
    debugPrint("rent_video_list status :==> ${rentModel.status}");
    debugPrint("rent_video_list message :==> ${rentModel.message}");
    loading = false;
    notifyListeners();
  }

  clearRentStoreProvider() {
    log("<================ clearRentStoreProvider ================>");
    rentModel = RentModel();
  }
}
