import 'package:dtlive/pages/activetv.dart';
import 'package:dtlive/pages/tvchannels.dart';
import 'package:dtlive/pages/tvhome.dart';
import 'package:dtlive/pages/tvrentstore.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class MyPageBuilder extends StatelessWidget {
  const MyPageBuilder({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return _replaceByIndex(controller.selectedIndex);
      },
    );
  }

  Widget _replaceByIndex(int index) {
    switch (index) {
      case 6:
        return TVChannels(controller: controller);
      case 7:
        return TVRentStore(controller: controller);
      case 8:
        // return const ActiveTV();
        return Container();
      default:
        return TVHome(pageName: '', controller: controller);
    }
  }

  openDetailPage(BuildContext context) {
    debugPrint(
        "openDetailPage videoId ===> ${Constant.detailIDList['videoId']}");
    debugPrint(
        "openDetailPage upcomingType => ${Constant.detailIDList['upcomingType']}");
    debugPrint(
        "openDetailPage videoType => ${Constant.detailIDList['videoType']}");
    debugPrint(
        "openDetailPage typeId ====> ${Constant.detailIDList['typeId']}");
    int videoId, upcomingType, videoType, typeId;
    videoId = Constant.detailIDList['videoId'] ?? 0;
    upcomingType = Constant.detailIDList['upcomingType'] ?? 0;
    videoType = Constant.detailIDList['videoType'] ?? 0;
    typeId = Constant.detailIDList['typeId'] ?? 0;

    if (!(context.mounted)) return;
    Utils.openDetails(
      context: context,
      videoId: videoId,
      upcomingType: upcomingType,
      videoType: videoType,
      typeId: typeId,
    );
  }
}

String getTitleByIndex(int index) {
  switch (index) {
    case 6:
      return 'Channel';
    case 7:
      return 'Rent';
    case 8:
      return 'TVLogin';
    case 9:
      return 'DetailPage';
    default:
      return 'Home';
  }
}
