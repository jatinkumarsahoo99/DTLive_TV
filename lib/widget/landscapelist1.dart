import 'dart:convert';

import 'package:dtlive/model/sectionlistmodel.dart' as section;
import 'package:dtlive/model/channelsectionmodel.dart' as channel;
import 'package:dtlive/pages/tvvideosbyid.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/dimens.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/mynetworkimg.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import '../model/channelsectionmodel.dart';
import '../pages/player_pod.dart';
import '../pages/player_vimeo.dart';
import '../pages/player_youtube.dart';
import '../utils/constant.dart';
import '../utils/strings.dart';

class LandscapeList1 extends StatefulWidget {
  final dynamic sectionDataList;
  final int? sectionPos;
  final String? dataType, dataFrom;
  final int? typeId;
  const LandscapeList1({
    Key? key,
    required this.sectionDataList,
    required this.sectionPos,
    required this.dataType,
    required this.dataFrom,
    required this.typeId,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  State<LandscapeList1> createState() => _LandscapeList1State();
}

class _LandscapeList1State extends State<LandscapeList1> {
  dynamic dataList = [];

  @override
  void initState() {
    debugPrint("dataFrom =========> ${widget.dataFrom}");
    debugPrint("dataType =========> ${widget.dataType}");
    if (widget.dataFrom == "Channel") {
      dataList = widget.sectionDataList as List<channel.Datum>?;
    } else {
      dataList = widget.sectionDataList as List<section.Datum>?;
    }
    super.initState();
  }

  openDetailPage(int dataPos, int videoId, int upcomingType, int videoType,
      int typeId) async {
    debugPrint("videoId ==========> $videoId");
    debugPrint("videoType ==========> $videoType");
    debugPrint("typeId ==========> $typeId");
    if (widget.dataType == "ByLanguage" || widget.dataType == "ByCategory") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return TVVideosByID(
              dataList?[dataPos].id ?? 0,
              widget.typeId ?? 0,
              dataList?[dataPos].name ?? "",
              widget.dataType ?? "",
            );
          },
        ),
      );
    } else {
      if (!mounted) return;
      Utils.openDetails(
        context: context,
        videoId: videoId,
        upcomingType: upcomingType,
        videoType: videoType,
        typeId: typeId,
      );
    }
  }

  @override
  void dispose() {
    dataList = [];
    super.dispose();
  }

  openPlayer(List<Datum>? sectionBannerList, int index) async {
    if (Constant.userID != null) {
      // if ((sectionBannerList?[index].lin ?? "").isNotEmpty) {
        if ((sectionBannerList?[index].isBuy ?? 0) == 1) {
          if (kIsWeb) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  if ((sectionBannerList?[index].video320 ?? "")
                      .contains("youtube")) {
                    return PlayerYoutube(
                      "Channel",
                      0,
                      0,
                      0,
                      0,
                      sectionBannerList?[index].video320 ?? "",
                      0,
                      "",
                      sectionBannerList?[index].thumbnail ?? "",
                    );
                  } else {
                    return PlayerPod(
                      "Channel",
                      0,
                      0,
                      0,
                      0,
                      sectionBannerList?[index].video320 ?? "",
                      0,
                      "",
                      sectionBannerList?[index].thumbnail ?? "",
                    );
                  }
                },
              ),
            );
          }
          else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  if ((sectionBannerList?[index].video320 ?? "")
                      .contains("youtube")) {
                    return PlayerYoutube(
                      "Channel",
                      0,
                      0,
                      0,
                      0,
                      sectionBannerList?[index].video320 ?? "",
                      0,
                      "",
                      sectionBannerList?[index].thumbnail ?? "",
                    );
                  }
                  else if ((sectionBannerList?[index].video320 ?? "")
                      .contains("vimeo")) {
                    return PlayerVimeo(
                      "Channel",
                      0,
                      0,
                      0,
                      0,
                      sectionBannerList?[index].video320 ?? "",
                      0,
                      "",
                      sectionBannerList?[index].thumbnail ?? "",
                    );
                  }
                  else {
                    print("I am in wright place");
                    return PlayerPod(
                      "Channel",
                      0,
                      0,
                      0,
                      0,
                      sectionBannerList?[index].video320 ?? "",
                      0,
                      "",
                      sectionBannerList?[index].thumbnail ?? "",
                    );
                  }
                },
              ),
            );
          }
        }
        else {
          if (kIsWeb || Constant.isTV) {
            Utils.showSnackbar(context, "info", webPaymentNotAvailable, false);
            return;
          }
        }
     /* } else {
        if (!mounted) return;
        Utils.showSnackbar(context, "fail", "invalid_url", true);
      }*/
    } else {
      if (!mounted) return;
      Utils.showSnackbar(context, "fail", "invalid_url", true);
      // widget._controller.selectIndex(8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: Dimens.heightLand-25,
      child: ListView.separated(
        itemCount: (dataList?.length ?? 0),
        padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 0),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          // print("Data is>>>"+(dataList?[index].toString()??""));
          return FocusBase(
            focusColor: white,
            onFocus: (isFocused) {},
            onPressed: () {
              debugPrint("Clicked on index ==> $index");
              // openPlayer(dataList,index);
              openDetailPage(
                index,
                dataList?[index].id ?? 0,
                (widget.dataFrom != "Channel")
                    ? (dataList?[index].upcomingType ?? 0)
                    : 0,
                dataList?[index].videoType ?? 0,
                dataList?[index].typeId ?? 0,
              );
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  width: Dimens.widthLand-70,
                  height: Dimens.heightLand-25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Stack(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.05),
                          child: MyNetworkImage(
                            imageUrl: (widget.dataType == "ByLanguage" ||
                                    widget.dataType == "ByCategory")
                                ? (dataList?[index].image.toString() ?? "")
                                : (dataList?[index].landscape.toString() ?? ""),
                            fit: BoxFit.cover,
                            imgHeight: MediaQuery.of(context).size.height,
                            imgWidth: MediaQuery.of(context).size.width,
                          ),
                        ),
                        if (widget.dataType == "ByLanguage" ||
                            widget.dataType == "ByCategory")
                          Container(
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width,
                            height: Dimens.heightLand,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.bottomCenter,
                                colors: [
                                  transparentColor,
                                  transparentColor,
                                  appBgColor,
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (widget.dataType == "ByLanguage" ||
                    widget.dataType == "ByCategory")
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: MyText(
                      color: white,
                      text: dataList?[index].name.toString() ?? "",
                      textalign: TextAlign.center,
                      fontsizeNormal: 14,
                      fontweight: FontWeight.w600,
                      fontsizeWeb: 15,
                      multilanguage: false,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
