import 'dart:developer';
import 'package:dtlive/pages/activetv.dart';
import 'package:dtlive/provider/homeprovider.dart';
import 'package:dtlive/shimmer/shimmerutils.dart';
import 'package:dtlive/pages/tvshowdetails.dart';
import 'package:dtlive/widget/castcrew.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/moredetails.dart';
import 'package:dtlive/widget/nodata.dart';
import 'package:flutter/foundation.dart';

import 'package:dtlive/model/sectiondetailmodel.dart';
import 'package:dtlive/utils/dimens.dart';
import 'package:dtlive/provider/videodetailsprovider.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/widget/myimage.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:dtlive/utils/strings.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/widget/mynetworkimg.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class TVMovieDetails extends StatefulWidget {
  final int videoId, upcomingType, videoType, typeId;
  const TVMovieDetails(
      this.videoId, this.upcomingType, this.videoType, this.typeId,
      {Key? key})
      : super(key: key);

  @override
  State<TVMovieDetails> createState() => TVMovieDetailsState();
}

class TVMovieDetailsState extends State<TVMovieDetails> {
  String? audioLanguages;
  List<Cast>? directorList;
  late VideoDetailsProvider videoDetailsProvider;
  late HomeProvider homeProvider;
  Map<String, String> qualityUrlList = <String, String>{};

  @override
  void initState() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    videoDetailsProvider =
        Provider.of<VideoDetailsProvider>(context, listen: false);
    super.initState();
    log("initState videoId ==> ${widget.videoId}");
    log("initState upcomingType ==> ${widget.upcomingType}");
    log("initState videoType ==> ${widget.videoType}");
    log("initState typeId ==> ${widget.typeId}");
    _getData();
  }

  _getData() async {
    Utils.getCurrencySymbol();
    await videoDetailsProvider.getSectionDetails(
        widget.typeId, widget.videoType, widget.videoId, widget.upcomingType);

    if (videoDetailsProvider.sectionDetailModel.status == 200) {
      if (videoDetailsProvider.sectionDetailModel.result != null) {
        /* Set-up Subtitle URLs */
        Utils.setSubtitleURLs(
          subtitleUrl1:
              (videoDetailsProvider.sectionDetailModel.result?.subtitle1 ?? ""),
          subtitleUrl2:
              (videoDetailsProvider.sectionDetailModel.result?.subtitle2 ?? ""),
          subtitleUrl3:
              (videoDetailsProvider.sectionDetailModel.result?.subtitle3 ?? ""),
          subtitleLang1:
              (videoDetailsProvider.sectionDetailModel.result?.subtitleLang1 ??
                  ""),
          subtitleLang2:
              (videoDetailsProvider.sectionDetailModel.result?.subtitleLang2 ??
                  ""),
          subtitleLang3:
              (videoDetailsProvider.sectionDetailModel.result?.subtitleLang3 ??
                  ""),
        );
      }
    }
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
    if (videoDetailsProvider.sectionDetailModel.status == 200) {
      if (videoDetailsProvider.sectionDetailModel.cast != null &&
          (videoDetailsProvider.sectionDetailModel.cast?.length ?? 0) > 0) {
        directorList = <Cast>[];
        for (int i = 0;
            i < (videoDetailsProvider.sectionDetailModel.cast?.length ?? 0);
            i++) {
          if (videoDetailsProvider.sectionDetailModel.cast?[i].type ==
              "Director") {
            Cast cast = Cast();
            cast.id = videoDetailsProvider.sectionDetailModel.cast?[i].id ?? 0;
            cast.name =
                videoDetailsProvider.sectionDetailModel.cast?[i].name ?? "";
            cast.image =
                videoDetailsProvider.sectionDetailModel.cast?[i].image ?? "";
            cast.type =
                videoDetailsProvider.sectionDetailModel.cast?[i].type ?? "";
            cast.personalInfo =
                videoDetailsProvider.sectionDetailModel.cast?[i].personalInfo ??
                    "";
            cast.status =
                videoDetailsProvider.sectionDetailModel.cast?[i].status ?? 0;
            cast.createdAt =
                videoDetailsProvider.sectionDetailModel.cast?[i].createdAt ??
                    "";
            cast.updatedAt =
                videoDetailsProvider.sectionDetailModel.cast?[i].updatedAt ??
                    "";
            directorList?.add(cast);
            log("directorList size ===> ${directorList?.length ?? 0}");
          }
        }
      }
      if (videoDetailsProvider.sectionDetailModel.language != null &&
          (videoDetailsProvider.sectionDetailModel.language?.length ?? 0) > 0) {
        for (int i = 0;
            i < (videoDetailsProvider.sectionDetailModel.language?.length ?? 0);
            i++) {
          if (i == 0) {
            audioLanguages =
                videoDetailsProvider.sectionDetailModel.language?[i].name ?? "";
          } else {
            audioLanguages =
                "$audioLanguages, ${videoDetailsProvider.sectionDetailModel.language?[i].name ?? ""}";
          }
        }
      }
    }
    return Scaffold(
      key: widget.key,
      backgroundColor: appBgColor,
      body: SafeArea(
        child: _buildUIWithAppBar(),
      ),
    );
  }

  Widget _buildUIWithAppBar() {
    if (videoDetailsProvider.loading) {
      return SingleChildScrollView(
        child: ShimmerUtils.buildDetailWebShimmer(context, "video"),
      );
    } else {
      if (videoDetailsProvider.sectionDetailModel.status == 200 &&
          videoDetailsProvider.sectionDetailModel.result != null) {
        return _buildTVWebData();
      } else {
        return const NoData(title: '', subTitle: '');
      }
    }
  }

  Widget _buildTVWebData() {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints.expand(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 30, bottom: 20),
        child: Column(
          children: [
            /* Poster */
            _buildPoster(),
            const SizedBox(height: 10),

            /* WatchNow & Feature buttons */
            Container(
              alignment: Alignment.centerLeft,
              constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
              margin: const EdgeInsets.fromLTRB(12, 10, 0, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /* WatchNow & ContinueWatching */
                    (widget.videoType == 5)
                        ? _buildWatchTrailer()
                        : _buildWatchNow(),
                    if (widget.videoType != 5) const SizedBox(width: 10),

                    /* Rent Button */
                    if (widget.videoType != 5)
                      Container(
                        constraints: const BoxConstraints(minWidth: 0),
                        child: _buildRentBtn(),
                      ),
                    if (widget.videoType != 5) const SizedBox(width: 10),

                    /* Trailer Button */
                    if (widget.videoType != 5)
                      Container(
                        constraints: const BoxConstraints(minWidth: 50),
                        child: FocusBase(
                          focusColor: gray.withOpacity(0.5),
                          onFocus: (isFocused) {},
                          onPressed: () {
                            openPlayer("Trailer");
                          },
                          child: _buildFeatureBtn(
                            icon: 'ic_borderplay.png',
                            title: 'trailer',
                            multilanguage: true,
                          ),
                        ),
                      ),
                    if (widget.videoType != 5) const SizedBox(width: 10),

                    /* StartOver Button */
                    if (widget.videoType != 5)
                      Container(
                        constraints: const BoxConstraints(minWidth: 50),
                        child: Consumer<VideoDetailsProvider>(
                          builder: (context, videoDetailsProvider, child) {
                            if ((videoDetailsProvider.sectionDetailModel.result
                                            ?.stopTime ??
                                        0) >
                                    0 &&
                                videoDetailsProvider.sectionDetailModel.result
                                        ?.videoDuration !=
                                    null) {
                              return FocusBase(
                                focusColor: gray.withOpacity(0.5),
                                onFocus: (isFocused) {},
                                onPressed: () {
                                  openPlayer("startOver");
                                },
                                child: _buildFeatureBtn(
                                  icon: 'ic_restart.png',
                                  title: 'startover',
                                  multilanguage: true,
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    if (widget.videoType != 5) const SizedBox(width: 10),

                    /* Watchlist */
                    if (widget.videoType != 5)
                      Container(
                        constraints: const BoxConstraints(minWidth: 50),
                        child: FocusBase(
                          focusColor: gray.withOpacity(0.5),
                          onFocus: (isFocused) {},
                          onPressed: () async {
                            log("isBookmark ====> ${videoDetailsProvider.sectionDetailModel.result?.isBookmark ?? 0}");
                            if (Constant.userID != null) {
                              await videoDetailsProvider.setBookMark(
                                context,
                                widget.typeId,
                                widget.videoType,
                                widget.videoId,
                              );
                            } else {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ActiveTV();
                                  },
                                ),
                              );
                            }
                          },
                          child: Consumer<VideoDetailsProvider>(
                            builder: (context, videoDetailsProvider, child) {
                              if ((videoDetailsProvider.sectionDetailModel
                                          .result?.isBookmark ??
                                      0) ==
                                  1) {
                                return _buildFeatureBtn(
                                  icon: 'watchlist_remove.png',
                                  title: 'watchlist',
                                  multilanguage: true,
                                );
                              } else {
                                return _buildFeatureBtn(
                                  icon: 'ic_plus.png',
                                  title: 'watchlist',
                                  multilanguage: true,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            /* More Details */
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: MoreDetails(
                  moreDetailList:
                      videoDetailsProvider.sectionDetailModel.moreDetails),
            ),

            /* Related */
            Container(
              margin: (kIsWeb || Constant.isTV)
                  ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                  : const EdgeInsets.all(0),
              child: Consumer<VideoDetailsProvider>(
                builder: (context, videoDetailsProvider, child) {
                  return _buildTabs();
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster() {
    return Container(
      constraints: BoxConstraints(
        minHeight: Dimens.detailWebPoster,
        minWidth: MediaQuery.of(context).size.width,
      ),
      child: Stack(
        children: [
          /* Poster */
          Row(
            children: [
              /* Space */
              Expanded(
                child: Container(
                  height: Dimens.detailWebPoster,
                ),
              ),

              /* Poster */
              Container(
                padding: const EdgeInsets.all(0.5),
                height: Dimens.detailWebPoster,
                width:
                    MediaQuery.of(context).size.width * Dimens.webBannerImgPr,
                child: MyNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: videoDetailsProvider
                              .sectionDetailModel.result?.landscape !=
                          ""
                      ? (videoDetailsProvider
                              .sectionDetailModel.result?.landscape ??
                          "")
                      : (videoDetailsProvider
                              .sectionDetailModel.result?.thumbnail ??
                          ""),
                ),
              ),
            ],
          ),

          /* Shadow */
          Row(
            children: [
              /* Space */
              Expanded(
                child: Container(
                  height: Dimens.detailWebPoster,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(0),
                height: Dimens.detailWebPoster,
                width:
                    MediaQuery.of(context).size.width * Dimens.webBannerImgPr,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width,
                      height: Dimens.detailWebPoster,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            appBgColor,
                            transparentColor,
                            transparentColor,
                            transparentColor,
                            transparentColor,
                            appBgColor,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width,
                      height: Dimens.detailWebPoster,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            appBgColor,
                            transparentColor,
                            transparentColor,
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
            ],
          ),

          /* Details */
          Row(
            children: [
              /* Details */
              Expanded(
                child: Container(
                  height: Dimens.detailWebPoster,
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(minHeight: 0),
                  padding:
                      const EdgeInsets.fromLTRB(20, kIsWeb ? 20 : 0, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (!kIsWeb)
                        FocusBase(
                          focusColor: white.withOpacity(0.5),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          onFocus: (isFocused) {},
                          child: Container(
                            width: 35,
                            height: 35,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            child: MyImage(
                              fit: BoxFit.contain,
                              imagePath: "back.png",
                            ),
                          ),
                        ),
                      MyText(
                        color: white,
                        text: videoDetailsProvider
                                .sectionDetailModel.result?.name ??
                            "",
                        textalign: TextAlign.start,
                        fontsizeNormal: 24,
                        fontsizeWeb: 24,
                        fontweight: FontWeight.w800,
                        maxline: 2,
                        multilanguage: false,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          /* Release Year */
                          (videoDetailsProvider.sectionDetailModel.result
                                          ?.releaseYear !=
                                      null &&
                                  videoDetailsProvider.sectionDetailModel.result
                                          ?.releaseYear !=
                                      "")
                              ? Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: MyText(
                                    color: whiteLight,
                                    text: videoDetailsProvider
                                            .sectionDetailModel
                                            .result
                                            ?.releaseYear ??
                                        "",
                                    textalign: TextAlign.center,
                                    fontsizeNormal: 13,
                                    fontsizeWeb: 13,
                                    fontweight: FontWeight.w700,
                                    multilanguage: false,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                  ),
                                )
                              : const SizedBox.shrink(),

                          /* Duration */
                          (videoDetailsProvider.sectionDetailModel.result
                                      ?.videoDuration !=
                                  null)
                              ? Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: MyText(
                                    color: otherColor,
                                    multilanguage: false,
                                    text: ((videoDetailsProvider
                                                    .sectionDetailModel
                                                    .result
                                                    ?.videoDuration ??
                                                0) >
                                            0)
                                        ? Utils.convertTimeToText(
                                            videoDetailsProvider
                                                    .sectionDetailModel
                                                    .result
                                                    ?.videoDuration ??
                                                0)
                                        : "",
                                    textalign: TextAlign.start,
                                    fontsizeNormal: 13,
                                    fontsizeWeb: 13,
                                    fontweight: FontWeight.w700,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                  ),
                                )
                              : const SizedBox.shrink(),

                          /* MaxQuality */
                          (videoDetailsProvider.sectionDetailModel.result
                                          ?.maxVideoQuality !=
                                      null &&
                                  videoDetailsProvider.sectionDetailModel.result
                                          ?.maxVideoQuality !=
                                      "")
                              ? Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 1, 5, 1),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: otherColor,
                                      width: .7,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: MyText(
                                    color: otherColor,
                                    text: videoDetailsProvider
                                            .sectionDetailModel
                                            .result
                                            ?.maxVideoQuality ??
                                        "",
                                    textalign: TextAlign.center,
                                    fontsizeNormal: 10,
                                    fontsizeWeb: 12,
                                    fontweight: FontWeight.w700,
                                    multilanguage: false,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                  ),
                                )
                              : const SizedBox.shrink(),

                          /* IMDb */
                          MyImage(
                            width: 40,
                            height: 15,
                            imagePath: "imdb.png",
                          ),
                          MyText(
                            color: otherColor,
                            text:
                                "${videoDetailsProvider.sectionDetailModel.result?.imdbRating ?? 0}",
                            textalign: TextAlign.start,
                            fontsizeNormal: 14,
                            fontsizeWeb: 14,
                            fontweight: FontWeight.w600,
                            multilanguage: false,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            fontstyle: FontStyle.normal,
                          ),
                          /* IMDb */
                        ],
                      ),

                      /* Category */
                      if (videoDetailsProvider
                                  .sectionDetailModel.result?.categoryName !=
                              null &&
                          videoDetailsProvider
                                  .sectionDetailModel.result?.categoryName !=
                              "")
                        Container(
                          constraints: const BoxConstraints(minHeight: 0),
                          margin: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              MyText(
                                color: whiteLight,
                                text: "category",
                                textalign: TextAlign.center,
                                fontsizeNormal: 13,
                                fontweight: FontWeight.w600,
                                fontsizeWeb: 13,
                                maxline: 1,
                                multilanguage: true,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal,
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                color: whiteLight,
                                text: ":",
                                textalign: TextAlign.center,
                                fontsizeNormal: 13,
                                fontweight: FontWeight.w600,
                                fontsizeWeb: 13,
                                maxline: 1,
                                multilanguage: false,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: MyText(
                                  color: white,
                                  text: videoDetailsProvider.sectionDetailModel
                                          .result?.categoryName ??
                                      "",
                                  textalign: TextAlign.start,
                                  fontsizeNormal: 13,
                                  fontsizeWeb: 13,
                                  fontweight: FontWeight.w600,
                                  multilanguage: false,
                                  maxline: 5,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ),

                      /* Language */
                      Container(
                        constraints: const BoxConstraints(minHeight: 0),
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              color: whiteLight,
                              text: "language_",
                              textalign: TextAlign.center,
                              fontsizeNormal: 13,
                              fontweight: FontWeight.w600,
                              fontsizeWeb: 13,
                              maxline: 1,
                              multilanguage: true,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal,
                            ),
                            const SizedBox(width: 5),
                            MyText(
                              color: whiteLight,
                              text: ":",
                              textalign: TextAlign.center,
                              fontsizeNormal: 13,
                              fontweight: FontWeight.w600,
                              fontsizeWeb: 13,
                              maxline: 1,
                              multilanguage: false,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: MyText(
                                color: white,
                                text: audioLanguages ?? "",
                                textalign: TextAlign.start,
                                fontsizeNormal: 13,
                                fontweight: FontWeight.w600,
                                fontsizeWeb: 13,
                                multilanguage: false,
                                maxline: 5,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      /* Subtitle */
                      Constant.subtitleUrls.isNotEmpty
                          ? Container(
                              constraints: const BoxConstraints(minHeight: 0),
                              margin: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  MyText(
                                    color: whiteLight,
                                    text: "subtitle",
                                    textalign: TextAlign.center,
                                    fontsizeNormal: 13,
                                    fontweight: FontWeight.w600,
                                    fontsizeWeb: 13,
                                    maxline: 1,
                                    multilanguage: true,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                  ),
                                  const SizedBox(width: 5),
                                  MyText(
                                    color: whiteLight,
                                    text: ":",
                                    textalign: TextAlign.center,
                                    fontsizeNormal: 13,
                                    fontweight: FontWeight.w600,
                                    fontsizeWeb: 13,
                                    maxline: 1,
                                    multilanguage: false,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: MyText(
                                      color: white,
                                      text: "Available",
                                      textalign: TextAlign.start,
                                      fontsizeNormal: 13,
                                      fontweight: FontWeight.w600,
                                      fontsizeWeb: 13,
                                      maxline: 1,
                                      multilanguage: false,
                                      overflow: TextOverflow.ellipsis,
                                      fontstyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),

                      /* Release Date */
                      _buildReleaseDate(),

                      /* Prime TAG */
                      (videoDetailsProvider
                                      .sectionDetailModel.result?.isPremium ??
                                  0) ==
                              1
                          ? Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  MyText(
                                    color: primaryColor,
                                    text: "primetag",
                                    textalign: TextAlign.start,
                                    fontsizeNormal: 12,
                                    fontsizeWeb: 12,
                                    fontweight: FontWeight.w700,
                                    multilanguage: true,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                  ),
                                  const SizedBox(height: 2),
                                  MyText(
                                    color: white,
                                    text: "primetagdesc",
                                    multilanguage: true,
                                    textalign: TextAlign.center,
                                    fontsizeNormal: 12,
                                    fontsizeWeb: 12,
                                    fontweight: FontWeight.w500,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),

                      /* Rent TAG */
                      (videoDetailsProvider.sectionDetailModel.result?.isRent ??
                                  0) ==
                              1
                          ? Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: complimentryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                    ),
                                    alignment: Alignment.center,
                                    child: MyText(
                                      color: white,
                                      text: Constant.currencySymbol,
                                      textalign: TextAlign.center,
                                      fontsizeNormal: 11,
                                      fontsizeWeb: 11,
                                      fontweight: FontWeight.w700,
                                      multilanguage: false,
                                      maxline: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontstyle: FontStyle.normal,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    child: MyText(
                                      color: white,
                                      text: "renttag",
                                      textalign: TextAlign.center,
                                      fontsizeNormal: 12,
                                      fontsizeWeb: 13,
                                      multilanguage: true,
                                      fontweight: FontWeight.w500,
                                      maxline: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontstyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),

                      /* Description */
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 15, bottom: 8),
                            child: ExpandableText(
                              videoDetailsProvider
                                      .sectionDetailModel.result?.description ??
                                  "",
                              animation: true,
                              textAlign: TextAlign.start,
                              expandOnTextTap: true,
                              collapseOnTextTap: true,
                              expandText: "",
                              maxLines: 10,
                              linkColor: primaryColor,
                              style: TextStyle(
                                fontSize: (kIsWeb || Constant.isTV) ? 13 : 13,
                                fontStyle: FontStyle.normal,
                                color: white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /* Space */
              Container(
                padding: const EdgeInsets.all(0),
                height: Dimens.detailWebPoster,
                width: MediaQuery.of(context).size.width *
                    (Dimens.webBannerImgPr - 0.10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReleaseDate() {
    if (widget.videoType == 5) {
      if (videoDetailsProvider.sectionDetailModel.result?.releaseDate != null &&
          (videoDetailsProvider.sectionDetailModel.result?.releaseDate ?? "") !=
              "") {
        return Container(
          margin: EdgeInsets.fromLTRB(
              (kIsWeb || Constant.isTV) ? 0 : 20, 20, 20, 0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              MyText(
                color: white,
                text: "release_date",
                multilanguage: true,
                textalign: TextAlign.start,
                fontsizeNormal: 14,
                fontsizeWeb: 15,
                fontweight: FontWeight.w500,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                fontstyle: FontStyle.normal,
              ),
              const SizedBox(width: 5),
              MyText(
                color: white,
                text: ":",
                multilanguage: false,
                textalign: TextAlign.start,
                fontsizeNormal: 14,
                fontsizeWeb: 15,
                fontweight: FontWeight.w500,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                fontstyle: FontStyle.normal,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: MyText(
                  color: complimentryColor,
                  text: DateFormat("dd MMM, yyyy").format(DateTime.parse(
                      videoDetailsProvider
                              .sectionDetailModel.result?.releaseDate ??
                          "")),
                  multilanguage: false,
                  textalign: TextAlign.start,
                  fontsizeNormal: 14,
                  fontsizeWeb: 15,
                  fontweight: FontWeight.w700,
                  maxline: 2,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildWatchTrailer() {
    return Container(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          openPlayer("Trailer");
        },
        focusColor: white,
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: 55,
            constraints: BoxConstraints(
              maxWidth: (kIsWeb || Constant.isTV)
                  ? 190
                  : MediaQuery.of(context).size.width,
            ),
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
            decoration: BoxDecoration(
              color: primaryDark,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyImage(
                  width: 18,
                  height: 18,
                  imagePath: "ic_play.png",
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: MyText(
                    color: white,
                    text: "watch_trailer",
                    multilanguage: true,
                    textalign: TextAlign.start,
                    fontsizeNormal: 15,
                    fontweight: FontWeight.w600,
                    fontsizeWeb: 16,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    fontstyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWatchNow() {
    if ((videoDetailsProvider.sectionDetailModel.result?.stopTime ?? 0) > 0 &&
        videoDetailsProvider.sectionDetailModel.result?.videoDuration != null) {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
        width: 220,
        child: FocusBase(
          focusColor: white,
          onFocus: (isFocused) {},
          onPressed: () async {
            print("I am in wright place vUploadType");
            openPlayer("Video");
          },
          child: Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
            decoration: BoxDecoration(
              color: primaryDark,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      MyImage(
                        width: 18,
                        height: 18,
                        imagePath: "ic_play.png",
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyText(
                              color: white,
                              text: "continuewatching",
                              multilanguage: true,
                              textalign: TextAlign.start,
                              fontsizeNormal: 13,
                              fontsizeWeb: 13,
                              fontweight: FontWeight.w700,
                              maxline: 1,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal,
                            ),
                            Row(
                              children: [
                                MyText(
                                  color: white,
                                  text: Utils.remainTimeInMin(
                                      ((videoDetailsProvider.sectionDetailModel
                                                      .result?.videoDuration ??
                                                  0) -
                                              (videoDetailsProvider
                                                      .sectionDetailModel
                                                      .result
                                                      ?.stopTime ??
                                                  0))
                                          .abs()),
                                  textalign: TextAlign.start,
                                  fontsizeNormal: 10,
                                  fontweight: FontWeight.w500,
                                  fontsizeWeb: 12,
                                  multilanguage: false,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal,
                                ),
                                const SizedBox(width: 5),
                                MyText(
                                  color: white,
                                  text: "left",
                                  textalign: TextAlign.start,
                                  fontsizeNormal: 10,
                                  fontweight: FontWeight.w500,
                                  fontsizeWeb: 12,
                                  multilanguage: true,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                Container(
                  height: 4,
                  constraints: const BoxConstraints(minWidth: 0),
                  margin: const EdgeInsets.all(3),
                  child: LinearPercentIndicator(
                    padding: const EdgeInsets.all(0),
                    barRadius: const Radius.circular(2),
                    lineHeight: 4,
                    percent: Utils.getPercentage(
                        videoDetailsProvider
                                .sectionDetailModel.result?.videoDuration ??
                            0,
                        videoDetailsProvider
                                .sectionDetailModel.result?.stopTime ??
                            0),
                    backgroundColor: secProgressColor,
                    progressColor: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
        width: 220,
        child: FocusBase(
          focusColor: white,
          onFocus: (isFocused) {},
          onPressed: () async {
            openPlayer("Video");
          },
          child: Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
            decoration: BoxDecoration(
              color: primaryDark,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyImage(
                  width: 18,
                  height: 18,
                  imagePath: "ic_play.png",
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: MyText(
                    color: white,
                    text: "watch_now",
                    multilanguage: true,
                    textalign: TextAlign.start,
                    fontsizeNormal: 15,
                    fontweight: FontWeight.w600,
                    fontsizeWeb: 16,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    fontstyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildRentBtn() {
    if ((videoDetailsProvider.sectionDetailModel.result?.isPremium ?? 0) == 1 &&
        (videoDetailsProvider.sectionDetailModel.result?.isRent ?? 0) == 1) {
      if ((videoDetailsProvider.sectionDetailModel.result?.isBuy ?? 0) == 1 ||
          (videoDetailsProvider.sectionDetailModel.result?.rentBuy ?? 0) == 1) {
        return const SizedBox.shrink();
      } else {
        return FocusBase(
          focusColor: gray.withOpacity(0.5),
          onFocus: (isFocused) {},
          onPressed: () async {
            if (Constant.userID != null) {
              if ((kIsWeb || Constant.isTV)) {
                Utils.showSnackbar(
                    context, "info", webPaymentNotAvailable, false);
                return;
              }
              dynamic isRented = await Utils.paymentForRent(
                context: context,
                videoId: videoDetailsProvider.sectionDetailModel.result?.id
                        .toString() ??
                    '',
                rentPrice: videoDetailsProvider
                        .sectionDetailModel.result?.rentPrice
                        .toString() ??
                    '',
                vTitle: videoDetailsProvider.sectionDetailModel.result?.name
                        .toString() ??
                    '',
                typeId: videoDetailsProvider.sectionDetailModel.result?.typeId
                        .toString() ??
                    '',
                vType: videoDetailsProvider.sectionDetailModel.result?.videoType
                        .toString() ??
                    '',
              );
              if (isRented != null && isRented == true) {
                _getData();
              }
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ActiveTV();
                  },
                ),
              );
            }
          },
          child: _buildFeatureBtn(
            icon: 'ic_store.png',
            title:
                "Rent at just\n${Constant.currencySymbol}${videoDetailsProvider.sectionDetailModel.result?.rentPrice ?? 0}",
            multilanguage: false,
          ),
        );
      }
    } else if ((videoDetailsProvider.sectionDetailModel.result?.isRent ?? 0) ==
        1) {
      if ((videoDetailsProvider.sectionDetailModel.result?.isBuy ?? 0) == 1 ||
          (videoDetailsProvider.sectionDetailModel.result?.rentBuy ?? 0) == 1) {
        return const SizedBox.shrink();
      } else {
        return FocusBase(
          focusColor: gray.withOpacity(0.5),
          onFocus: (isFocused) {},
          onPressed: () async {
            if (Constant.userID != null) {
              if ((kIsWeb || Constant.isTV)) {
                Utils.showSnackbar(
                    context, "info", webPaymentNotAvailable, false);
                return;
              }
              dynamic isRented = await Utils.paymentForRent(
                context: context,
                videoId: videoDetailsProvider.sectionDetailModel.result?.id
                        .toString() ??
                    '',
                rentPrice: videoDetailsProvider
                        .sectionDetailModel.result?.rentPrice
                        .toString() ??
                    '',
                vTitle: videoDetailsProvider.sectionDetailModel.result?.name
                        .toString() ??
                    '',
                typeId: videoDetailsProvider.sectionDetailModel.result?.typeId
                        .toString() ??
                    '',
                vType: videoDetailsProvider.sectionDetailModel.result?.videoType
                        .toString() ??
                    '',
              );
              if (isRented != null && isRented == true) {
                _getData();
              }
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ActiveTV();
                  },
                ),
              );
            }
          },
          child: _buildFeatureBtn(
            icon: 'ic_store.png',
            title:
                "Rent at just\n${Constant.currencySymbol}${videoDetailsProvider.sectionDetailModel.result?.rentPrice ?? 0}",
            multilanguage: false,
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildTabs() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* Customers also watched */
        if ((videoDetailsProvider.sectionDetailModel.getRelatedVideo?.length ??
                0) >
            0)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: MyText(
              color: white,
              text: "customer_also_watch",
              multilanguage: true,
              textalign: TextAlign.start,
              fontsizeNormal: 15,
              fontweight: FontWeight.w600,
              fontsizeWeb: 16,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              fontstyle: FontStyle.normal,
            ),
          ),
        /* video_type =>  1-video,  2-show,  3-language,  4-category */
        /* screen_layout =>  landscape, potrait, square */
        if ((videoDetailsProvider.sectionDetailModel.getRelatedVideo?.length ??
                0) >
            0)
          landscape(videoDetailsProvider.sectionDetailModel.getRelatedVideo),

        /* Cast & Crew */
        if ((videoDetailsProvider.sectionDetailModel.cast?.length ?? 0) > 0)
          CastCrew(castList: videoDetailsProvider.sectionDetailModel.cast),
      ],
    );
  }

  Widget landscape(List<GetRelatedVideo>? relatedDataList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Dimens.heightLand,
      margin: const EdgeInsets.only(top: 12),
      child: ListView.separated(
        itemCount: relatedDataList?.length ?? 0,
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 0),
        itemBuilder: (BuildContext context, int index) {
          return FocusBase(
            onFocus: (isFocused) {},
            focusColor: white,
            onPressed: () async {
              log("Clicked on index ==> $index");
              if ((relatedDataList?[index].videoType ?? 0) == 5) {
                if ((relatedDataList?[index].upcomingType ?? 0) == 1) {
                  if (!(context.mounted)) return;
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TVMovieDetails(
                          relatedDataList?[index].id ?? 0,
                          relatedDataList?[index].upcomingType ?? 0,
                          relatedDataList?[index].videoType ?? 0,
                          relatedDataList?[index].typeId ?? 0,
                        );
                      },
                    ),
                  );
                } else if ((relatedDataList?[index].upcomingType ?? 0) == 2) {
                  if (!(context.mounted)) return;
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TVShowDetails(
                          relatedDataList?[index].id ?? 0,
                          relatedDataList?[index].upcomingType ?? 0,
                          relatedDataList?[index].videoType ?? 0,
                          relatedDataList?[index].typeId ?? 0,
                        );
                      },
                    ),
                  );
                }
              } else {
                if ((relatedDataList?[index].videoType ?? 0) == 1) {
                  if (!(context.mounted)) return;
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TVMovieDetails(
                          relatedDataList?[index].id ?? 0,
                          relatedDataList?[index].upcomingType ?? 0,
                          relatedDataList?[index].videoType ?? 0,
                          relatedDataList?[index].typeId ?? 0,
                        );
                      },
                    ),
                  );
                } else if ((relatedDataList?[index].videoType ?? 0) == 2) {
                  if (!(context.mounted)) return;
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TVShowDetails(
                          relatedDataList?[index].id ?? 0,
                          relatedDataList?[index].upcomingType ?? 0,
                          relatedDataList?[index].videoType ?? 0,
                          relatedDataList?[index].typeId ?? 0,
                        );
                      },
                    ),
                  );
                }
              }
            },
            child: Container(
              width: Dimens.widthLand,
              height: Dimens.heightLand,
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: MyNetworkImage(
                  imageUrl: relatedDataList?[index].landscape.toString() ?? "",
                  fit: BoxFit.cover,
                  imgHeight: MediaQuery.of(context).size.height,
                  imgWidth: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureBtn({
    required String title,
    required String icon,
    required bool multilanguage,
  }) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: (kIsWeb || Constant.isTV)
                ? Dimens.featureWebSize
                : Dimens.featureSize,
            height: (kIsWeb || Constant.isTV)
                ? Dimens.featureWebSize
                : Dimens.featureSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: primaryLight,
              ),
              borderRadius: BorderRadius.circular(((kIsWeb || Constant.isTV)
                      ? Dimens.featureWebSize
                      : Dimens.featureSize) /
                  2),
            ),
            child: MyImage(
              width: (kIsWeb || Constant.isTV)
                  ? Dimens.featureIconWebSize
                  : Dimens.featureIconSize,
              height: (kIsWeb || Constant.isTV)
                  ? Dimens.featureIconWebSize
                  : Dimens.featureIconSize,
              color: lightGray,
              imagePath: icon,
            ),
          ),
          const SizedBox(height: 5),
          MyText(
            color: white,
            text: title,
            multilanguage: multilanguage,
            fontsizeNormal: 10,
            fontsizeWeb: 14,
            fontweight: FontWeight.w600,
            maxline: 2,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
          ),
        ],
      ),
    );
  }

  /* ========= Open Player ========= */
  openPlayer(String playType) async {
    /* CHECK SUBSCRIPTION */
    if (playType != "Trailer") {
      bool? isPrimiumUser = await _checkSubsRentLogin();
      log("isPrimiumUser =============> $isPrimiumUser");
      if (!isPrimiumUser) return;
    }
    /* CHECK SUBSCRIPTION */
    log("ID :===> ${(videoDetailsProvider.sectionDetailModel.result?.id ?? 0)}");

    int? vID = (videoDetailsProvider.sectionDetailModel.result?.id ?? 0);
    int? vType =
        (videoDetailsProvider.sectionDetailModel.result?.videoType ?? 0);
    int? vTypeID = widget.typeId;

    int? stopTime;
    if (playType == "startOver" || playType == "Trailer") {
      stopTime = 0;
    } else {
      stopTime =
          (videoDetailsProvider.sectionDetailModel.result?.stopTime ?? 0);
    }

    String? videoThumb =
        (videoDetailsProvider.sectionDetailModel.result?.landscape ?? "");

    String? vUrl, vUploadType;
    if (playType == "Trailer") {
      Utils.clearQualitySubtitle();
      vUploadType =
          (videoDetailsProvider.sectionDetailModel.result?.trailerType ?? "");
      vUrl = (videoDetailsProvider.sectionDetailModel.result?.trailerUrl ?? "");
    } else {
      /* Set-up Quality URLs */
      Utils.setQualityURLs(
        video320:
            (videoDetailsProvider.sectionDetailModel.result?.video320 ?? ""),
        video480:
            (videoDetailsProvider.sectionDetailModel.result?.video480 ?? ""),
        video720:
            (videoDetailsProvider.sectionDetailModel.result?.video720 ?? ""),
        video1080:
            (videoDetailsProvider.sectionDetailModel.result?.video1080 ?? ""),
      );

      vUrl = (videoDetailsProvider.sectionDetailModel.result?.video320 ?? "");
      vUploadType =
          (videoDetailsProvider.sectionDetailModel.result?.videoUploadType ??
              "");
    }

    debugPrint("vUploadType => $vUploadType");
    debugPrint("vUrl ========> $vUrl");
    debugPrint("stopTime ====> $stopTime");

    if (!mounted) return;
    if (vUrl.isEmpty || vUrl == "") {
      if (playType == "Trailer") {
        Utils.showSnackbar(context, "info", "trailer_not_found", true);
      } else {
        Utils.showSnackbar(context, "info", "video_not_found", true);
      }
      return;
    }

    dynamic isContinue = await Utils.openPlayer(
      context: context,
      playType: playType == "Trailer" ? "Trailer" : "Video",
      videoId: vID,
      videoType: vType,
      typeId: vTypeID,
      otherId: 0,
      videoUrl: vUrl,
      trailerUrl: vUrl,
      uploadType: vUploadType,
      videoThumb: videoThumb,
      vStopTime: stopTime,
    );

    log("isContinue ===> $isContinue");
    if (isContinue != null && isContinue == true) {
      _getData();
    }
  }
  /* ========= Open Player ========= */

  Future<bool> _checkSubsRentLogin() async {
    if (Constant.userID != null) {
      if ((videoDetailsProvider.sectionDetailModel.result?.isPremium ?? 0) ==
              1 &&
          (videoDetailsProvider.sectionDetailModel.result?.isRent ?? 0) == 1) {
        if ((videoDetailsProvider.sectionDetailModel.result?.isBuy ?? 0) == 1 ||
            (videoDetailsProvider.sectionDetailModel.result?.rentBuy ?? 0) ==
                1) {
          return true;
        } else {
          if ((kIsWeb || Constant.isTV)) {
            Utils.showSnackbar(context, "info", webPaymentNotAvailable, false);
            return false;
          }
          return false;
        }
      } else if ((videoDetailsProvider.sectionDetailModel.result?.isPremium ??
              0) ==
          1) {
        if ((videoDetailsProvider.sectionDetailModel.result?.isBuy ?? 0) == 1) {
          return true;
        } else {
          if ((kIsWeb || Constant.isTV)) {
            Utils.showSnackbar(context, "info", webPaymentNotAvailable, false);
            return false;
          }
          return false;
        }
      } else if ((videoDetailsProvider.sectionDetailModel.result?.isRent ??
              0) ==
          1) {
        if ((videoDetailsProvider.sectionDetailModel.result?.isBuy ?? 0) == 1 ||
            (videoDetailsProvider.sectionDetailModel.result?.rentBuy ?? 0) ==
                1) {
          return true;
        } else {
          if ((kIsWeb || Constant.isTV)) {
            Utils.showSnackbar(context, "info", webPaymentNotAvailable, false);
            return false;
          }
          return false;
        }
      } else {
        return true;
      }
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const ActiveTV();
          },
        ),
      );
      return false;
    }
  }
}
