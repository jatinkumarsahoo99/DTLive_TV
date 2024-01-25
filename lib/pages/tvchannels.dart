import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dtlive/model/channelsectionmodel.dart' as list;
import 'package:dtlive/model/channelsectionmodel.dart' as banner;
import 'package:dtlive/pages/player_pod.dart';
import 'package:dtlive/pages/player_vimeo.dart';
import 'package:dtlive/shimmer/shimmerutils.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/utils/dimens.dart';
import 'package:dtlive/utils/strings.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/landscapelist.dart';
import 'package:dtlive/widget/nodata.dart';
import 'package:dtlive/pages/player_youtube.dart';
import 'package:dtlive/provider/channelsectionprovider.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/widget/mynetworkimg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

import '../widget/tvchannellist.dart';

class TVChannels extends StatefulWidget {
  const TVChannels({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  State<TVChannels> createState() => TVChannelsState();
}

class TVChannelsState extends State<TVChannels> {
  late ChannelSectionProvider channelSectionProvider;
  CarouselController pageController = CarouselController();

  @override
  void initState() {
    channelSectionProvider =
        Provider.of<ChannelSectionProvider>(context, listen: false);
    super.initState();
    _getData();
  }

  _getData() async {
    await channelSectionProvider.getChannelSection();
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
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
        child: _buildChannelPage(),
      ),
    );
  }

  Widget _buildChannelPage() {
    if (channelSectionProvider.loading) {
      return SingleChildScrollView(
        child: channelShimmer(),
      );
    } else {
      if (channelSectionProvider.channelSectionModel.status == 200) {
        return SingleChildScrollView(
          child: Column(
            children: [
              /* Banner */
              (channelSectionProvider.channelSectionModel.liveUrl != null)
                  ? _webChannelBanner(
                      channelSectionProvider.channelSectionModel.liveUrl)
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),

              /* Remaining Data */
              (channelSectionProvider.channelSectionModel.result != null)
                  ? setSectionByType(
                      channelSectionProvider.channelSectionModel.result)
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
            ],
          ),
        );
      } else {
        return const NoData(title: '', subTitle: '');
      }
    }
  }

  /* Section Shimmer */
  Widget channelShimmer() {
    return Column(
      children: [
        /* Banner */
        ShimmerUtils.channelBannerWeb(context),

        /* Remaining Sections */
        ListView.builder(
          itemCount: 10, // itemCount must be greater than 5
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return ShimmerUtils.setChannelSections(context, "landscape");
          },
        ),
      ],
    );
  }

  Widget _webChannelBanner(List<banner.LiveUrl>? sectionBannerList) {
    if ((sectionBannerList?.length ?? 0) > 0) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: Dimens.channelWebBanner,
        child: CarouselSlider.builder(
          itemCount: (sectionBannerList?.length ?? 0),
          carouselController: pageController,
          options: CarouselOptions(
            initialPage: 0,
            height: Dimens.channelWebBanner,
            enlargeCenterPage: false,
            autoPlay: true,
            autoPlayCurve: Curves.easeInOutQuart,
            enableInfiniteScroll: true,
            autoPlayInterval: Duration(milliseconds: Constant.bannerDuration),
            autoPlayAnimationDuration:
                Duration(milliseconds: Constant.animationDuration),
            viewportFraction: 0.95,
            onPageChanged: (val, _) async {
              await channelSectionProvider.setCurrentBanner(val);
            },
          ),
          itemBuilder: (BuildContext context, int index, int pageViewIndex) {
            return Container(
              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: FocusBase(
                focusColor: white,
                onPressed: () {
                  debugPrint("Clicked on index ==> $index");
                  openPlayer(sectionBannerList, index);
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
                        height: Dimens.channelWebBanner,
                        child: MyNetworkImage(
                          imageUrl: sectionBannerList?[index].image ?? "",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width,
                        height: Dimens.channelWebBanner,
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
                        height: Dimens.channelWebBanner,
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
                              child: MyText(
                                color: white,
                                text: sectionBannerList?[index].name ?? "",
                                textalign: TextAlign.start,
                                fontsizeNormal: 14,
                                fontweight: FontWeight.w700,
                                fontsizeWeb: 25,
                                multilanguage: false,
                                maxline: 2,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal,
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

  Widget setSectionByType(List<list.Result>? sectionList) {
    return ListView.separated(
      itemCount: sectionList?.length ?? 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (BuildContext context, int index) {
        if (sectionList?[index].data != null &&
            (sectionList?[index].data?.length ?? 0) > 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: MyText(
                  color: otherColor,
                  text: sectionList?[index].title.toString() ?? "",
                  textalign: TextAlign.center,
                  fontsizeNormal: 10,
                  fontsizeWeb: 14,
                  multilanguage: false,
                  maxline: 1,
                  fontweight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: MyText(
                  color: white,
                  text: sectionList?[index].title.toString() ?? "",
                  textalign: TextAlign.center,
                  fontsizeNormal: 15,
                  fontsizeWeb: 18,
                  multilanguage: false,
                  maxline: 1,
                  fontweight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: Dimens.heightLand-50,
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
    print("Section type:${sectionList?[index].videoType.toString()}");
    print("Sanjaya Test:${sectionList?[index].videoType.toString()}");
    return TvChannelList(
      sectionDataList: sectionList?[index].data,
      sectionPos: index,
      dataFrom: 'Channel',
      dataType: 'Section',
      typeId: sectionList?[index].typeId ?? 0,
      controller: widget._controller,
    );
   /* if ((sectionList?[index].videoType ?? 0) == 1 ||
        (sectionList?[index].videoType ?? 0) == 2) {
      return LandscapeList(
        sectionDataList: sectionList?[index].data,
        sectionPos: index,
        dataFrom: 'Channel',
        dataType: 'Section',
        typeId: sectionList?[index].typeId ?? 0,
        controller: widget._controller,
      );
    } else if ((sectionList?[index].videoType ?? 0) == 3) {
      return LandscapeList(
        sectionDataList: sectionList?[index].data,
        sectionPos: index,
        dataFrom: 'Channel',
        dataType: 'ByLanguage',
        typeId: sectionList?[index].typeId ?? 0,
        controller: widget._controller,
      );
    } else if ((sectionList?[index].videoType ?? 0) == 4) {
      return LandscapeList(
        sectionDataList: sectionList?[index].data,
        sectionPos: index,
        dataFrom: 'Channel',
        dataType: 'ByLanguage',
        typeId: sectionList?[index].typeId ?? 0,
        controller: widget._controller,
      );
    } else {
      return LandscapeList(
        sectionDataList: sectionList?[index].data,
        sectionPos: index,
        dataFrom: 'Channel',
        dataType: 'ByCategory',
        typeId: sectionList?[index].typeId ?? 0,
        controller: widget._controller,
      );
    }*/
  }

  /* ========= Open Player ========= */
  openPlayer(List<banner.LiveUrl>? sectionBannerList, int index) async {
    if (Constant.userID != null) {
      if ((sectionBannerList?[index].link ?? "").isNotEmpty) {
        if ((sectionBannerList?[index].isBuy ?? 0) == 1) {
          if (kIsWeb) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  if ((sectionBannerList?[index].link ?? "")
                      .contains("youtube")) {
                    return PlayerYoutube(
                      "Channel",
                      0,
                      0,
                      0,
                      0,
                      sectionBannerList?[index].link ?? "",
                      0,
                      "",
                      sectionBannerList?[index].image ?? "",
                    );
                  } else {
                    return PlayerPod(
                      "Channel",
                      0,
                      0,
                      0,
                      0,
                      sectionBannerList?[index].link ?? "",
                      0,
                      "",
                      sectionBannerList?[index].image ?? "",
                    );
                  }
                },
              ),
            );
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  if ((sectionBannerList?[index].link ?? "")
                      .contains("youtube")) {
                    return PlayerYoutube(
                      "Channel",
                      0,
                      0,
                      0,
                      0,
                      sectionBannerList?[index].link ?? "",
                      0,
                      "",
                      sectionBannerList?[index].image ?? "",
                    );
                  } else if ((sectionBannerList?[index].link ?? "")
                      .contains("vimeo")) {
                    return PlayerVimeo(
                      "Channel",
                      0,
                      0,
                      0,
                      0,
                      sectionBannerList?[index].link ?? "",
                      0,
                      "",
                      sectionBannerList?[index].image ?? "",
                    );
                  } else {
                    return PlayerPod(
                      "Channel",
                      0,
                      0,
                      0,
                      0,
                      sectionBannerList?[index].link ?? "",
                      0,
                      "",
                      sectionBannerList?[index].image ?? "",
                    );
                  }
                },
              ),
            );
          }
        } else {
          if (kIsWeb || Constant.isTV) {
            Utils.showSnackbar(context, "info", webPaymentNotAvailable, false);
            return;
          }
        }
      } else {
        if (!mounted) return;
        Utils.showSnackbar(context, "fail", "invalid_url", true);
      }
    } else {
      widget._controller.selectIndex(8);
    }
  }
  /* ========= Open Player ========= */
}
