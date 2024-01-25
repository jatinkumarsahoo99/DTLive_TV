import 'dart:async';

import 'package:dtlive/shimmer/shimmerutils.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/utils/dimens.dart';
import 'package:dtlive/provider/videobyidprovider.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/mynetworkimg.dart';
import 'package:dtlive/widget/nodata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class TVVideosByID extends StatefulWidget {
  final String appBarTitle, layoutType;
  final int itemID, typeId;
  const TVVideosByID(
    this.itemID,
    this.typeId,
    this.appBarTitle,
    this.layoutType, {
    Key? key,
  }) : super(key: key);

  @override
  State<TVVideosByID> createState() => TVVideosByIDState();
}

class TVVideosByIDState extends State<TVVideosByID> {
  late VideoByIDProvider videoByIDProvider;

  @override
  void initState() {
    videoByIDProvider = Provider.of<VideoByIDProvider>(context, listen: false);
    super.initState();
    _getData();
  }

  _getData() async {
    if (widget.layoutType == "ByCategory") {
      await videoByIDProvider.getVideoByCategory(widget.itemID, widget.typeId);
    } else if (widget.layoutType == "ByLanguage") {
      await videoByIDProvider.getVideoByLanguage(widget.itemID, widget.typeId);
    }
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  openDetailPage(int dataPos, String pageName, int videoId, int upcomingType,
      int videoType, int typeId) async {
    debugPrint("pageName ==========> $pageName");
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!kIsWeb) Utils.myAppBar(context, widget.appBarTitle, false),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints.expand(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      videoByIDProvider.loading
                          ? ShimmerUtils.responsiveGrid(
                              context,
                              Dimens.heightLand,
                              Dimens.widthLand,
                              2,
                              (kIsWeb || Constant.isTV) ? 40 : 20)
                          : (videoByIDProvider.videoByIdModel.status == 200 &&
                                  videoByIDProvider.videoByIdModel.result !=
                                      null)
                              ? (videoByIDProvider
                                              .videoByIdModel.result?.length ??
                                          0) >
                                      0
                                  ? _buildVideoItem()
                                  : const SizedBox.shrink()
                              : const NoData(title: '', subTitle: ''),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoItem() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: ResponsiveGridList(
        minItemWidth: Dimens.widthLand,
        verticalGridSpacing: 8,
        horizontalGridSpacing: 0,
        minItemsPerRow: 2,
        maxItemsPerRow: 8,
        listViewBuilderOptions: ListViewBuilderOptions(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        children: List.generate(
          (videoByIDProvider.videoByIdModel.result?.length ?? 0),
          (position) {
            return FocusBase(
              focusColor: white,
              onFocus: (isFocused) {},
              onPressed: () {
                debugPrint("Clicked on position ==> $position");
                openDetailPage(
                  position,
                  (videoByIDProvider
                                  .videoByIdModel.result?[position].videoType ??
                              0) ==
                          2
                      ? "showdetail"
                      : "videodetail",
                  videoByIDProvider.videoByIdModel.result?[position].id ?? 0,
                  videoByIDProvider
                          .videoByIdModel.result?[position].upcomingType ??
                      0,
                  videoByIDProvider
                          .videoByIdModel.result?[position].videoType ??
                      0,
                  videoByIDProvider.videoByIdModel.result?[position].typeId ??
                      0,
                );
              },
              child: Container(
                height: Dimens.heightLand,
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [
                      MyNetworkImage(
                        imageUrl: (videoByIDProvider
                                .videoByIdModel.result?[position].landscape
                                .toString() ??
                            ""),
                        fit: BoxFit.cover,
                        imgHeight: MediaQuery.of(context).size.height,
                        imgWidth: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
