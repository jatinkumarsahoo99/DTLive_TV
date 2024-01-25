import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:dtlive/pages/search.dart';
import 'package:dtlive/pages/sectionbytype.dart';
import 'package:dtlive/pages/videosbyid.dart';
// import 'package:dtlive/pages/sectionbytype.dart';
// import 'package:dtlive/pages/videosbyid.dart';
import 'package:dtlive/provider/findprovider.dart';
import 'package:dtlive/shimmer/shimmerutils.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/strings.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/widget/myimage.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Find extends StatefulWidget {
  const Find({Key? key}) : super(key: key);

  @override
  State<Find> createState() => FindState();
}

class FindState extends State<Find> {
  final searchController = TextEditingController();
  late FindProvider findProvider = FindProvider();
  final SpeechToText _speechToText = SpeechToText();
  bool speechEnabled = false, _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    _getData();
    findProvider = Provider.of<FindProvider>(context, listen: false);
    _initSpeech();
    super.initState();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    debugPrint("<============== _startListening ==============>");
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _isListening = true;
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (_isListening && searchController.text.toString().isEmpty) {
        Utils.showSnackbar(context, "info", "speechnotavailable", true);
        _stopListening();
      }
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    debugPrint("<============== _stopListening ==============>");
    await _speechToText.stop();
    if (!mounted) return;
    setState(() {
      _lastWords = '';
      _isListening = false;
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) async {
    debugPrint("<============== _onSpeechResult ==============>");
    _lastWords = result.recognizedWords;
    debugPrint("_lastWords ==============> $_lastWords");
    if (_lastWords.isNotEmpty && _isListening) {
      searchController.text = _lastWords.toString();
      _isListening = false;
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Search(
              searchText: searchController.text.toString(),
            );
          },
        ),
      );
      setState(() {
        _lastWords = '';
        searchController.clear();
      });
    }
  }

  void _getData() async {
    findProvider = Provider.of<FindProvider>(context, listen: false);
    findProvider.getSectionType();
    findProvider.getGenres();
    findProvider.getLanguage();
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _stopListening();
    searchController.dispose();
    findProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: appBgColor,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: appBgColor,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 25),

                /* Search Box */
                searchBox(),
                const SizedBox(height: 22),

                /* Genres */
                Consumer<FindProvider>(
                  builder: (context, findProvider, child) {
                    log("setGenresSize  ===>  ${findProvider.setGenresSize}");
                    log("genresModel Size  ===>  ${(findProvider.genresModel.result?.length ?? 0)}");
                    if (findProvider.loading) {
                      return ShimmerUtils.buildFindShimmer(context);
                    } else {
                      if (findProvider.genresModel.status == 200) {
                        if (findProvider.genresModel.result != null &&
                            (findProvider.genresModel.result?.length ?? 0) >
                                0) {
                          return Column(
                            children: [
                              /* Browse by START */
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                  color: white,
                                  text: "browsby",
                                  multilanguage: true,
                                  textalign: TextAlign.center,
                                  fontsizeNormal: 15,
                                  fontsizeWeb: 16,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontweight: FontWeight.w600,
                                  fontstyle: FontStyle.normal,
                                ),
                              ),
                              const SizedBox(height: 10),
                              AlignedGridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                itemCount: (findProvider
                                        .sectionTypeModel.result?.length ??
                                    0),
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(4),
                                    onTap: () {
                                      log("Item Clicked! => $position");
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SectionByType(
                                              findProvider.sectionTypeModel
                                                      .result?[position].id ??
                                                  0,
                                              findProvider.sectionTypeModel
                                                      .result?[position].name ??
                                                  "",
                                              "2"),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 65,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      decoration: BoxDecoration(
                                        color: primaryDarkColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      alignment: Alignment.center,
                                      child: MyText(
                                        color: white,
                                        text: findProvider.sectionTypeModel
                                                .result?[position].name ??
                                            "",
                                        textalign: TextAlign.center,
                                        fontstyle: FontStyle.normal,
                                        multilanguage: false,
                                        fontsizeNormal: 14,
                                        fontsizeWeb: 14,
                                        fontweight: FontWeight.w600,
                                        maxline: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              /* Browse by END */
                              const SizedBox(height: 22),

                              /* Genres START */
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                  color: white,
                                  text: "genres",
                                  textalign: TextAlign.center,
                                  fontsizeNormal: 15,
                                  fontsizeWeb: 16,
                                  fontweight: FontWeight.w600,
                                  multilanguage: true,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal,
                                ),
                              ),
                              const SizedBox(height: 15),
                              AlignedGridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                itemCount: findProvider.setGenresSize <
                                        (findProvider
                                                .genresModel.result?.length ??
                                            0)
                                    ? findProvider.setGenresSize
                                    : (findProvider
                                            .genresModel.result?.length ??
                                        0),
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 0.9,
                                        color: lightBlack,
                                      ),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(4),
                                        onTap: () {
                                          log("Item Clicked! => $position");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return VideosByID(
                                                  findProvider
                                                          .genresModel
                                                          .result?[position]
                                                          .id ??
                                                      0,
                                                  0,
                                                  findProvider
                                                          .genresModel
                                                          .result?[position]
                                                          .name ??
                                                      "",
                                                  "ByCategory",
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          height: 47,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MyText(
                                                color: otherColor,
                                                text: findProvider
                                                        .genresModel
                                                        .result?[position]
                                                        .name ??
                                                    "",
                                                textalign: TextAlign.center,
                                                fontsizeNormal: 13,
                                                fontsizeWeb: 14,
                                                multilanguage: false,
                                                maxline: 1,
                                                overflow: TextOverflow.ellipsis,
                                                fontweight: FontWeight.w500,
                                                fontstyle: FontStyle.normal,
                                              ),
                                              MyImage(
                                                width: 13,
                                                height: 13,
                                                color: otherColor,
                                                imagePath: "ic_right.png",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Visibility(
                                visible: findProvider.isGenSeeMore,
                                child: InkWell(
                                  onTap: () {
                                    final findProvider =
                                        Provider.of<FindProvider>(context,
                                            listen: false);
                                    findProvider.setGenSeeMore(false);
                                    findProvider.setGenresListSize(findProvider
                                            .genresModel.result?.length ??
                                        0);
                                  },
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    alignment: Alignment.centerLeft,
                                    child: MyText(
                                      color: primaryColor,
                                      text: "seemore",
                                      textalign: TextAlign.center,
                                      fontsizeNormal: 14,
                                      maxline: 1,
                                      multilanguage: true,
                                      overflow: TextOverflow.ellipsis,
                                      fontweight: FontWeight.w500,
                                      fontstyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                              /* Genres END */
                              const SizedBox(height: 30),

                              /* Language START */
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                  color: white,
                                  multilanguage: true,
                                  text: "language_",
                                  textalign: TextAlign.center,
                                  fontsizeNormal: 15,
                                  fontsizeWeb: 16,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontweight: FontWeight.w600,
                                  fontstyle: FontStyle.normal,
                                ),
                              ),
                              const SizedBox(height: 15),
                              AlignedGridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                itemCount: findProvider.setLanguageSize <
                                        (findProvider
                                                .langaugeModel.result?.length ??
                                            0)
                                    ? findProvider.setLanguageSize
                                    : (findProvider
                                            .langaugeModel.result?.length ??
                                        0),
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  return Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 0.9,
                                        color: lightBlack,
                                      ),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(4),
                                        onTap: () {
                                          log("Item Clicked! => $position");
                                         /* Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return VideosByID(
                                                  findProvider
                                                          .langaugeModel
                                                          .result?[position]
                                                          .id ??
                                                      0,
                                                  0,
                                                  findProvider
                                                          .langaugeModel
                                                          .result?[position]
                                                          .name ??
                                                      "",
                                                  "ByLanguage",
                                                );
                                              },
                                            ),
                                          );*/
                                        },
                                        child: SizedBox(
                                          height: 47,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MyText(
                                                color: otherColor,
                                                text: findProvider
                                                        .langaugeModel
                                                        .result?[position]
                                                        .name ??
                                                    "",
                                                textalign: TextAlign.center,
                                                fontsizeNormal: 13,
                                                fontsizeWeb: 14,
                                                multilanguage: false,
                                                maxline: 1,
                                                overflow: TextOverflow.ellipsis,
                                                fontweight: FontWeight.w500,
                                                fontstyle: FontStyle.normal,
                                              ),
                                              MyImage(
                                                width: 13,
                                                height: 13,
                                                color: otherColor,
                                                imagePath: "ic_right.png",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Visibility(
                                visible: findProvider.isLangSeeMore,
                                child: InkWell(
                                  onTap: () {
                                    final findProvider =
                                        Provider.of<FindProvider>(context,
                                            listen: false);
                                    findProvider.setLangSeeMore(false);
                                    findProvider.setLanguageListSize(
                                        findProvider
                                                .langaugeModel.result?.length ??
                                            0);
                                  },
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    alignment: Alignment.centerLeft,
                                    child: MyText(
                                      color: primaryColor,
                                      text: "seemore",
                                      textalign: TextAlign.center,
                                      fontsizeNormal: 14,
                                      multilanguage: true,
                                      maxline: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontweight: FontWeight.w500,
                                      fontstyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                              /* Language END */
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      } else {
                        return const SizedBox.shrink();
                      }
                    }
                  },
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBox() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      decoration: BoxDecoration(
        color: primaryDarkColor,
        border: Border.all(
          color: primaryLight,
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: MyImage(
              width: 20,
              height: 20,
              imagePath: "ic_find.png",
              color: white,
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: TextField(
                onSubmitted: (value) async {
                  log("value ====> $value");
                  if (value.isNotEmpty) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Search(
                            searchText: value.toString(),
                          );
                        },
                      ),
                    );
                    setState(() {
                      searchController.clear();
                    });
                  }
                },
                cursorColor: primaryLight,
                onChanged: (value) async {},
                textInputAction: TextInputAction.done,
                obscureText: false,
                controller: searchController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                style: const TextStyle(
                  color: white,
                  fontSize: 15,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: TextStyle(
                    color: otherColor,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: searchHint,
                ),

              ),
            ),
          ),
          Consumer<FindProvider>(
            builder: (context, findProvider, child) {
              if (searchController.text.toString().isNotEmpty) {
                return InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () async {
                    debugPrint("Click on Clear!");
                    searchController.clear();
                    setState(() {});
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: MyImage(
                      imagePath: "ic_close.png",
                      color: white,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              } else {
                return InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () async {
                    debugPrint("Click on Microphone!");
                    _startListening();
                  },
                  child: _isListening
                      ? AvatarGlow(
                          glowColor: primaryColor,
                          endRadius: 25,
                          duration: const Duration(milliseconds: 2000),
                          repeat: true,
                          showTwoGlows: true,
                          repeatPauseDuration:
                              const Duration(milliseconds: 100),
                          child: Material(
                            elevation: 5,
                            color: transparentColor,
                            shape: const CircleBorder(),
                            child: Container(
                              width: 50,
                              height: 50,
                              color: transparentColor,
                              padding: const EdgeInsets.all(15),
                              alignment: Alignment.center,
                              child: MyImage(
                                imagePath: "ic_voice.png",
                                color: white,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(15),
                          alignment: Alignment.center,
                          child: MyImage(
                            imagePath: "ic_voice.png",
                            color: white,
                            fit: BoxFit.fill,
                          ),
                        ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
