import 'package:dtlive/model/sectiontypemodel.dart';
import 'package:dtlive/provider/homeprovider.dart';
import 'package:dtlive/provider/sectiondataprovider.dart';
import 'package:dtlive/shimmer/shimmerutils.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class HomeTabs extends StatefulWidget {
  const HomeTabs({Key? key}) : super(key: key);

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  late HomeProvider homeProvider;
  late SectionDataProvider sectionDataProvider;

  @override
  void initState() {
    sectionDataProvider =
        Provider.of<SectionDataProvider>(context, listen: false);
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    super.initState();
  }

  Future<void> getTabData(int position) async {
    debugPrint("getTabData position ======> $position");
    debugPrint(
        "getTabData lastTabPos ====> ${sectionDataProvider.lastTabPosition}");
    if (!mounted) return;
    await homeProvider.setSelectedTab(position);
    if (sectionDataProvider.lastTabPosition == position) {
      return;
    }
    sectionDataProvider.setTabPosition(position);
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPage();
  }

  Widget _buildPage() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        if (homeProvider.loading) {
          return ShimmerUtils.buildHomeMobileShimmer(context);
        } else {
          if (homeProvider.sectionTypeModel.status == 200) {
            if (homeProvider.sectionTypeModel.result != null ||
                (homeProvider.sectionTypeModel.result?.length ?? 0) > 0) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 90),
                height: MediaQuery.of(context).size.height,
                color: appBgColor,
                child: AlignedGridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 1,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  itemCount:
                      (homeProvider.sectionTypeModel.result?.length ?? 0) + 1,
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int position) {
                    return _buildNavigation(
                      index: position,
                      sectionTypeList: homeProvider.sectionTypeModel.result,
                    );
                  },
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget _buildNavigation({
    required int index,
    required List<Result>? sectionTypeList,
  }) {
    return FocusBase(
      focusColor: white,
      onFocus: (isFocused) async {
        debugPrint("Type isFocused ===========> $isFocused");
        homeProvider.setFocused(isFocused);
        if (isFocused) {
          debugPrint("Type index ===========> $index");
          getTabData(index);
        }
      },
      onPressed: () async {
        debugPrint("Type index ===========> $index");
        getTabData(index);
      },
      child: Container(
        constraints: const BoxConstraints(maxHeight: 32),
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
        child: MyText(
          color: (homeProvider.selectedIndex == index &&
                  homeProvider.isTypeFocused == true)
              ? black
              : white,
          multilanguage: false,
          text: index == 0
              ? "Home"
              : index > 0
                  ? (sectionTypeList?[index - 1].name.toString() ?? "")
                  : "",
          fontsizeNormal: 12,
          fontweight: FontWeight.w700,
          fontsizeWeb: 14,
          maxline: 1,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal,
        ),
      ),
    );
  }
}
