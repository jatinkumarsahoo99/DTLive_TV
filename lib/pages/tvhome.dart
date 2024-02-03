import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dtlive/model/sectionlistmodel.dart';
import 'package:dtlive/model/sectiontypemodel.dart' as type;
import 'package:dtlive/model/sectionlistmodel.dart' as list;
import 'package:dtlive/model/sectionbannermodel.dart' as banner;
import 'package:dtlive/provider/homeprovider.dart';
import 'package:dtlive/provider/sectiondataprovider.dart';
import 'package:dtlive/shimmer/shimmerutils.dart';

import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/utils/dimens.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/sharedpre.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/landscapelist.dart';
import 'package:dtlive/widget/myimage.dart';
import 'package:dtlive/widget/mynetworkimg.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

// import '../player/ApinioPlayer.dart';
// import '../player/TvPlayerNew.dart';
import '../player/player_video.dart';
// import '../player/vlc.dart';
import '../widget/landscapelist1.dart';

class TVHome extends StatefulWidget {
  final String? pageName;

  const TVHome({
    Key? key,
    required this.pageName,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  State<TVHome> createState() => TVHomeState();
}

class TVHomeState extends State<TVHome> {
  late SectionDataProvider sectionDataProvider;
  final FirebaseAuth auth = FirebaseAuth.instance;
  CarouselController pageController = CarouselController();
  SharedPre sharedPref = SharedPre();
  late HomeProvider homeProvider;
  bool isSearchEnable = false;
  String? currentPage;
  int? videoId, videoType, typeId;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  @override
  void initState() {
    currentPage = widget.pageName ?? "";
    sectionDataProvider =
        Provider.of<SectionDataProvider>(context, listen: false);
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    super.initState();
  }

  Future<void> setSelectedTab(int tabPos) async {
    if (!mounted) return;
    await homeProvider.setSelectedTab(tabPos);
    debugPrint("setSelectedTab position ====> $tabPos");
    sectionDataProvider.setTabPosition(tabPos);
  }

  Future<void> getTabData(int position) async {
    await setSelectedTab(position);
    await sectionDataProvider.setLoading(true);
    await sectionDataProvider.getSectionBanner(
        position == 0
            ? "0"
            : (homeProvider.sectionTypeModel.result?[position - 1].id),
        position == 0 ? "1" : "2");
    await sectionDataProvider.getSectionList(
        position == 0
            ? "0"
            : (homeProvider.sectionTypeModel.result?[position - 1].id),
        position == 0 ? "1" : "2");
  }

  openDetailPage(int dataPos, int videoId, int upcomingType, int videoType,
      int typeId) async {
    debugPrint("videoId ==========> $videoId");
    debugPrint("videoType ==========> $videoType");
    debugPrint("typeId ==========> $typeId");
    if (!mounted) return;
    Utils.openDetails(
      context: context,
      videoId: videoId,
      upcomingType: upcomingType,
      videoType: videoType,
      typeId: typeId,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
        child: _tvAppBarWithDetails(),
      ),
    );
  }

  Widget _tvAppBarWithDetails() {
    if (homeProvider.loading) {
      return ShimmerUtils.buildHomeMobileShimmer(context);
    } else {
      if (homeProvider.sectionTypeModel.status == 200) {
        if (homeProvider.sectionTypeModel.result != null ||
            (homeProvider.sectionTypeModel.result?.length ?? 0) > 0) {
          return _buildAppBar();
        } else {
          return const SizedBox.shrink();
        }
      } else {
        return const SizedBox.shrink();
      }
    }
  }

  Widget _buildAppBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // const HomeTabs(),
        // Container(
        //   width: 2.0,
        //   decoration: Utils.setBackground(dotsDefaultColor, 5.0),
        // ),
        Expanded(
          child: tabItem(homeProvider.sectionTypeModel.result),
        ),
      ],
    );
  }

  Widget tabItem(List<type.Result>? sectionTypeList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints.expand(),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              /* Banner */
              Consumer<SectionDataProvider>(
                builder: (context, sectionDataProvider, child) {
                  if (sectionDataProvider.loadingBanner) {
                    return ShimmerUtils.bannerWeb(context);
                  } else {
                    if (sectionDataProvider.sectionBannerModel.status == 200 &&
                        sectionDataProvider.sectionBannerModel.result != null) {
                      return _tvHomeBanner(
                          sectionDataProvider.sectionBannerModel.result);
                    } else {
                      return const SizedBox.shrink();
                    }
                  }
                },
              ),

              /* Continue Watching & Remaining Sections */
              Consumer<SectionDataProvider>(
                builder: (context, sectionDataProvider, child) {
                  if (sectionDataProvider.loadingSection) {
                    return sectionShimmer();
                  } else {
                    if (sectionDataProvider.sectionListModel.status == 200) {
                      return Column(
                        children: [
                          /* Continue Watching */
                          (sectionDataProvider
                              .sectionListModel.continueWatching !=
                              null)
                              ? continueWatchingLayout(sectionDataProvider
                              .sectionListModel.continueWatching)
                              : const SizedBox.shrink(),

                          /* Remaining Sections */
                          (sectionDataProvider.sectionListModel.result != null)
                              ? setSectionByType(
                              sectionDataProvider.sectionListModel.result)
                              : const SizedBox.shrink(),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tvHomeBanner(List<banner.Result>? sectionBannerList) {
    if ((sectionBannerList?.length ?? 0) > 0) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: Dimens.homeWebBanner,
        child: CarouselSlider.builder(
          itemCount: (sectionBannerList?.length ?? 0),
          carouselController: pageController,
          options: CarouselOptions(
            initialPage: 0,
            height: Dimens.homeWebBanner,
            enlargeCenterPage: false,
            autoPlay: false,
            autoPlayCurve: Curves.easeInOutQuart,
            enableInfiniteScroll: true,
            autoPlayInterval: Duration(milliseconds: Constant.bannerDuration),
            autoPlayAnimationDuration:
                Duration(milliseconds: Constant.animationDuration),
            viewportFraction: 0.95,
            onPageChanged: (val, _) async {
              await sectionDataProvider.setCurrentBanner(val);
            },
          ),
          itemBuilder: (BuildContext context, int index, int pageViewIndex) {
            return Container(
              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: FocusBase(
                focusColor: white,
                onPressed: () {
                  debugPrint("Clicked on index ==> $index");
                  openDetailPage(
                    index,
                    sectionBannerList?[index].id ?? 0,
                    sectionBannerList?[index].upcomingType ?? 0,
                    sectionBannerList?[index].videoType ?? 0,
                    sectionBannerList?[index].typeId ?? 0,
                  );
                },
                onFocus: (isFocused) {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            (Dimens.webBannerImgPr),
                        height: Dimens.homeWebBanner,
                        child: MyNetworkImage(
                          imageUrl: sectionBannerList?[index].landscape ?? "",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width,
                        height: Dimens.homeWebBanner,
                        alignment: Alignment.centerLeft,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              lightBlack,
                              lightBlack,
                              lightBlack,
                              lightBlack,
                              transparentColor,
                              transparentColor,
                              transparentColor,
                              transparentColor,
                              transparentColor,
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: Dimens.homeWebBanner,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  (1.0 - Dimens.webBannerImgPr),
                              constraints: const BoxConstraints(minHeight: 0),
                              padding:
                                  const EdgeInsets.fromLTRB(35, 50, 55, 35),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    color: white,
                                    text: sectionBannerList?[index].name ?? "",
                                    textalign: TextAlign.start,
                                    fontsizeNormal: 14,
                                    fontsizeWeb: 25,
                                    fontweight: FontWeight.w700,
                                    multilanguage: false,
                                    maxline: 2,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                  ),
                                  const SizedBox(height: 12),
                                  MyText(
                                    color: whiteLight,
                                    text: sectionBannerList?[index]
                                            .categoryName ??
                                        "",
                                    textalign: TextAlign.start,
                                    fontsizeNormal: 14,
                                    fontweight: FontWeight.w600,
                                    fontsizeWeb: 15,
                                    multilanguage: false,
                                    maxline: 2,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: MyText(
                                      color: whiteLight,
                                      text: sectionBannerList?[index]
                                              .description ??
                                          "",
                                      textalign: TextAlign.start,
                                      fontsizeNormal: 14,
                                      fontweight: FontWeight.w600,
                                      fontsizeWeb: 15,
                                      multilanguage: false,
                                      maxline:
                                          (MediaQuery.of(context).size.width <
                                                  1000)
                                              ? 2
                                              : 5,
                                      overflow: TextOverflow.ellipsis,
                                      fontstyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /* Section Shimmer */
  Widget sectionShimmer() {
    return Column(
      children: [
        /* Continue Watching */
        if (Constant.userID != null && homeProvider.selectedIndex == 0)
          const SizedBox(height: 25),
        if (Constant.userID != null && homeProvider.selectedIndex == 0)
          ShimmerUtils.continueWatching(context),

        /* Remaining Sections */
        ListView.builder(
          itemCount: 10,
          // itemCount must be greater than 5
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10, 25, 0, 25),
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 25),
                ShimmerUtils.setHomeSections(context, "landscape"),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget continueWatchingLayout(List<ContinueWatching>? continueWatchingList) {
    if ((continueWatchingList?.length ?? 0) > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Constant.userID != null &&
              homeProvider.selectedIndex == 0 &&
              (sectionDataProvider.sectionBannerModel.result != null ||
                  (sectionDataProvider.sectionBannerModel.result?.length ?? 0) >
                      0))
            const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
            child: MyText(
              color: white,
              text: "continuewatching",
              multilanguage: true,
              textalign: TextAlign.center,
              fontsizeNormal: 14,
              fontsizeWeb: 16,
              fontweight: FontWeight.w600,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              fontstyle: FontStyle.normal,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: Dimens.heightLand,
            child: ListView.separated(
              itemCount: (continueWatchingList?.length ?? 0),
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 20, right: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 0),
              itemBuilder: (BuildContext context, int index) {
                return FocusBase(
                  focusColor: white,
                  onPressed: () async {
                    openPlayer("ContinueWatch", index, continueWatchingList);
                  },
                  onFocus: (isFocused) {},
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Container(
                        width: Dimens.widthLand,
                        height: Dimens.heightLand,
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: MyNetworkImage(
                            imageUrl:
                                continueWatchingList?[index].landscape ?? "",
                            fit: BoxFit.fill,
                            imgHeight: MediaQuery.of(context).size.height,
                            imgWidth: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 8),
                            child: MyImage(
                              width: 30,
                              height: 30,
                              imagePath: "play.png",
                            ),
                          ),
                          Container(
                            width: Dimens.widthLand,
                            constraints: const BoxConstraints(minWidth: 0),
                            padding: const EdgeInsets.all(3),
                            child: LinearPercentIndicator(
                              padding: const EdgeInsets.all(0),
                              barRadius: const Radius.circular(2),
                              lineHeight: 4,
                              percent: Utils.getPercentage(
                                  continueWatchingList?[index].videoDuration ??
                                      0,
                                  continueWatchingList?[index].stopTime ?? 0),
                              backgroundColor: secProgressColor,
                              progressColor: primaryColor,
                            ),
                          ),
                          (continueWatchingList?[index].releaseTag != null &&
                                  (continueWatchingList?[index].releaseTag ??
                                          "")
                                      .isNotEmpty)
                              ? Container(
                                  decoration: const BoxDecoration(
                                    color: black,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(4),
                                      bottomRight: Radius.circular(4),
                                    ),
                                    shape: BoxShape.rectangle,
                                  ),
                                  alignment: Alignment.center,
                                  width: Dimens.widthContiLand,
                                  height: 15,
                                  child: MyText(
                                    color: white,
                                    multilanguage: false,
                                    text: continueWatchingList?[index]
                                            .releaseTag ??
                                        "",
                                    textalign: TextAlign.center,
                                    fontsizeNormal: 6,
                                    fontweight: FontWeight.w700,
                                    fontsizeWeb: 10,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget setSectionByType(List<list.Result>? sectionList) {
    return ListView.builder(
      itemCount: sectionList?.length ?? 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(10, 25, 0, 25),
      itemBuilder: (BuildContext context, int index) {
        if (sectionList?[index].data != null &&
            (sectionList?[index].data?.length ?? 0) > 0) {
          print("Section : ${sectionList?[index].title.toString() ?? ""}");
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: MyText(
                  color: white,
                  text: (sectionList?[index].title.toString() ?? ""),
                  textalign: TextAlign.center,
                  fontsizeNormal: 14,
                  fontweight: FontWeight.w600,
                  fontsizeWeb: 16,
                  multilanguage: false,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: Dimens.heightLand - 25,
                child: setSectionData(sectionList: sectionList, index: index),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget setSectionData(
      {required List<list.Result>? sectionList, required int index}) {
    /* video_type =>  1-video,  2-show,  3-language,  4-category */
    /* screen_layout =>  landscape, potrait, square */
    print("Video type: " + (sectionList?[index].videoType.toString() ?? ""));
    if (sectionList?[index].title?.toLowerCase().trim() == "popular ott") {
      return LandscapeList1(
        sectionDataList: sectionList?[index].data,
        sectionPos: index,
        dataFrom: 'Home',
        dataType: 'ByCategory',
        typeId: sectionList?[index].typeId ?? 0,
        controller: widget._controller,
      );
    } else if ((sectionList?[index].videoType ?? 0) == 1 ||
        (sectionList?[index].videoType ?? 0) == 2) {
      return LandscapeList(
        sectionDataList: sectionList?[index].data,
        sectionPos: index,
        dataFrom: 'Home',
        dataType: 'Section',
        typeId: sectionList?[index].typeId ?? 0,
        controller: widget._controller,
      );
    } else if ((sectionList?[index].videoType ?? 0) == 3) {
      return LandscapeList(
        sectionDataList: sectionList?[index].data,
        sectionPos: index,
        dataFrom: 'Home',
        dataType: 'ByLanguage',
        typeId: sectionList?[index].typeId ?? 0,
        controller: widget._controller,
      );
    } else if ((sectionList?[index].videoType ?? 0) == 4) {
      return LandscapeList(
        sectionDataList: sectionList?[index].data,
        sectionPos: index,
        dataFrom: 'Home',
        dataType: 'ByLanguage',
        typeId: sectionList?[index].typeId ?? 0,
        controller: widget._controller,
      );
    } else {
      return LandscapeList(
        sectionDataList: sectionList?[index].data,
        sectionPos: index,
        dataFrom: 'Home',
        dataType: 'ByCategory',
        typeId: sectionList?[index].typeId ?? 0,
        controller: widget._controller,
      );
    }
  }

  /* ========= Open Player ========= */
  openPlayer(String playType, int index,
      List<ContinueWatching>? continueWatchingList) async {
    debugPrint("index ==========> $index");
    /* Set-up Quality URLs */
    Utils.setQualityURLs(
      video320: (continueWatchingList?[index].video320 ?? ""),
      video480: (continueWatchingList?[index].video480 ?? ""),
      video720: (continueWatchingList?[index].video720 ?? ""),
      video1080: (continueWatchingList?[index].video1080 ?? ""),
    );
    bool? isContinues = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (continueWatchingList?[index].video1080 != null &&
              continueWatchingList?[index].video320 != "") {
            // return Vlc(continueWatchingList?[index].video1080 ?? "");
            return PlayerVideo((continueWatchingList?[index].videoType ?? 0) == 2
                ? "Show"
                : "Video",(continueWatchingList?[index].videoType ?? 0) == 2
                ? (continueWatchingList?[index].showId ?? 0)
                : (continueWatchingList?[index].id ?? 0),continueWatchingList?[index].videoType ?? 0,continueWatchingList?[index].typeId,continueWatchingList?[index].channelId,continueWatchingList?[index].video320 ?? "",continueWatchingList?[index].stopTime,(continueWatchingList?[index].videoUploadType??""),continueWatchingList?[index].thumbnail);

           /* return Vlc(
              url: continueWatchingList?[index].video320 ?? "",
              playType: (continueWatchingList?[index].videoType ?? 0) == 2
                  ? "Show"
                  : "Video",
              stopTime: continueWatchingList?[index].stopTime ?? 0,
              videoId: (continueWatchingList?[index].videoType ?? 0) == 2
                  ? (continueWatchingList?[index].showId ?? 0)
                  : (continueWatchingList?[index].id ?? 0),
              videoType: continueWatchingList?[index].videoType ?? 0,
            );*/
            // return MyTvScreen(urlData:continueWatchingList?[index].video320 ?? "");
            /*return ApinioPlayer(
                urlData: continueWatchingList?[index].video320 ?? "");*/
          } else {
            return PlayerVideo((continueWatchingList?[index].videoType ?? 0) == 2
                ? "Show"
                : "Video",(continueWatchingList?[index].videoType ?? 0) == 2
                ? (continueWatchingList?[index].showId ?? 0)
                : (continueWatchingList?[index].id ?? 0),continueWatchingList?[index].videoType ?? 0,continueWatchingList?[index].typeId,continueWatchingList?[index].channelId,continueWatchingList?[index].video320 ?? "",continueWatchingList?[index].stopTime,(continueWatchingList?[index].videoUploadType??""),continueWatchingList?[index].thumbnail);
            /*return Vlc(
              url: continueWatchingList?[index].video320 ?? "",
              playType: (continueWatchingList?[index].videoType ?? 0) == 2
                  ? "Show"
                  : "Video",
              stopTime: continueWatchingList?[index].stopTime ?? 0,
              videoId: (continueWatchingList?[index].videoType ?? 0) == 2
                  ? (continueWatchingList?[index].showId ?? 0)
                  : (continueWatchingList?[index].id ?? 0),
              videoType: continueWatchingList?[index].videoType ?? 0,
            );*/
            // return Vlc(continueWatchingList?[index].video320 ??
            //     "",(continueWatchingList?[index].videoType ?? 0) == 2 ? "Show" : "Video",);
            // return MyTvScreen(urlData:continueWatchingList?[index].video320 ?? "");
            // return ApinioPlayer(urlData:continueWatchingList?[index].video320 ?? "");
          }
        },
      ),
    );
    if (isContinues != null && isContinues == true) {
      getTabData(0);
      Future.delayed(Duration.zero).then((value) {
        if (!mounted) return;
        setState(() {});
      });
    }
/*    print("Data is: " + jsonEncode(continueWatchingList?[index].toJson()));

     var isContinues = await Utils.openPlayer(
      context: context,
      playType:
          (continueWatchingList?[index].videoType ?? 0) == 2 ? "Show" : "Video",
      videoId: (continueWatchingList?[index].videoType ?? 0) == 2
          ? (continueWatchingList?[index].showId ?? 0)
          : (continueWatchingList?[index].id ?? 0),
      videoType: continueWatchingList?[index].videoType ?? 0,
      typeId: continueWatchingList?[index].typeId ?? 0,
      otherId: continueWatchingList?[index].typeId ?? 0,
      videoUrl: continueWatchingList?[index].video320 ?? "",
      trailerUrl: continueWatchingList?[index].trailerUrl ?? "",
      uploadType: continueWatchingList?[index].videoUploadType ?? "",
      videoThumb: continueWatchingList?[index].landscape ?? "",
      vStopTime: continueWatchingList?[index].stopTime ?? 0,
    );
    if (isContinues != null && isContinues == true) {
      getTabData(0);
      Future.delayed(Duration.zero).then((value) {
        if (!mounted) return;
        setState(() {});
      });
    }*/
  }
/* ========= Open Player ========= */
}
