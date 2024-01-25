import 'package:dtlive/model/sectiondetailmodel.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MoreDetails extends StatefulWidget {
  final List<MoreDetail>? moreDetailList;
  const MoreDetails({required this.moreDetailList, Key? key}) : super(key: key);

  @override
  State<MoreDetails> createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  @override
  void initState() {
    super.initState();
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
    if (widget.moreDetailList != null &&
        (widget.moreDetailList?.length ?? 0) > 0) {
      return AlignedGridView.count(
        shrinkWrap: true,
        crossAxisCount: 1,
        crossAxisSpacing: 0,
        mainAxisSpacing: 15,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        itemCount: widget.moreDetailList?.length ?? 0,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          if ((widget.moreDetailList?[index].description ?? "").isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  color: white,
                  text: widget.moreDetailList?[index].title ?? "",
                  textalign: TextAlign.start,
                  fontsizeNormal: 14,
                  fontweight: FontWeight.w700,
                  fontsizeWeb: 15,
                  multilanguage: false,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(height: 5),
                MyText(
                  color: otherColor,
                  text: widget.moreDetailList?[index].description ?? "",
                  textalign: TextAlign.start,
                  fontsizeNormal: 13,
                  fontweight: FontWeight.w600,
                  fontsizeWeb: 14,
                  multilanguage: false,
                  maxline: 20,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(height: 10),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: (MediaQuery.of(context).size.width * 0.6),
                  ),
                  height: 0.4,
                  color: otherColor,
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
