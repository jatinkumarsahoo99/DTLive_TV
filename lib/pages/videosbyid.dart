import 'dart:async';

import 'package:dtlive/shimmer/shimmerutils.dart';
import 'package:dtlive/utils/dimens.dart';
import 'package:dtlive/utils/utils.dart';
// import 'package:dtlive/webwidget/footerweb.dart';
import 'package:dtlive/widget/nodata.dart';
import 'package:dtlive/provider/videobyidprovider.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/widget/mynetworkimg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class VideosByID extends StatefulWidget {
  final String appBarTitle, layoutType;
  final int itemID, typeId;
  const VideosByID(
    this.itemID,
    this.typeId,
    this.appBarTitle,
    this.layoutType, {
    Key? key,
  }) : super(key: key);

  @override
  State<VideosByID> createState() => VideosByIDState();
}

class VideosByIDState extends State<VideosByID> {
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
            Utils.myAppBarWithBack(context, widget.appBarTitle, false),
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
                              kIsWeb ? 40 : 20)
                          : (videoByIDProvider.videoByIdModel.status == 200 &&
                                  videoByIDProvider.videoByIdModel.result !=
                                      null)
                              ? (videoByIDProvider
                                              .videoByIdModel.result?.length ??
                                          0) >
                                      0
                                  ? _buildVideoItem()
                                  : const NoData(
                                      title: '',
                                      subTitle: '',
                                    )
                              : const NoData(
                                  title: '',
                                  subTitle: '',
                                ),
                      const SizedBox(height: 20),

                      /* Web Footer */
                      // (kIsWeb) ? const FooterWeb() : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
            /* AdMob Banner */
            Container(
              child: Utils.showBannerAd(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoItem() {
    return RefreshIndicator(
      backgroundColor: white,
      color: complimentryColor,
      displacement: 80,
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 1500)).then((value) {
          videoByIDProvider.setLoading(true);
          Future.delayed(Duration.zero).then((value) {
            if (!mounted) return;
            setState(() {});
          });
          _getData();
        });
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: ResponsiveGridList(
          minItemWidth: Dimens.widthLand,
          verticalGridSpacing: 8,
          horizontalGridSpacing: 8,
          minItemsPerRow: 2,
          maxItemsPerRow: 8,
          listViewBuilderOptions: ListViewBuilderOptions(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          children: List.generate(
            (videoByIDProvider.videoByIdModel.result?.length ?? 0),
            (position) {
              return InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  debugPrint("Clicked on position ==> $position");
                  Utils.openDetails(
                    context: context,
                    videoId:
                        videoByIDProvider.videoByIdModel.result?[position].id ??
                            0,
                    upcomingType: 0,
                    videoType: videoByIDProvider
                            .videoByIdModel.result?[position].videoType ??
                        0,
                    typeId: videoByIDProvider
                            .videoByIdModel.result?[position].typeId ??
                        0,
                  );
                },
                child: Container(
                  width: Dimens.widthLand,
                  height: Dimens.heightLand,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: MyNetworkImage(
                      imageUrl: videoByIDProvider
                              .videoByIdModel.result?[position].landscape
                              .toString() ??
                          "",
                      fit: BoxFit.cover,
                      imgHeight: MediaQuery.of(context).size.height,
                      imgWidth: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
