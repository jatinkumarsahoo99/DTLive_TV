import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/dimens.dart';
import 'package:dtlive/shimmer/shimmerwidget.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class ShimmerUtils {
  static Widget buildHomeMobileShimmer(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Container(
        //   constraints: const BoxConstraints(maxWidth: 90),
        //   height: MediaQuery.of(context).size.height,
        //   child: AlignedGridView.count(
        //     shrinkWrap: true,
        //     crossAxisCount: 1,
        //     crossAxisSpacing: 8,
        //     mainAxisSpacing: 25,
        //     itemCount: 7,
        //     padding: const EdgeInsets.only(left: 6, top: 6, right: 6),
        //     physics: const AlwaysScrollableScrollPhysics(),
        //     scrollDirection: Axis.vertical,
        //     itemBuilder: (BuildContext context, int position) {
        //       return Container(
        //         constraints: const BoxConstraints(maxHeight: 32),
        //         alignment: Alignment.center,
        //         padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
        //         decoration: Utils.setBackground(shimmerItemColor, 4),
        //         child: const ShimmerWidget.roundrectborder(
        //           height: 15,
        //           shimmerBgColor: black,
        //           shapeBorder: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.all(Radius.circular(5))),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        // Container(
        //   width: 2.0,
        //   decoration: Utils.setBackground(dotsDefaultColor, 5.0),
        // ),
        Expanded(
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    bannerWeb(context),
                    ListView.builder(
                      itemCount: 10, // itemCount must be greater than 5
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return setHomeSections(context, "landscape");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget bannerMobile(context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: Dimens.homeBanner,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: Dimens.homeBanner,
                child: ShimmerWidget.roundcorner(
                  height: Dimens.homeBanner,
                  shapeBorder: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                height: Dimens.homeBanner,
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
        Positioned(
          bottom: 0,
          child: CarouselIndicator(
            count: 6,
            index: 1,
            space: 8,
            height: 8,
            width: 8,
            cornerRadius: 4,
            color: dotsDefaultColor,
            activeColor: dotsActiveColor,
          ),
        ),
      ],
    );
  }

  static Widget bannerWeb(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Dimens.homeWebBanner,
      margin: const EdgeInsets.fromLTRB(20, 2, 20, 7),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          color: shimmerItemColor,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: Dimens.homeWebBanner,
            child: ShimmerWidget.roundcorner(
              height: Dimens.homeWebBanner,
              shimmerBgColor: shimmerItemColor,
              shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          ),
        ),
      ),
    );
  }

  static Widget channelBannerMobile(context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: Dimens.channelBanner,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: Dimens.channelBanner,
                child: ShimmerWidget.roundcorner(
                  height: Dimens.channelBanner,
                  shapeBorder: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                height: Dimens.channelBanner,
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
        Positioned(
          bottom: 0,
          child: CarouselIndicator(
            count: 6,
            index: 1,
            space: 8,
            height: 8,
            width: 8,
            cornerRadius: 4,
            color: dotsDefaultColor,
            activeColor: dotsActiveColor,
          ),
        ),
      ],
    );
  }

  static Widget channelBannerWeb(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Dimens.channelWebBanner,
      margin: const EdgeInsets.fromLTRB(27, 2, 27, 7),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          color: shimmerItemColor,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: Dimens.channelWebBanner,
            child: ShimmerWidget.roundcorner(
              height: Dimens.channelWebBanner,
              shimmerBgColor: shimmerItemColor,
              shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          ),
        ),
      ),
    );
  }

  static Widget continueWatching(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
          child: ShimmerWidget.roundrectborder(
            height: 15,
            width: 100,
            shimmerBgColor: shimmerItemColor,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: Dimens.heightLand,
          child: ListView.separated(
            itemCount: kIsWeb ? 6 : 3,
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 30, right: 20),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Container(
                    width: Dimens.widthLand,
                    height: Dimens.heightLand,
                    alignment: Alignment.center,
                    child: ShimmerWidget.roundcorner(
                      width: Dimens.widthLand,
                      height: Dimens.heightLand,
                      shimmerBgColor: shimmerItemColor,
                      shapeBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 8),
                        child: ShimmerWidget.circular(
                          width: 30,
                          height: 30,
                          shimmerBgColor: black,
                        ),
                      ),
                      Container(
                        width: Dimens.widthLand,
                        constraints: const BoxConstraints(minWidth: 0),
                        padding: const EdgeInsets.all(3),
                        child: ShimmerWidget.roundcorner(
                          width: Dimens.widthLand,
                          height: 4,
                          shimmerBgColor: black,
                          shapeBorder: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  static Widget setHomeSections(context, String layoutType) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ShimmerWidget.roundrectborder(
            height: 15,
            width: 100,
            shimmerBgColor: shimmerItemColor,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 12),
        if (layoutType == "landscape") landscapeListView(context),
        if (layoutType == "potrait") portraitListView(context),
        if (layoutType == "square") squareListView(context),
        if (layoutType == "langGen") langGenListView(context),
      ],
    );
  }

  static Widget setChannelSections(context, String layoutType) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 25),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ShimmerWidget.roundrectborder(
            height: 10,
            width: 60,
            shimmerBgColor: shimmerItemColor,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 2),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ShimmerWidget.roundrectborder(
            height: 15,
            width: 100,
            shimmerBgColor: shimmerItemColor,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 12),
        if (layoutType == "landscape") landscapeListView(context),
        if (layoutType == "potrait") portraitListView(context),
        if (layoutType == "square") squareListView(context),
        if (layoutType == "langGen") langGenListView(context),
      ],
    );
  }

  static Widget buildRentShimmer(context, double itemHeight, double itemWidth) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 30,
          padding: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.centerLeft,
          child: const Row(
            children: [
              ShimmerWidget.circular(
                height: 20,
                width: 20,
                shimmerBgColor: shimmerItemColor,
              ),
              SizedBox(width: 8),
              ShimmerWidget.roundrectborder(
                height: 18,
                width: 80,
                shimmerBgColor: shimmerItemColor,
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              SizedBox(width: 5),
              ShimmerWidget.roundrectborder(
                height: 13,
                width: 50,
                shimmerBgColor: shimmerItemColor,
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        normalHorizontalGrid(context, itemHeight, itemWidth, 3),
        const SizedBox(height: 22),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 30,
          padding: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.centerLeft,
          child: const Row(
            children: [
              ShimmerWidget.circular(
                height: 20,
                width: 20,
                shimmerBgColor: shimmerItemColor,
              ),
              SizedBox(width: 8),
              ShimmerWidget.roundrectborder(
                height: 18,
                width: 80,
                shimmerBgColor: shimmerItemColor,
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              SizedBox(width: 5),
              ShimmerWidget.roundrectborder(
                height: 13,
                width: 50,
                shimmerBgColor: shimmerItemColor,
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        normalHorizontalGrid(context, itemHeight, itemWidth, 3),
        const SizedBox(height: 20),
      ],
    );
  }

  static Widget buildFindShimmer(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* Browse by START */
        Container(
          width: 120,
          padding: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.centerLeft,
          child: const ShimmerWidget.roundrectborder(
            height: 20,
            shimmerBgColor: shimmerItemColor,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 10),
        normalVerticalGrid(
            context, 65, (MediaQuery.of(context).size.width / 2), 2, 6),
        /* Browse by END */
        const SizedBox(height: 22),

        /* Genres START */
        Container(
          width: 120,
          padding: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.centerLeft,
          child: const ShimmerWidget.roundrectborder(
            height: 20,
            shimmerBgColor: shimmerItemColor,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 15),
        normalVerticalGrid(
            context, 47, MediaQuery.of(context).size.width, 1, 5),
        Container(
          height: 30,
          padding: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.centerLeft,
          child: const ShimmerWidget.roundrectborder(
            height: 30,
            width: 80,
            shimmerBgColor: shimmerItemColor,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        /* Genres END */
        const SizedBox(height: 30),

        /* Language START */
        Container(
          width: 120,
          padding: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.centerLeft,
          child: const ShimmerWidget.roundrectborder(
            height: 20,
            shimmerBgColor: shimmerItemColor,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 15),
        normalVerticalGrid(
            context, 47, MediaQuery.of(context).size.width, 1, 5),
        Container(
          height: 30,
          padding: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.centerLeft,
          child: const ShimmerWidget.roundrectborder(
            height: 30,
            width: 80,
            shimmerBgColor: shimmerItemColor,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        /* Language END */
      ],
    );
  }

  static Widget landscapeListView(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: Dimens.heightLand,
      child: ListView.separated(
        itemCount: kIsWeb ? 20 : 10,
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 20, right: 20),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: Dimens.widthLand,
            height: Dimens.heightLand,
            alignment: Alignment.center,
            child: ShimmerWidget.roundcorner(
              height: Dimens.heightLand,
              shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          );
        },
      ),
    );
  }

  static Widget portraitListView(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: Dimens.heightPort,
      child: ListView.separated(
        itemCount: kIsWeb ? 20 : 10,
        shrinkWrap: true,
        physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.only(left: 20, right: 20),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 5),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: Dimens.widthPort,
            height: Dimens.heightPort,
            alignment: Alignment.center,
            child: ShimmerWidget.roundcorner(
              height: Dimens.heightPort,
              shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          );
        },
      ),
    );
  }

  static Widget squareListView(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: Dimens.heightSquare,
      child: ListView.separated(
        itemCount: kIsWeb ? 20 : 10,
        shrinkWrap: true,
        physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.only(left: 20, right: 20),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 5),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: Dimens.widthSquare,
            height: Dimens.heightSquare,
            alignment: Alignment.center,
            child: ShimmerWidget.roundcorner(
              height: Dimens.heightSquare,
              shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          );
        },
      ),
    );
  }

  static Widget langGenListView(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: Dimens.heightLangGen,
      child: ListView.separated(
        itemCount: kIsWeb ? 20 : 10,
        shrinkWrap: true,
        physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.only(left: 20, right: 20),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 5),
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: Dimens.widthLangGen,
            height: Dimens.heightLangGen,
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  width: Dimens.widthLangGen,
                  height: Dimens.heightLangGen,
                  alignment: Alignment.center,
                  child: ShimmerWidget.roundcorner(
                    height: Dimens.heightLangGen,
                    shapeBorder: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(3),
                  child: ShimmerWidget.roundrectborder(
                    height: 10,
                    shimmerBgColor: black,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2))),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget normalHorizontalGrid(
      context, double itemHeight, double itemWidth, int crossAxisCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      height: itemHeight * crossAxisCount,
      child: AlignedGridView.count(
        shrinkWrap: true,
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        itemCount: kIsWeb ? 40 : 20,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int position) {
          return Container(
            width: itemWidth,
            height: itemHeight,
            alignment: Alignment.center,
            child: ShimmerWidget.roundcorner(
              height: itemHeight,
              shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          );
        },
      ),
    );
  }

  static Widget normalVerticalGrid(context, double itemHeight, double itemWidth,
      int crossAxisCount, int itemCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: AlignedGridView.count(
        shrinkWrap: true,
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        itemCount: kIsWeb ? (itemCount + 10) : itemCount,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          return Container(
            width: itemWidth,
            height: itemHeight,
            alignment: Alignment.center,
            child: ShimmerWidget.roundcorner(
              height: itemHeight,
              shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          );
        },
      ),
    );
  }

  static Widget responsiveGrid(context, double itemHeight, double itemWidth,
      int minCrossCount, int itemCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: ResponsiveGridList(
        minItemWidth: itemWidth,
        verticalGridSpacing: 8,
        horizontalGridSpacing: 8,
        minItemsPerRow: minCrossCount,
        maxItemsPerRow: 8,
        listViewBuilderOptions: ListViewBuilderOptions(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        children: List.generate(
          itemCount,
          (position) {
            return Container(
              width: itemWidth,
              height: itemHeight,
              alignment: Alignment.center,
              child: ShimmerWidget.roundcorner(
                height: itemHeight,
                shapeBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget buildDetailMobileShimmer(context, String detailType) {
    return Column(
      children: [
        /* Poster */
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width,
              height: kIsWeb ? Dimens.detailWebPoster : Dimens.detailPoster,
              child: ShimmerWidget.roundcorner(
                height: kIsWeb ? Dimens.detailWebPoster : Dimens.detailPoster,
                shapeBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0))),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width,
              height: kIsWeb ? Dimens.detailWebPoster : Dimens.detailPoster,
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
            const ShimmerWidget.circular(
              height: 60,
              width: 60,
              shimmerBgColor: black,
            ),
          ],
        ),

        /* Other Details */
        Container(
          transform: Matrix4.translationValues(0, -kToolbarHeight, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* Small Poster, Main title, ReleaseYear, Duration, Age Restriction, Video Quality */
              Container(
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(minHeight: 85),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 65,
                      height: 85,
                      alignment: Alignment.centerLeft,
                      child: const ShimmerWidget.roundcorner(
                        width: 65,
                        height: 85,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ShimmerWidget.roundrectborder(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            shimmerBgColor: shimmerItemColor,
                            shapeBorder: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const ShimmerWidget.roundrectborder(
                                  height: 15,
                                  width: 80,
                                  shimmerBgColor: shimmerItemColor,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const ShimmerWidget.roundrectborder(
                                  height: 15,
                                  width: 80,
                                  shimmerBgColor: shimmerItemColor,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: const ShimmerWidget.roundrectborder(
                              height: 15,
                              width: 80,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              /* Season Title */
              if (detailType == "show")
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: const SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        ShimmerWidget.roundrectborder(
                          height: 18,
                          width: 100,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        SizedBox(width: 5),
                        ShimmerWidget.circular(
                          height: 12,
                          width: 12,
                          shimmerBgColor: shimmerItemColor,
                        ),
                      ],
                    ),
                  ),
                ),

              /* Prime TAG */
              Container(
                margin: const EdgeInsets.only(top: 11),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ShimmerWidget.roundrectborder(
                      height: 18,
                      width: 100,
                      shimmerBgColor: shimmerItemColor,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    SizedBox(height: 2),
                    ShimmerWidget.roundrectborder(
                      height: 13,
                      width: 150,
                      shimmerBgColor: shimmerItemColor,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ],
                ),
              ),

              /* Rent TAG */
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: const Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ShimmerWidget.circular(
                      height: 20,
                      width: 20,
                      shimmerBgColor: shimmerItemColor,
                    ),
                    ShimmerWidget.roundrectborder(
                      height: 16,
                      width: 100,
                      shimmerBgColor: shimmerItemColor,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ],
                ),
              ),

              /* Continue Watching Button */
              /* Watch Now button */
              if (!kIsWeb)
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  child: ShimmerWidget.roundrectborder(
                    height: kIsWeb ? 40 : 55,
                    width: MediaQuery.of(context).size.width,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),

              /* Included Features buttons */
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: kIsWeb
                      ? (MediaQuery.of(context).size.width / 2)
                      : MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(minHeight: 0),
                  margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* Rent Button */
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: kIsWeb
                                  ? Dimens.featureWebSize
                                  : Dimens.featureSize,
                              height: kIsWeb
                                  ? Dimens.featureWebSize
                                  : Dimens.featureSize,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: shimmerItemColor),
                                borderRadius: BorderRadius.circular((kIsWeb
                                        ? Dimens.featureWebSize
                                        : Dimens.featureSize) /
                                    2),
                              ),
                              child: ShimmerWidget.circular(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                shimmerBgColor: shimmerItemColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ShimmerWidget.circular(
                              height: kIsWeb
                                  ? Dimens.featureIconWebSize
                                  : Dimens.featureIconSize,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),

                      /* Start Over & Trailer */
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: kIsWeb
                                  ? Dimens.featureWebSize
                                  : Dimens.featureSize,
                              height: kIsWeb
                                  ? Dimens.featureWebSize
                                  : Dimens.featureSize,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: shimmerItemColor),
                                borderRadius: BorderRadius.circular((kIsWeb
                                        ? Dimens.featureWebSize
                                        : Dimens.featureSize) /
                                    2),
                              ),
                              child: ShimmerWidget.circular(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                shimmerBgColor: shimmerItemColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ShimmerWidget.circular(
                              height: kIsWeb
                                  ? Dimens.featureIconWebSize
                                  : Dimens.featureIconSize,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),

                      /* Download */
                      if (!kIsWeb)
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: kIsWeb
                                    ? Dimens.featureWebSize
                                    : Dimens.featureSize,
                                height: kIsWeb
                                    ? Dimens.featureWebSize
                                    : Dimens.featureSize,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: shimmerItemColor),
                                  borderRadius: BorderRadius.circular((kIsWeb
                                          ? Dimens.featureWebSize
                                          : Dimens.featureSize) /
                                      2),
                                ),
                                child: ShimmerWidget.circular(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  shimmerBgColor: shimmerItemColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ShimmerWidget.circular(
                                height: kIsWeb
                                    ? Dimens.featureIconWebSize
                                    : Dimens.featureIconSize,
                                shimmerBgColor: shimmerItemColor,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 5),

                      /* Watchlist */
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: kIsWeb
                                  ? Dimens.featureWebSize
                                  : Dimens.featureSize,
                              height: kIsWeb
                                  ? Dimens.featureWebSize
                                  : Dimens.featureSize,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: shimmerItemColor),
                                borderRadius: BorderRadius.circular((kIsWeb
                                        ? Dimens.featureWebSize
                                        : Dimens.featureSize) /
                                    2),
                              ),
                              child: ShimmerWidget.circular(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                shimmerBgColor: shimmerItemColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ShimmerWidget.circular(
                              height: kIsWeb
                                  ? Dimens.featureIconWebSize
                                  : Dimens.featureIconSize,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),

                      /* More */
                      if (!kIsWeb)
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: kIsWeb
                                    ? Dimens.featureWebSize
                                    : Dimens.featureSize,
                                height: kIsWeb
                                    ? Dimens.featureWebSize
                                    : Dimens.featureSize,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: shimmerItemColor),
                                  borderRadius: BorderRadius.circular((kIsWeb
                                          ? Dimens.featureWebSize
                                          : Dimens.featureSize) /
                                      2),
                                ),
                                child: ShimmerWidget.circular(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  shimmerBgColor: shimmerItemColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ShimmerWidget.circular(
                                height: kIsWeb
                                    ? Dimens.featureIconWebSize
                                    : Dimens.featureIconSize,
                                shimmerBgColor: shimmerItemColor,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              /* Description, IMDb, Languages & Subtitles */
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: const ShimmerWidget.roundrectborder(
                        height: 16,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: const ShimmerWidget.roundrectborder(
                        height: 16,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: const ShimmerWidget.roundrectborder(
                        height: 16,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: const ShimmerWidget.roundrectborder(
                        height: 16,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ShimmerWidget.roundrectborder(
                          height: 25,
                          width: 80,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        SizedBox(width: 5),
                        ShimmerWidget.roundrectborder(
                          height: 15,
                          width: 80,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      constraints: const BoxConstraints(minHeight: 30),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ShimmerWidget.roundrectborder(
                            height: 16,
                            width: 100,
                            shimmerBgColor: shimmerItemColor,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: ShimmerWidget.roundrectborder(
                              height: 15,
                              width: 100,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(minHeight: 30),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ShimmerWidget.roundrectborder(
                            height: 16,
                            width: 100,
                            shimmerBgColor: shimmerItemColor,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: ShimmerWidget.roundrectborder(
                              height: 15,
                              width: 100,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /* Related ~ More Details */
              Container(
                constraints: BoxConstraints(
                  maxWidth: kIsWeb
                      ? (MediaQuery.of(context).size.width * 0.5)
                      : MediaQuery.of(context).size.width,
                ),
                margin: kIsWeb
                    ? const EdgeInsets.fromLTRB(20, 0, 20, 0)
                    : const EdgeInsets.all(0),
                height: kIsWeb ? 35 : Dimens.detailTabs,
                child: Row(
                  children: [
                    /* Related */
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                              child: const ShimmerWidget.roundrectborder(
                                height: 18,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                          ),
                          Container(
                            height: 2,
                            color: shimmerItemColor,
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /* More Details */
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: const ShimmerWidget.roundrectborder(
                          height: 18,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.5,
                color: shimmerItemColor,
                constraints: BoxConstraints(
                  maxWidth: kIsWeb
                      ? (MediaQuery.of(context).size.width * 0.5)
                      : MediaQuery.of(context).size.width,
                ),
              ),
              if (detailType == "show") Container(),
              const SizedBox(height: 25),
              Container(
                width: 100,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: const ShimmerWidget.roundrectborder(
                  height: 18,
                  width: 100,
                  shimmerBgColor: shimmerItemColor,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
              const SizedBox(height: 12),
              landscapeListView(context),
              const SizedBox(height: 25),
              Container(
                width: 100,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                alignment: Alignment.centerLeft,
                child: const ShimmerWidget.roundrectborder(
                  height: 18,
                  width: 100,
                  shimmerBgColor: shimmerItemColor,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const ShimmerWidget.roundrectborder(
                        height: 18,
                        width: 100,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                      decoration: BoxDecoration(
                        border: Border.all(color: shimmerItemColor, width: .7),
                        borderRadius: BorderRadius.circular(4),
                        shape: BoxShape.rectangle,
                      ),
                      child: ShimmerWidget.roundrectborder(
                        height: 18,
                        width: MediaQuery.of(context).size.width,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              responsiveGrid(
                context,
                kIsWeb ? Dimens.heightCastWeb : Dimens.heightCast,
                kIsWeb ? Dimens.widthCastWeb : Dimens.widthCast,
                3,
                6,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildDetailWebShimmer(context, String detailType) {
    return Column(
      children: [
        /* Poster */
        Container(
          padding: const EdgeInsets.all(0),
          height: Dimens.detailWebPoster,
          width: MediaQuery.of(context)
              .size
              .width /*  * (Dimens.webBannerImgPr) */,
          child: ShimmerWidget.roundrectborder(
            height: Dimens.detailWebPoster,
            shimmerBgColor: shimmerItemColor,
            shapeBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 10),

        /* Other Details */
        /* Related ~ More Details */
        Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(
            maxWidth: kIsWeb
                ? (MediaQuery.of(context).size.width * 0.5)
                : MediaQuery.of(context).size.width,
          ),
          margin: kIsWeb
              ? const EdgeInsets.fromLTRB(20, 0, 20, 0)
              : const EdgeInsets.all(0),
          height: kIsWeb ? 35 : Dimens.detailTabs,
          child: Row(
            children: [
              /* Related */
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: const ShimmerWidget.roundrectborder(
                          height: 18,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                      ),
                    ),
                    Container(
                      height: 2,
                      color: shimmerItemColor,
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ],
                ),
              ),
              /* More Details */
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: const ShimmerWidget.roundrectborder(
                    height: 18,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 0.5,
          color: shimmerItemColor,
          constraints: BoxConstraints(
            maxWidth: kIsWeb
                ? (MediaQuery.of(context).size.width * 0.5)
                : MediaQuery.of(context).size.width,
          ),
        ),
        if (detailType == "show") Container(),
        const SizedBox(height: 25),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 100,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: const ShimmerWidget.roundrectborder(
              height: 18,
              width: 100,
              shimmerBgColor: shimmerItemColor,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
          ),
        ),
        const SizedBox(height: 12),
        landscapeListView(context),
        const SizedBox(height: 25),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 100,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            alignment: Alignment.centerLeft,
            child: const ShimmerWidget.roundrectborder(
              height: 18,
              width: 100,
              shimmerBgColor: shimmerItemColor,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: const ShimmerWidget.roundrectborder(
                  height: 18,
                  width: 100,
                  shimmerBgColor: shimmerItemColor,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
              Container(
                width: 100,
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                decoration: BoxDecoration(
                  border: Border.all(color: shimmerItemColor, width: .7),
                  borderRadius: BorderRadius.circular(4),
                  shape: BoxShape.rectangle,
                ),
                child: ShimmerWidget.roundrectborder(
                  height: 18,
                  width: MediaQuery.of(context).size.width,
                  shimmerBgColor: shimmerItemColor,
                  shapeBorder: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        responsiveGrid(
          context,
          kIsWeb ? Dimens.heightCastWeb : Dimens.heightCast,
          kIsWeb ? Dimens.widthCastWeb : Dimens.widthCast,
          3,
          10,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  static Widget buildWatchlistShimmer(context, int itemCount) {
    return AlignedGridView.count(
      shrinkWrap: true,
      crossAxisCount: 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 8,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kIsWeb ? (itemCount + 10) : itemCount,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(minHeight: Dimens.heightWatchlist),
          color: shimmerItemColor,
          child: Row(
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: Dimens.heightWatchlist,
                  maxWidth: MediaQuery.of(context).size.width * 0.44,
                ),
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.44,
                      height: Dimens.heightWatchlist,
                      alignment: Alignment.center,
                      child: ShimmerWidget.roundcorner(
                        width: MediaQuery.of(context).size.width,
                        height: Dimens.heightWatchlist,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 8),
                          child: ShimmerWidget.circular(
                            width: 30,
                            height: 30,
                            shimmerBgColor: black,
                          ),
                        ),
                        Container(
                          width: Dimens.widthContiLand,
                          constraints: const BoxConstraints(minWidth: 0),
                          padding: const EdgeInsets.all(3),
                          child: ShimmerWidget.roundcorner(
                            width: Dimens.widthContiLand,
                            height: 4,
                            shimmerBgColor: black,
                            shapeBorder: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: Dimens.heightWatchlist,
                    maxWidth: MediaQuery.of(context).size.width * 0.66,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /* Title */
                            const ShimmerWidget.roundrectborder(
                              height: 18,
                              width: 100,
                              shimmerBgColor: black,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            const SizedBox(height: 3),
                            /* Release Year & Video Duration */
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: const ShimmerWidget.roundrectborder(
                                    height: 15,
                                    width: 60,
                                    shimmerBgColor: black,
                                    shapeBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: const ShimmerWidget.roundrectborder(
                                    height: 15,
                                    width: 80,
                                    shimmerBgColor: black,
                                    shapeBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            /* Prime TAG  & Rent TAG */
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /* Prime TAG */
                                ShimmerWidget.roundrectborder(
                                  height: 13,
                                  width: 80,
                                  shimmerBgColor: black,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                SizedBox(height: 3),
                                /* Rent TAG */
                                ShimmerWidget.roundrectborder(
                                  height: 13,
                                  width: 80,
                                  shimmerBgColor: black,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          width: 25,
                          height: 25,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(6),
                          child: const ShimmerWidget.circular(
                            height: 18,
                            width: 18,
                            shimmerBgColor: black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget buildDownloadShimmer(context, int itemCount) {
    return AlignedGridView.count(
      shrinkWrap: true,
      crossAxisCount: 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 8,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kIsWeb ? (itemCount + 10) : itemCount,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(minHeight: Dimens.heightWatchlist),
          color: shimmerItemColor,
          child: Row(
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: Dimens.heightWatchlist,
                  maxWidth: MediaQuery.of(context).size.width * 0.44,
                ),
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.44,
                      height: Dimens.heightWatchlist,
                      alignment: Alignment.center,
                      child: ShimmerWidget.roundcorner(
                        width: MediaQuery.of(context).size.width,
                        height: Dimens.heightWatchlist,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 8),
                          child: ShimmerWidget.circular(
                            width: 30,
                            height: 30,
                            shimmerBgColor: black,
                          ),
                        ),
                        Container(
                          width: Dimens.widthContiLand,
                          constraints: const BoxConstraints(minWidth: 0),
                          padding: const EdgeInsets.all(3),
                          child: ShimmerWidget.roundcorner(
                            width: Dimens.widthContiLand,
                            height: 4,
                            shimmerBgColor: black,
                            shapeBorder: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: Dimens.heightWatchlist,
                    maxWidth: MediaQuery.of(context).size.width * 0.66,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /* Title */
                            const ShimmerWidget.roundrectborder(
                              height: 18,
                              width: 100,
                              shimmerBgColor: black,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            const SizedBox(height: 3),
                            /* Release Year & Video Duration */
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: const ShimmerWidget.roundrectborder(
                                    height: 15,
                                    width: 60,
                                    shimmerBgColor: black,
                                    shapeBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: const ShimmerWidget.roundrectborder(
                                    height: 15,
                                    width: 80,
                                    shimmerBgColor: black,
                                    shapeBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            /* Prime TAG  & Rent TAG */
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /* Prime TAG */
                                ShimmerWidget.roundrectborder(
                                  height: 13,
                                  width: 80,
                                  shimmerBgColor: black,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                SizedBox(height: 3),
                                /* Rent TAG */
                                ShimmerWidget.roundrectborder(
                                  height: 13,
                                  width: 80,
                                  shimmerBgColor: black,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          width: 25,
                          height: 25,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(6),
                          child: const ShimmerWidget.circular(
                            height: 18,
                            width: 18,
                            shimmerBgColor: black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget buildSubscribeShimmer(context) {
    return Column(
      children: [
        if (kIsWeb) SizedBox(height: Dimens.homeTabHeight),
        const SizedBox(height: 12),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.center,
          child: ShimmerWidget.roundrectborder(
            height: 20,
            width: MediaQuery.of(context).size.width,
            shimmerBgColor: black,
            shapeBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 30, right: 30),
          alignment: Alignment.center,
          child: ShimmerWidget.roundrectborder(
            height: 20,
            width: MediaQuery.of(context).size.width,
            shimmerBgColor: black,
            shapeBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 12),
        /* Remaining Data */
        Flexible(
          child: PageView.builder(
            itemCount: 3,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      color: black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(left: 18, right: 18),
                            constraints: const BoxConstraints(minHeight: 55),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ShimmerWidget.roundrectborder(
                                  height: 18,
                                  width: 120,
                                  shimmerBgColor: shimmerItemColor,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                ShimmerWidget.roundrectborder(
                                  height: 16,
                                  width: 80,
                                  shimmerBgColor: shimmerItemColor,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 0.5,
                            margin: const EdgeInsets.only(bottom: 12),
                            color: shimmerItemColor,
                          ),
                          AlignedGridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            itemCount: 7,
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int position) {
                              return Container(
                                constraints:
                                    const BoxConstraints(minHeight: 30),
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(bottom: 10),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      child: ShimmerWidget.roundrectborder(
                                        height: 18,
                                        width: 100,
                                        shimmerBgColor: shimmerItemColor,
                                        shapeBorder: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    ShimmerWidget.circular(
                                      height: 30,
                                      width: 30,
                                      shimmerBgColor: shimmerItemColor,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          /* Choose Plan */
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: ShimmerWidget.roundrectborder(
                                height: 52,
                                width: MediaQuery.of(context).size.width * 0.5,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  static Widget buildAvatarGrid(context, double itemHeight, double itemWidth,
      int crossAxisCount, int itemCount) {
    return AlignedGridView.count(
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      itemCount: kIsWeb ? (itemCount + 10) : itemCount,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return Container(
          width: itemWidth,
          height: itemHeight,
          alignment: Alignment.center,
          child: ShimmerWidget.circular(
            height: itemHeight,
            shimmerBgColor: shimmerItemColor,
          ),
        );
      },
    );
  }

  static Widget buildHistoryShimmer(context, int itemCount) {
    return AlignedGridView.count(
      shrinkWrap: true,
      crossAxisCount: 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 12,
      padding: const EdgeInsets.only(left: 15, right: 15),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kIsWeb ? (itemCount + 10) : itemCount,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(minHeight: Dimens.heightHistory),
          decoration: Utils.setBackground(lightBlack, 5),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /* Title */
                      const ShimmerWidget.roundrectborder(
                        height: 20,
                        width: 120,
                        shimmerBgColor: black,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),

                      /* Price */
                      Container(
                        constraints: const BoxConstraints(minHeight: 0),
                        margin: const EdgeInsets.only(top: 5),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget.roundrectborder(
                              height: 15,
                              width: 80,
                              shimmerBgColor: black,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            SizedBox(width: 5),
                            ShimmerWidget.roundrectborder(
                              height: 15,
                              width: 3,
                              shimmerBgColor: black,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 120,
                                shimmerBgColor: black,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /* Expire On */
                      Container(
                        constraints: const BoxConstraints(minHeight: 0),
                        margin: const EdgeInsets.only(top: 5),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget.roundrectborder(
                              height: 15,
                              width: 80,
                              shimmerBgColor: black,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            SizedBox(width: 5),
                            ShimmerWidget.roundrectborder(
                              height: 15,
                              width: 3,
                              shimmerBgColor: black,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 120,
                                shimmerBgColor: black,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 30,
                constraints: const BoxConstraints(minWidth: 0),
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                alignment: Alignment.center,
                child: const ShimmerWidget.roundrectborder(
                  height: 20,
                  width: 100,
                  shimmerBgColor: black,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
