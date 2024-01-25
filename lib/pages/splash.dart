import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dtlive/pages/home.dart';
import 'package:dtlive/provider/homeprovider.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/widget/myimage.dart';
import 'package:dtlive/utils/sharedpre.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/VersionModel.dart';
import '../utils/utils.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  SharedPre sharedPre = SharedPre();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (!mounted) return;
      isFirstCheck();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        color: appBgColor,
        child: MyImage(
          imagePath: "appicon.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Future<void> isFirstCheck() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    await homeProvider.setLoading(true);
    Constant.userID = await sharedPre.read('userid');
    log('Constant userID ==> ${Constant.userID}');
    if (!mounted) return;
    if(!kIsWeb) {
      await isUpdateApp(homeProvider);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const Home(pageName: "");
        },
      ),
    );
  }

  Future<bool>? isUpdateApp(HomeProvider provider) async {
    Completer<bool> completer = Completer<bool>();
    VersionModel? versionData = await provider.getVersion();
    if (Platform.isAndroid) {
      if (Constant.isTV) {
        if (versionData != null &&
            versionData.result != null &&
            ((versionData.result?.length ?? 0) > 0) &&
            (num.tryParse(versionData.result![0].tvAndroidVersionCode ?? "0") ??
                    0) >
                Constant.tvVersion) {
          dialog(versionData, completer);
        } else {
          completer.complete(false);
        }
      } else {
        if (versionData != null &&
            versionData.result != null &&
            ((versionData.result?.length ?? 0) > 0) &&
            (num.tryParse(versionData.result![0].androidVersionCode ?? "0") ??
                    0) >
                Constant.androidVersion) {
          dialog(versionData, completer);
        } else {
          completer.complete(false);
        }
      }
    } else if (Platform.isIOS) {
      if (versionData != null &&
          versionData.result != null &&
          ((versionData.result?.length ?? 0) > 0) &&
          (num.tryParse(versionData.result![0].iosVersionCode ?? "0") ?? 0) >
              Constant.iosVersion) {
        dialog(versionData, completer);
      } else {
        completer.complete(false);
      }
    } else {
      completer.complete(false);
    }
    return completer.future;
  }

  dialog(versionData, completer) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "App Update Available";
        String btnLabel = "Update Now";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                // content: Text(""),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      btnLabel,
                    ),
                    isDefaultAction: true,
                    onPressed: () {
                      Utils.openUrl(
                          versionData.result![0].iosVersionLinkurl ?? "");
                      completer.complete(true);
                    },
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(
                  title,
                  style: TextStyle(fontSize: 22),
                ),
                // content: Text(message),
                actions: <Widget>[
                  MaterialButton(
                    child: Text(btnLabel),
                    onPressed: () {
                      if(Constant.isTV){
                        Utils.openUrl(
                            versionData.result![0].tvAndroidVersionLinkurl ?? "");
                      }else {
                        Utils.openUrl(
                            versionData.result![0].androidVersionLinkurl ?? "");
                      }
                      completer.complete(true);
                    },
                  ),
                ],
              );
      },
    ).then((value) {
      // completer.complete(false);
    });
  }
}
