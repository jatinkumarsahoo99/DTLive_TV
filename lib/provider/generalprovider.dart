import 'dart:io';

import 'package:dtlive/model/generalsettingmodel.dart';
import 'package:dtlive/model/loginregistermodel.dart';
import 'package:dtlive/model/pagesmodel.dart';
import 'package:dtlive/model/tvcodemodel.dart';
import 'package:dtlive/utils/sharedpre.dart';
import 'package:dtlive/webservice/apiservices.dart';
import 'package:flutter/material.dart';

class GeneralProvider extends ChangeNotifier {
  GeneralSettingModel generalSettingModel = GeneralSettingModel();
  PagesModel pagesModel = PagesModel();
  LoginRegisterModel loginGmailModel = LoginRegisterModel();
  LoginRegisterModel loginOTPModel = LoginRegisterModel();
  TvCodeModel tvCodeModel = TvCodeModel();

  bool loading = false;

  SharedPre sharedPre = SharedPre();

  Future<void> getGeneralsetting() async {
    loading = true;
    generalSettingModel = await ApiService().genaralSetting();
    debugPrint("genaral_setting status :==> ${generalSettingModel.status}");
    loading = false;
    debugPrint('generalSettingData status ==> ${generalSettingModel.status}');
    if (generalSettingModel.status == 200) {
      if (generalSettingModel.result != null) {
        for (var i = 0; i < (generalSettingModel.result?.length ?? 0); i++) {
          await sharedPre.save(
            generalSettingModel.result?[i].key.toString() ?? "",
            generalSettingModel.result?[i].value.toString() ?? "",
          );
          debugPrint(
              '${generalSettingModel.result?[i].key.toString()} ==> ${generalSettingModel.result?[i].value.toString()}');
        }
      }
    }
  }

  Future<void> getPages() async {
    loading = true;
    pagesModel = await ApiService().getPages();
    debugPrint("getPages status :==> ${pagesModel.status}");
    loading = false;
    if (pagesModel.status == 200) {
      if (pagesModel.result != null) {
        for (var i = 0; i < (pagesModel.result?.length ?? 0); i++) {
          await sharedPre.save(
            pagesModel.result?[i].pageName.toString() ?? "",
            pagesModel.result?[i].url.toString() ?? "",
          );
          debugPrint(
              '${pagesModel.result?[i].pageName.toString()} ==> ${pagesModel.result?[i].url.toString()}');
        }
      }
    }
  }

  Future<void> loginWithSocial(email, name, type, File? profileImg) async {
    debugPrint("loginWithSocial email :==> $email");
    debugPrint("loginWithSocial name :==> $name");
    debugPrint("loginWithSocial type :==> $type");
    debugPrint("loginWithSocial profileImg :==> ${profileImg?.path}");

    loading = true;
    loginGmailModel =
        await ApiService().loginWithSocial(email, name, type, profileImg);
    debugPrint("login status :==> ${loginGmailModel.status}");
    debugPrint("login message :==> ${loginGmailModel.message}");
    loading = false;
    notifyListeners();
  }

  Future<void> loginWithOTP(mobile) async {
    debugPrint("getLoginOTP mobile :==> $mobile");

    loading = true;
    loginOTPModel = await ApiService().loginWithOTP(mobile);
    debugPrint("login status :==> ${loginOTPModel.status}");
    debugPrint("login message :==> ${loginOTPModel.message}");
    loading = false;
    notifyListeners();
  }

  Future<void> getTVLoginCode(deviceToken) async {
    debugPrint("getTVLoginCode deviceToken :==> $deviceToken");
    loading = true;
    tvCodeModel = await ApiService().tvLoginCode(deviceToken);
    debugPrint("getTVLoginCode status :===> ${tvCodeModel.status}");
    debugPrint("getTVLoginCode message :==> ${tvCodeModel.message}");
    loading = false;
    notifyListeners();
  }
}
