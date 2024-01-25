import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dtlive/model/sectiondetailmodel.dart';
import 'package:dtlive/pages/activetv.dart';
import 'package:dtlive/shimmer/shimmerutils.dart';
import 'package:dtlive/pages/tvmoviedetails.dart';
import 'package:dtlive/utils/dimens.dart';
import 'package:dtlive/widget/castcrew.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/moredetails.dart';
import 'package:dtlive/provider/episodeprovider.dart';
import 'package:dtlive/provider/showdetailsprovider.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/widget/episodebyseason.dart';
import 'package:dtlive/widget/myimage.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:dtlive/utils/strings.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/widget/mynetworkimg.dart';
import 'package:dtlive/widget/nodata.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class TVShowDetails extends StatefulWidget {
  final int videoId, upcomingType, videoType, typeId;
  const TVShowDetails(
      this.videoId, this.upcomingType, this.videoType, this.typeId,
      {Key? key})
      : super(key: key);

  @override
  State<TVShowDetails> createState() => TVShowDetailsState();
}

class TVShowDetailsState extends State<TVShowDetails> {
  String? audioLanguages;
  List<Cast>? directorList;
  late ShowDetailsProvider showDetailsProvider;
  late EpisodeProvider episodeProvider;

  @override
  void initState() {
    showDetailsProvider =
        Provider.of<ShowDetailsProvider>(context, listen: false);
    episodeProvider = Provider.of<EpisodeProvider>(context, listen: false);
    super.initState();
    log("initState videoId ==> ${widget.videoId}");
    log("initState upcomingType ==> ${widget.upcomingType}");
    log("initState videoType ==> ${widget.videoType}");
    log("initState typeId ==> ${widget.typeId}");
    _getData();
  }

  Future<void> _getData() async {
    Utils.getCurrencySymbol();
    await showDetailsProvider.getSectionDetails(
        widget.typeId, widget.videoType, widget.videoId, widget.upcomingType);
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    showDetailsProvider.clearProvider();
    episodeProvider.clearProvider();
  }

  Future<void> getAllEpisode(int position, List<Session>? seasonList) async {
    log("position ====> $position");
    log("seasonList seasonID ====> ${seasonList?[position].id}");
    await episodeProvider.getEpisodeBySeason(
        seasonList?[position].id ?? 0, widget.videoId);
    if (episodeProvider.episodeBySeasonModel.status == 200) {
      if (episodeProvider.episodeBySeasonModel.result != null) {
        debugPrint(
            "mCurrentEpiPos ====> ${showDetailsProvider.mCurrentEpiPos}");
        if (showDetailsProvider.mCurrentEpiPos == -1) {
          return;
        }
        /* Set-up Subtitle URLs */
        Utils.setSubtitleURLs(
          subtitleUrl1: (episodeProvider.episodeBySeasonModel
                  .result?[showDetailsProvider.mCurrentEpiPos].subtitle1 ??
              ""),
          subtitleUrl2: (episodeProvider.episodeBySeasonModel
                  .result?[showDetailsProvider.mCurrentEpiPos].subtitle2 ??
              ""),
          subtitleUrl3: (episodeProvider.episodeBySeasonModel
                  .result?[showDetailsProvider.mCurrentEpiPos].subtitle3 ??
              ""),
          subtitleLang1: (episodeProvider.episodeBySeasonModel
                  .result?[showDetailsProvider.mCurrentEpiPos].subtitleLang1 ??
              ""),
          subtitleLang2: (episodeProvider.episodeBySeasonModel
                  .result?[showDetailsProvider.mCurrentEpiPos].subtitleLang2 ??
              ""),
          subtitleLang3: (episodeProvider.episodeBySeasonModel
                  .result?[showDetailsProvider.mCurrentEpiPos].subtitleLang3 ??
              ""),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showDetailsProvider.sectionDetailModel.status == 200) {
      if (showDetailsProvider.sectionDetailModel.cast != null &&
          (showDetailsProvider.sectionDetailModel.cast?.length ?? 0) > 0) {
        directorList = <Cast>[];
        for (int i = 0;
            i < (showDetailsProvider.sectionDetailModel.cast?.length ?? 0);
            i++) {
          if (showDetailsProvider.sectionDetailModel.cast?[i].type ==
              "Director") {
            Cast cast = Cast();
            cast.id = showDetailsProvider.sectionDetailModel.cast?[i].id ?? 0;
            cast.name =
                showDetailsProvider.sectionDetailModel.cast?[i].name ?? "";
            cast.image =
                showDetailsProvider.sectionDetailModel.cast?[i].image ?? "";
            cast.type =
                showDetailsProvider.sectionDetailModel.cast?[i].type ?? "";
            cast.personalInfo =
                showDetailsProvider.sectionDetailModel.cast?[i].personalInfo ??
                    "";
            cast.status =
                showDetailsProvider.sectionDetailModel.cast?[i].status ?? 0;
            cast.createdAt =
                showDetailsProvider.sectionDetailModel.cast?[i].createdAt ?? "";
            cast.updatedAt =
                showDetailsProvider.sectionDetailModel.cast?[i].updatedAt ?? "";
            directorList?.add(cast);
          }
        }
      }
      if (showDetailsProvider.sectionDetailModel.language != null &&
          (showDetailsProvider.sectionDetailModel.language?.length ?? 0) > 0) {
        for (int i = 0;
            i < (showDetailsProvider.sectionDetailModel.language?.length ?? 0);
            i++) {
          if (i == 0) {
            audioLanguages =
                showDetailsProvider.sectionDetailModel.language?[i].name ?? "";
          } else {
            audioLanguages =
                "$audioLanguages, ${showDetailsProvider.sectionDetailModel.language?[i].name ?? ""}";
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
    if (showDetailsProvider.loading) {
      return SingleChildScrollView(
        child: ShimmerUtils.buildDetailWebShimmer(context, "show"),
      );
    } else {
      if (showDetailsProvider.sectionDetailModel.status == 200 &&
          showDetailsProvider.sectionDetailModel.result != null) {
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
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 30, bottom: 20),
          child: Column(
            children: [
              /* Poster */
              _buildPoster(),

              /* Included Features buttons */
              Container(
                alignment: Alignment.centerLeft,
                constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
                margin: const EdgeInsets.fromLTRB(12, 10, 0, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /* Continue Watching Button */
                      /* Watch Now button */
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

                      /* Watchlist */
                      if (widget.videoType != 5)
                        Container(
                          constraints: const BoxConstraints(minWidth: 50),
                          child: FocusBase(
                            onPressed: () async {
                              log("isBookmark ====> ${showDetailsProvider.sectionDetailModel.result?.isBookmark ?? 0}");
                              if (Constant.userID != null) {
                                await showDetailsProvider.setBookMark(
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
                            focusColor: gray.withOpacity(0.5),
                            onFocus: (isFocused) {},
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Consumer<ShowDetailsProvider>(
                                builder: (context, showDetailsProvider, child) {
                                  if ((showDetailsProvider.sectionDetailModel
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
                        showDetailsProvider.sectionDetailModel.moreDetails),
              ),

              /* Related */
              Container(
                margin: (kIsWeb || Constant.isTV)
                    ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                    : const EdgeInsets.all(0),
                child: Consumer<ShowDetailsProvider>(
                  builder: (context, showDetailsProvider, child) {
                    return _buildTabs();
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
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
                  imageUrl: showDetailsProvider
                              .sectionDetailModel.result?.landscape !=
                          ""
                      ? (showDetailsProvider
                              .sectionDetailModel.result?.landscape ??
                          "")
                      : (showDetailsProvider
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
                        text: showDetailsProvider
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
                          (showDetailsProvider.sectionDetailModel.result
                                          ?.releaseYear !=
                                      null &&
                                  showDetailsProvider.sectionDetailModel.result
                                          ?.releaseYear !=
                                      "")
                              ? Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: MyText(
                                    color: whiteLight,
                                    text: showDetailsProvider.sectionDetailModel
                                            .result?.releaseYear ??
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
                          (showDetailsProvider.sectionDetailModel.result
                                      ?.videoDuration !=
                                  null)
                              ? Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: MyText(
                                    color: otherColor,
                                    multilanguage: false,
                                    text: ((showDetailsProvider
                                                    .sectionDetailModel
                                                    .result
                                                    ?.videoDuration ??
                                                0) >
                                            0)
                                        ? Utils.convertTimeToText(
                                            showDetailsProvider
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
                          (showDetailsProvider.sectionDetailModel.result
                                          ?.maxVideoQuality !=
                                      null &&
                                  showDetailsProvider.sectionDetailModel.result
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
                                    text: showDetailsProvider.sectionDetailModel
                                            .result?.maxVideoQuality ??
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
                                "${showDetailsProvider.sectionDetailModel.result?.imdbRating ?? 0}",
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
                      if (showDetailsProvider
                                  .sectionDetailModel.result?.categoryName !=
                              null &&
                          showDetailsProvider
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
                                  text: showDetailsProvider.sectionDetailModel
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
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      /* Subtitle */
                      Consumer<EpisodeProvider>(
                        builder: (context, episodeProvider, child) {
                          if (Constant.subtitleUrls.isNotEmpty) {
                            return Container(
                              constraints: const BoxConstraints(minHeight: 0),
                              margin: const EdgeInsets.only(top: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),

                      /* Season Title */
                      if (widget.videoType != 5) const SizedBox(height: 10),
                      if (widget.videoType != 5) _buildSeasonBtn(),

                      /* Release Date */
                      _buildReleaseDate(),

                      /* Prime TAG */
                      (showDetailsProvider
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
                      (showDetailsProvider.sectionDetailModel.result?.isRent ??
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
                              showDetailsProvider
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

  Widget _buildSeasonBtn() {
    if (showDetailsProvider.sectionDetailModel.session != null &&
        (showDetailsProvider.sectionDetailModel.session?.length ?? 0) > 0) {
      return Consumer<ShowDetailsProvider>(
        builder: (context, showDetailsProvider, child) {
          return DropdownButtonHideUnderline(
            child: DropdownButton2(
              isDense: true,
              isExpanded: true,
              customButton: FittedBox(
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      MyText(
                        color: white,
                        text: showDetailsProvider.sectionDetailModel
                                .session?[showDetailsProvider.seasonPos].name ??
                            "",
                        textalign: TextAlign.center,
                        multilanguage: false,
                        fontweight: FontWeight.w700,
                        fontsizeNormal: 15,
                        fontsizeWeb: 16,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal,
                      ),
                      const SizedBox(width: 8),
                      MyImage(
                        width: 12,
                        height: 12,
                        imagePath: "ic_dropdown.png",
                        color: lightGray,
                      )
                    ],
                  ),
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                width: 180,
                useSafeArea: true,
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: Utils.setBackground(lightBlack, 5),
                elevation: 8,
              ),
              menuItemStyleData: MenuItemStyleData(
                overlayColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.focused)) {
                      return white.withOpacity(0.5);
                    }
                    return transparentColor;
                  },
                ),
              ),
              buttonStyleData: ButtonStyleData(
                decoration:
                    Utils.setBGWithBorder(transparentColor, white, 4, 1),
                overlayColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.focused)) {
                      return white.withOpacity(0.5);
                    }
                    if (states.contains(MaterialState.hovered)) {
                      return white.withOpacity(0.5);
                    }
                    return transparentColor;
                  },
                ),
              ),
              items: _buildWebDropDownItems(),
              onChanged: (Session? value) async {
                debugPrint("SeasonID ====> ${(value?.id ?? 0)}");
                int? mSeason;
                for (var i = 0;
                    i <
                        (showDetailsProvider
                                .sectionDetailModel.session?.length ??
                            0);
                    i++) {
                  if ((showDetailsProvider.sectionDetailModel.session?[i].id ??
                          0) ==
                      (value?.id ?? 0)) {
                    mSeason = i;
                  }
                }
                final detailsProvider =
                    Provider.of<ShowDetailsProvider>(context, listen: false);
                await detailsProvider
                    .setSeasonPosition(mSeason ?? (detailsProvider.seasonPos));
                debugPrint("seasonPos ====> ${detailsProvider.seasonPos}");
                await getAllEpisode(mSeason ?? (detailsProvider.seasonPos),
                    detailsProvider.sectionDetailModel.session);
              },
            ),
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  List<DropdownMenuItem<Session>>? _buildWebDropDownItems() {
    return showDetailsProvider.sectionDetailModel.session
        ?.map<DropdownMenuItem<Session>>(
      (Session value) {
        return DropdownMenuItem<Session>(
          value: value,
          alignment: Alignment.center,
          child: FittedBox(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 35, minWidth: 100),
              decoration: Utils.setBackground(
                showDetailsProvider.seasonPos != -1
                    ? ((showDetailsProvider
                                    .sectionDetailModel
                                    .session?[showDetailsProvider.seasonPos]
                                    .id ??
                                0) ==
                            (value.id ?? 0)
                        ? white
                        : transparentColor)
                    : transparentColor,
                4,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: MyText(
                color: showDetailsProvider.seasonPos != -1
                    ? ((showDetailsProvider
                                    .sectionDetailModel
                                    .session?[showDetailsProvider.seasonPos]
                                    .id ??
                                0) ==
                            (value.id ?? 0)
                        ? black
                        : white)
                    : white,
                multilanguage: false,
                text: (value.name.toString()),
                fontsizeNormal: 14,
                fontweight: FontWeight.w600,
                fontsizeWeb: 15,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal,
              ),
            ),
          ),
        );
      },
    ).toList();
  }

  Widget _buildRentBtn() {
    if ((showDetailsProvider.sectionDetailModel.result?.isPremium ?? 0) == 1 &&
        (showDetailsProvider.sectionDetailModel.result?.isRent ?? 0) == 1) {
      if ((showDetailsProvider.sectionDetailModel.result?.isBuy ?? 0) == 1 ||
          (showDetailsProvider.sectionDetailModel.result?.rentBuy ?? 0) == 1) {
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
                "Rent at just\n${Constant.currencySymbol}${showDetailsProvider.sectionDetailModel.result?.rentPrice ?? 0}",
            multilanguage: false,
          ),
        );
      }
    } else if ((showDetailsProvider.sectionDetailModel.result?.isRent ?? 0) ==
        1) {
      if ((showDetailsProvider.sectionDetailModel.result?.isBuy ?? 0) == 1 ||
          (showDetailsProvider.sectionDetailModel.result?.rentBuy ?? 0) == 1) {
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
                "Rent at just\n${Constant.currencySymbol}${showDetailsProvider.sectionDetailModel.result?.rentPrice ?? 0}",
            multilanguage: false,
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildReleaseDate() {
    if (widget.videoType == 5) {
      if (showDetailsProvider.sectionDetailModel.result?.releaseDate != null &&
          (showDetailsProvider.sectionDetailModel.result?.releaseDate ?? "") !=
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
                      showDetailsProvider
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
        child: Container(
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
          ),
        ),
      ),
    );
  }

  Widget _buildWatchNow() {
    return Consumer<EpisodeProvider>(
      builder: (context, episodeProvider, child) {
        if (showDetailsProvider.mCurrentEpiPos != -1 &&
            (episodeProvider.episodeBySeasonModel
                        .result?[showDetailsProvider.mCurrentEpiPos].stopTime ??
                    0) >
                0 &&
            episodeProvider
                    .episodeBySeasonModel
                    .result?[showDetailsProvider.mCurrentEpiPos]
                    .videoDuration !=
                null) {
          return Container(
            alignment: Alignment.centerLeft,
            child: FocusBase(
              onFocus: (isFocused) {},
              onPressed: () {
                openPlayer("Show");
              },
              focusColor: white,
              child: Container(
                padding: const EdgeInsets.only(top: 2.0),
                child: Container(
                  height: 60,
                  constraints: BoxConstraints(
                    maxWidth: (kIsWeb || Constant.isTV)
                        ? 250
                        : MediaQuery.of(context).size.width,
                  ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MyText(
                                    color: white,
                                    text:
                                        "Continue Watching Epi. ${(showDetailsProvider.mCurrentEpiPos + 1)}",
                                    multilanguage: false,
                                    textalign: TextAlign.start,
                                    fontsizeNormal: 13,
                                    fontsizeWeb: 13,
                                    fontweight: FontWeight.w700,
                                    maxline: 2,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal,
                                  ),
                                  Row(
                                    children: [
                                      MyText(
                                        color: white,
                                        text: Utils.remainTimeInMin(((episodeProvider
                                                        .episodeBySeasonModel
                                                        .result?[
                                                            showDetailsProvider
                                                                .mCurrentEpiPos]
                                                        .videoDuration ??
                                                    0) -
                                                (episodeProvider
                                                        .episodeBySeasonModel
                                                        .result?[
                                                            showDetailsProvider
                                                                .mCurrentEpiPos]
                                                        .stopTime ??
                                                    0))
                                            .abs()),
                                        textalign: TextAlign.start,
                                        fontsizeNormal: 10,
                                        fontsizeWeb: 12,
                                        multilanguage: false,
                                        fontweight: FontWeight.w500,
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
                                        fontsizeWeb: 12,
                                        multilanguage: true,
                                        fontweight: FontWeight.w500,
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
                              episodeProvider
                                      .episodeBySeasonModel
                                      .result?[
                                          showDetailsProvider.mCurrentEpiPos]
                                      .videoDuration ??
                                  0,
                              episodeProvider
                                      .episodeBySeasonModel
                                      .result?[
                                          showDetailsProvider.mCurrentEpiPos]
                                      .stopTime ??
                                  0),
                          backgroundColor: secProgressColor,
                          progressColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.centerLeft,
            child: FocusBase(
              onFocus: (isFocused) {},
              onPressed: () {
                openPlayer("Show");
              },
              focusColor: white,
              child: Container(
                padding: const EdgeInsets.only(top: 2.0),
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
                          text: "Watch Epi. 1",
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
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildTabs() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* Episodes START */
        if (showDetailsProvider.sectionDetailModel.session != null &&
            (showDetailsProvider.sectionDetailModel.session?.length ?? 0) > 0)
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            alignment: Alignment.bottomLeft,
            child: MyText(
              color: white,
              text: "episodes",
              multilanguage: true,
              textalign: TextAlign.center,
              fontsizeNormal: 15,
              fontsizeWeb: 16,
              maxline: 1,
              fontweight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
              fontstyle: FontStyle.normal,
            ),
          ),
        if (showDetailsProvider.sectionDetailModel.session != null &&
            (showDetailsProvider.sectionDetailModel.session?.length ?? 0) > 0)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(minHeight: 50),
            child: Consumer<EpisodeProvider>(
              builder: (context, episodeProvider, child) {
                return EpisodeBySeason(
                  widget.videoId,
                  widget.typeId,
                  showDetailsProvider.seasonPos,
                  showDetailsProvider.sectionDetailModel.session,
                  showDetailsProvider.sectionDetailModel.result,
                );
              },
            ),
          ),
        /* Episodes END */

        /* Customers also watched */
        if ((showDetailsProvider.sectionDetailModel.getRelatedVideo?.length ??
                0) >
            0)
          Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            margin: const EdgeInsets.only(top: 25, bottom: 0),
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
        if ((showDetailsProvider.sectionDetailModel.getRelatedVideo?.length ??
                0) >
            0)
          landscape(showDetailsProvider.sectionDetailModel.getRelatedVideo),

        /* Cast & Crew */
        if ((showDetailsProvider.sectionDetailModel.cast?.length ?? 0) > 0)
          CastCrew(castList: showDetailsProvider.sectionDetailModel.cast),
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
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: ((kIsWeb || Constant.isTV))
                ? Dimens.featureWebSize
                : Dimens.featureSize,
            height: ((kIsWeb || Constant.isTV))
                ? Dimens.featureWebSize
                : Dimens.featureSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: primaryLight,
              ),
              borderRadius: BorderRadius.circular((((kIsWeb || Constant.isTV))
                      ? Dimens.featureWebSize
                      : Dimens.featureSize) /
                  2),
            ),
            child: MyImage(
              width: ((kIsWeb || Constant.isTV))
                  ? Dimens.featureIconWebSize
                  : Dimens.featureIconSize,
              height: ((kIsWeb || Constant.isTV))
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
    log("mCurrentEpiPos ========> ${showDetailsProvider.mCurrentEpiPos}");

    /* CHECK SUBSCRIPTION */
    if (playType != "Trailer") {
      bool? isPrimiumUser = await _checkSubsRentLogin();
      log("isPrimiumUser =============> $isPrimiumUser");
      if (!isPrimiumUser) return;
    }
    /* CHECK SUBSCRIPTION */

    if ((episodeProvider.episodeBySeasonModel.result?.length ?? 0) > 0) {
      int? epiID = (episodeProvider.episodeBySeasonModel
              .result?[showDetailsProvider.mCurrentEpiPos].id ??
          0);
      int? showID = (episodeProvider.episodeBySeasonModel
              .result?[showDetailsProvider.mCurrentEpiPos].showId ??
          0);
      int? vType = widget.videoType;
      int? vTypeID = widget.typeId;
      int? stopTime;
      if (playType == "startOver" || playType == "Trailer") {
        stopTime = 0;
      } else {
        stopTime = (episodeProvider.episodeBySeasonModel
                .result?[showDetailsProvider.mCurrentEpiPos].stopTime ??
            0);
      }
      String? videoThumb = (episodeProvider.episodeBySeasonModel
              .result?[showDetailsProvider.mCurrentEpiPos].landscape ??
          "");
      log("epiID ========> $epiID");
      log("showID =======> $showID");
      log("vType ========> $vType");
      log("vTypeID ======> $vTypeID");
      log("stopTime =====> $stopTime");
      log("videoThumb ===> $videoThumb");

      String? vUrl, vUploadType;
      if (playType == "Trailer") {
        Utils.clearQualitySubtitle();
        vUploadType =
            (showDetailsProvider.sectionDetailModel.result?.trailerType ?? "");
        vUrl =
            (showDetailsProvider.sectionDetailModel.result?.trailerUrl ?? "");
      } else {
        /* Set-up Quality URLs */
        Utils.setQualityURLs(
          video320: (episodeProvider.episodeBySeasonModel
                  .result?[showDetailsProvider.mCurrentEpiPos].video320 ??
              ""),
          video480: (episodeProvider.episodeBySeasonModel
                  .result?[showDetailsProvider.mCurrentEpiPos].video480 ??
              ""),
          video720: (episodeProvider.episodeBySeasonModel
                  .result?[showDetailsProvider.mCurrentEpiPos].video720 ??
              ""),
          video1080: (episodeProvider.episodeBySeasonModel
                  .result?[showDetailsProvider.mCurrentEpiPos].video1080 ??
              ""),
        );

        vUrl = (episodeProvider.episodeBySeasonModel
                .result?[showDetailsProvider.mCurrentEpiPos].video320 ??
            "");
        vUploadType = (episodeProvider.episodeBySeasonModel
                .result?[showDetailsProvider.mCurrentEpiPos].videoUploadType ??
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

      if (!mounted) return;
      dynamic isContinue = await Utils.openPlayer(
        context: context,
        playType: playType == "Trailer" ? "Trailer" : "Show",
        videoId: epiID,
        videoType: vType,
        typeId: vTypeID,
        otherId: showID,
        videoUrl: vUrl,
        trailerUrl: vUrl,
        uploadType: vUploadType,
        videoThumb: videoThumb,
        vStopTime: stopTime,
      );

      log("isContinue ===> $isContinue");
      if (isContinue != null && isContinue == true) {
        await _getData();
        await getAllEpisode(showDetailsProvider.seasonPos,
            showDetailsProvider.sectionDetailModel.session);
      }
    } else {
      String? vUrl, vUploadType;
      if (playType == "Trailer") {
        int? stopTime = 0;
        String? videoThumb =
            (showDetailsProvider.sectionDetailModel.result?.landscape ?? "");
        log("stopTime =====> $stopTime");
        log("videoThumb ===> $videoThumb");
        Utils.clearQualitySubtitle();
        vUploadType =
            (showDetailsProvider.sectionDetailModel.result?.trailerType ?? "");
        vUrl =
            (showDetailsProvider.sectionDetailModel.result?.trailerUrl ?? "");

        log("vUploadType ===> $vUploadType");
        log("stopTime ===> $stopTime");

        if (!mounted) return;
        if (vUrl.isEmpty || vUrl == "") {
          Utils.showSnackbar(context, "info", "trailer_not_found", true);
          return;
        }

        if (!mounted) return;
        await Utils.openPlayer(
          context: context,
          playType: "Trailer",
          videoId: 0,
          videoType: 0,
          typeId: 0,
          otherId: 0,
          videoUrl: vUrl,
          trailerUrl: vUrl,
          uploadType: vUploadType,
          videoThumb: videoThumb,
          vStopTime: stopTime,
        );
      } else {
        if (!mounted) return;
        Utils.showSnackbar(context, "info", "episode_not_found", true);
      }
    }
  }
  /* ========= Open Player ========= */

  Future<bool> _checkSubsRentLogin() async {
    if (Constant.userID != null) {
      if ((showDetailsProvider.sectionDetailModel.result?.isPremium ?? 0) ==
              1 &&
          (showDetailsProvider.sectionDetailModel.result?.isRent ?? 0) == 1) {
        if ((showDetailsProvider.sectionDetailModel.result?.isBuy ?? 0) == 1 ||
            (showDetailsProvider.sectionDetailModel.result?.rentBuy ?? 0) ==
                1) {
          return true;
        } else {
          return false;
        }
      } else if ((showDetailsProvider.sectionDetailModel.result?.isPremium ??
              0) ==
          1) {
        if ((showDetailsProvider.sectionDetailModel.result?.isBuy ?? 0) == 1) {
          return true;
        } else {
          if ((kIsWeb || Constant.isTV)) {
            Utils.showSnackbar(context, "info", webPaymentNotAvailable, false);
            return false;
          }
          return false;
        }
      } else if ((showDetailsProvider.sectionDetailModel.result?.isRent ?? 0) ==
          1) {
        if ((showDetailsProvider.sectionDetailModel.result?.isBuy ?? 0) == 1 ||
            (showDetailsProvider.sectionDetailModel.result?.rentBuy ?? 0) ==
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
