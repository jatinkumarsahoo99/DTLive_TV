import 'dart:developer';

import 'package:dtlive/shimmer/shimmerutils.dart';
import 'package:dtlive/utils/dimens.dart';
import 'package:dtlive/provider/rentstoreprovider.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/widget/mynetworkimg.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:dtlive/widget/nodata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

class TVRentStore extends StatefulWidget {
  const TVRentStore({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  State<TVRentStore> createState() => TVRentStoreState();
}

class TVRentStoreState extends State<TVRentStore> {
  late RentStoreProvider rentStoreProvider;
  @override
  void initState() {
    super.initState();
    rentStoreProvider = Provider.of<RentStoreProvider>(context, listen: false);
    _getData();
  }

  _getData() async {
    await rentStoreProvider.getRentVideoList();
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    rentStoreProvider.clearRentStoreProvider();
    super.dispose();
  }

  _openDetailPage(
      int? videoId, int? upcomingType, int? videoType, int? typeId) async {
    if (!mounted) return;
    Utils.openDetails(
      context: context,
      videoId: videoId ?? 0,
      upcomingType: upcomingType ?? 0,
      videoType: videoType ?? 0,
      typeId: typeId ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || Constant.isTV) {
      return Scaffold(
        backgroundColor: appBgColor,
        body: SafeArea(
          child: _buildRentStore(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: appBgColor,
        appBar: Utils.myAppBar(context, "stor", true),
        body: SafeArea(
          child: _buildRentStore(),
        ),
      );
    }
  }

  Widget _buildRentStore() {
    final rentStoreProvider =
        Provider.of<RentStoreProvider>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: (rentStoreProvider.loading)
            ? ShimmerUtils.buildRentShimmer(
                context, Dimens.heightLand, Dimens.widthLand)
            : ((rentStoreProvider.rentModel.status == 200)
                ? Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildRentVideos(),
                      const SizedBox(height: 22),
                      _buildRentTVShows(),
                      const SizedBox(height: 20),
                    ],
                  )
                : const NoData(title: '', subTitle: '')),
      ),
    );
  }

  Widget _buildRentVideos() {
    if (rentStoreProvider.rentModel.video != null) {
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 20, right: 20),
            constraints: const BoxConstraints(minHeight: 30),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                FittedBox(
                  child: Container(
                    constraints:
                        const BoxConstraints(minHeight: 20, minWidth: 20),
                    padding: const EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: complimentryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MyText(
                      color: white,
                      text: Constant.currencySymbol,
                      textalign: TextAlign.center,
                      fontsizeNormal: 11,
                      fontsizeWeb: 12,
                      multilanguage: false,
                      maxline: 1,
                      fontweight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                MyText(
                  color: white,
                  text: "rentvideo",
                  multilanguage: true,
                  textalign: TextAlign.center,
                  fontsizeNormal: 14,
                  fontsizeWeb: 16,
                  maxline: 1,
                  fontweight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(width: 5),
                MyText(
                  color: otherColor,
                  text: "(${(rentStoreProvider.rentModel.video?.length ?? 0)}",
                  textalign: TextAlign.center,
                  multilanguage: false,
                  fontsizeNormal: 11,
                  fontsizeWeb: 12,
                  maxline: 1,
                  fontweight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(width: 5),
                MyText(
                  color: otherColor,
                  text: (rentStoreProvider.rentModel.video?.length ?? 0) <= 1
                      ? "video)"
                      : "videos)",
                  multilanguage: false,
                  textalign: TextAlign.center,
                  fontsizeNormal: 11,
                  fontsizeWeb: 12,
                  maxline: 1,
                  fontweight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: (rentStoreProvider.rentModel.video?.length ?? 0) == 1
                ? Dimens.heightLand
                : ((rentStoreProvider.rentModel.video?.length ?? 0) > 1 &&
                        (rentStoreProvider.rentModel.video?.length ?? 0) < 7)
                    ? (Dimens.heightLand * 2)
                    : (rentStoreProvider.rentModel.video?.length ?? 0) > 6
                        ? (Dimens.heightLand * 3)
                        : (Dimens.heightLand * 2),
            child: AlignedGridView.count(
              shrinkWrap: true,
              crossAxisCount:
                  (rentStoreProvider.rentModel.video?.length ?? 0) == 1
                      ? 1
                      : ((rentStoreProvider.rentModel.video?.length ?? 0) > 1 &&
                              (rentStoreProvider.rentModel.video?.length ?? 0) <
                                  7)
                          ? 2
                          : (rentStoreProvider.rentModel.video?.length ?? 0) > 6
                              ? 3
                              : 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              itemCount: (rentStoreProvider.rentModel.video?.length ?? 0),
              padding: const EdgeInsets.only(left: 20, right: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int position) {
                return Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    focusColor: white,
                    borderRadius: BorderRadius.circular(4),
                    onTap: () {
                      log("Clicked on position ==> $position");
                      _openDetailPage(
                        rentStoreProvider.rentModel.video?[position].id ?? 0,
                        rentStoreProvider
                                .rentModel.video?[position].upcomingType ??
                            0,
                        rentStoreProvider
                                .rentModel.video?[position].videoType ??
                            0,
                        rentStoreProvider.rentModel.video?[position].typeId ??
                            0,
                      );
                    },
                    child: Container(
                      padding: (!(kIsWeb) || !(Constant.isTV))
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.all(2.0),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            width: Dimens.widthLand,
                            height: Dimens.heightLand,
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: MyNetworkImage(
                                imageUrl: rentStoreProvider
                                        .rentModel.video?[position].landscape
                                        .toString() ??
                                    "",
                                fit: BoxFit.cover,
                                imgHeight: MediaQuery.of(context).size.height,
                                imgWidth: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                          FittedBox(
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 15,
                                minWidth: 30,
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(3),
                                    topRight: Radius.circular(4),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(3)),
                              ),
                              child: MyText(
                                color: black,
                                text:
                                    "${Constant.currencySymbol} ${rentStoreProvider.rentModel.video?[position].rentPrice.toString() ?? "0"}",
                                textalign: TextAlign.center,
                                fontsizeNormal: 10,
                                fontsizeWeb: 12,
                                fontweight: FontWeight.w700,
                                maxline: 1,
                                multilanguage: false,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      return const NoData(title: '', subTitle: '');
    }
  }

  Widget _buildRentTVShows() {
    if (rentStoreProvider.rentModel.tvshow != null) {
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(minHeight: 30),
            padding: const EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                FittedBox(
                  child: Container(
                    constraints:
                        const BoxConstraints(minHeight: 20, minWidth: 20),
                    padding: const EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: complimentryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MyText(
                      color: white,
                      text: Constant.currencySymbol,
                      textalign: TextAlign.center,
                      multilanguage: false,
                      fontsizeNormal: 11,
                      fontsizeWeb: 12,
                      maxline: 1,
                      fontweight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                MyText(
                  color: white,
                  text: "rentshow",
                  textalign: TextAlign.center,
                  multilanguage: true,
                  fontsizeNormal: 14,
                  fontsizeWeb: 16,
                  maxline: 1,
                  fontweight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(width: 5),
                MyText(
                  color: otherColor,
                  text: "(${(rentStoreProvider.rentModel.tvshow?.length ?? 0)}",
                  textalign: TextAlign.center,
                  fontsizeNormal: 11,
                  fontsizeWeb: 12,
                  maxline: 1,
                  multilanguage: false,
                  fontweight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(width: 5),
                MyText(
                  color: otherColor,
                  text: (rentStoreProvider.rentModel.video?.length ?? 0) <= 1
                      ? "show)"
                      : "shows)",
                  textalign: TextAlign.center,
                  multilanguage: false,
                  fontsizeNormal: 11,
                  fontsizeWeb: 12,
                  maxline: 1,
                  fontweight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: (rentStoreProvider.rentModel.tvshow?.length ?? 0) == 1
                ? Dimens.heightLand
                : ((rentStoreProvider.rentModel.tvshow?.length ?? 0) > 1 &&
                        (rentStoreProvider.rentModel.tvshow?.length ?? 0) < 7)
                    ? (Dimens.heightLand * 2)
                    : (rentStoreProvider.rentModel.tvshow?.length ?? 0) > 6
                        ? (Dimens.heightLand * 3)
                        : (Dimens.heightLand * 2),
            child: AlignedGridView.count(
              shrinkWrap: true,
              crossAxisCount: (rentStoreProvider.rentModel.tvshow?.length ??
                          0) ==
                      1
                  ? 1
                  : ((rentStoreProvider.rentModel.tvshow?.length ?? 0) > 1 &&
                          (rentStoreProvider.rentModel.tvshow?.length ?? 0) < 7)
                      ? 2
                      : (rentStoreProvider.rentModel.tvshow?.length ?? 0) > 6
                          ? 3
                          : 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              itemCount: (rentStoreProvider.rentModel.tvshow?.length ?? 0),
              padding: const EdgeInsets.only(left: 20, right: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int position) {
                return Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    focusColor: white,
                    borderRadius: BorderRadius.circular(4),
                    onTap: () {
                      log("Clicked on position ==> $position");
                      _openDetailPage(
                        rentStoreProvider.rentModel.tvshow?[position].id ?? 0,
                        rentStoreProvider
                                .rentModel.tvshow?[position].upcomingType ??
                            0,
                        rentStoreProvider
                                .rentModel.tvshow?[position].videoType ??
                            0,
                        rentStoreProvider.rentModel.tvshow?[position].typeId ??
                            0,
                      );
                    },
                    child: Container(
                      padding: (!(kIsWeb) || !(Constant.isTV))
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.all(2.0),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            width: Dimens.widthLand,
                            height: Dimens.heightLand,
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: MyNetworkImage(
                                imageUrl: rentStoreProvider
                                        .rentModel.tvshow?[position].landscape
                                        .toString() ??
                                    "",
                                fit: BoxFit.cover,
                                imgHeight: MediaQuery.of(context).size.height,
                                imgWidth: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                          FittedBox(
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: 15,
                                minWidth: 30,
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(3),
                                    topRight: Radius.circular(4),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(3)),
                              ),
                              child: MyText(
                                color: black,
                                text:
                                    "${Constant.currencySymbol} ${rentStoreProvider.rentModel.tvshow?[position].rentPrice.toString() ?? "0"}",
                                textalign: TextAlign.center,
                                fontsizeNormal: 10,
                                fontsizeWeb: 12,
                                multilanguage: false,
                                fontweight: FontWeight.w700,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      return const NoData(title: '', subTitle: '');
    }
  }
}
