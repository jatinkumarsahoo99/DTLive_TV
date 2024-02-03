import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:dtlive/provider/searchprovider.dart';
import 'package:dtlive/shimmer/shimmerutils.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/dimens.dart';
import 'package:dtlive/utils/strings.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:dtlive/widget/myimage.dart';
import 'package:dtlive/widget/mynetworkimg.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:dtlive/widget/nodata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../utils/constant.dart';
import '../widget/focusbase.dart';
import 'KeyBoardIntentFile.dart';

class Search extends StatefulWidget {
  final String? searchText;
  const Search({Key? key, required this.searchText}) : super(key: key);

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  final searchController = TextEditingController();
  late SearchProvider searchProvider = SearchProvider();
  final SpeechToText _speechToText = SpeechToText();
  bool speechEnabled = false, _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    _initSpeech();
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchController.text = widget.searchText ?? "";
    _getData();
    Utils.getAndroidAPILevel().then((value) {
      Constant.androidAPILevel = value;
      setState(() {

      });
    });
    super.initState();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    try{
      speechEnabled = await _speechToText.initialize();
      setState(() {});
    }catch(e){
      if (kDebugMode) {
        print(">>>>>>$e");
      }
    }

  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    try {
      debugPrint("<============== _startListening ==============>");
      await _speechToText.listen(onResult: _onSpeechResult);
      setState(() {
        _isListening = true;
      });
      Future.delayed(const Duration(seconds: 5), () {
        if (searchController.text
            .toString()
            .isEmpty) {
          Utils.showSnackbar(context, "info", "speechnotavailable", true);
          _stopListening();
        }
      });
    }catch(e){
      if (kDebugMode) {
        print(">>>>>>$e");
      }
    }
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    debugPrint("<============== _stopListening ==============>");
    _lastWords = '';
    _isListening = false;
    await _speechToText.stop();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    debugPrint("<============== _onSpeechResult ==============>");
    setState(() async {
      _lastWords = result.recognizedWords;
      debugPrint("_lastWords ==============> $_lastWords");
      if (_lastWords.isNotEmpty && _isListening) {
        searchController.text = _lastWords.toString();
        _isListening = false;
        await searchProvider.getSearchVideo(_lastWords.toString());
        _lastWords = '';
      }
    });
  }

  @override
  void dispose() {
    _stopListening();
    searchController.dispose();
    searchProvider.clearProvider();
    super.dispose();
  }

  _getData() async {
    if ((widget.searchText ?? "").isNotEmpty) {
      final searchProvider =
          Provider.of<SearchProvider>(context, listen: false);
      await searchProvider.getSearchVideo(widget.searchText ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: appBgColor,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: appBgColor,
          child: Column(
            children: [
              const SizedBox(height: 20),
              /* Search Box */
              searchBox(),
              const SizedBox(height: 20),
              /* Searched Data */
              Expanded(
                child: Consumer<SearchProvider>(
                  builder: (context, searchProvider, child) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: Row(
                            children: [
                              Expanded(
                                child: FocusBase(
                                  onPressed: () {
                                    searchProvider.setDataVisibility(
                                        true, false);
                                  },

                                  onFocus: (sta ) {  },
                                  focusColor: Colors.grey.withOpacity(0.2),
                                  focusNodeNew: focusNode4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: MyText(
                                          color: white,
                                          text: "videos",
                                          multilanguage: true,
                                          textalign: TextAlign.center,
                                          fontsizeNormal: 14,
                                          fontsizeWeb: 16,
                                          fontweight: FontWeight.w600,
                                          maxline: 1,
                                          overflow: TextOverflow.ellipsis,
                                          fontstyle: FontStyle.normal,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Visibility(
                                        visible: searchProvider.isVideoClick,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 2,
                                          color: white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: FocusBase(
                                  onPressed: () {
                                    searchProvider.setDataVisibility(
                                        false, true);
                                  },
                                  onFocus: (sta ) {  },
                                  focusColor: Colors.grey.withOpacity(0.2),
                                  focusNodeNew: focusNode5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: MyText(
                                          color: white,
                                          text: "shows",
                                          textalign: TextAlign.center,
                                          fontsizeNormal: 14,
                                          fontsizeWeb: 16,
                                          fontweight: FontWeight.w600,
                                          multilanguage: true,
                                          maxline: 1,
                                          overflow: TextOverflow.ellipsis,
                                          fontstyle: FontStyle.normal,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Visibility(
                                        visible: searchProvider.isShowClick,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 2,
                                          color: white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        searchProvider.isVideoClick
                            ? _buildVideoUI()
                            : searchProvider.isShowClick
                                ? _buildShowUI()
                                : const SizedBox.shrink(),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }

  FocusNode ?focusNode ;
  FocusNode ?focusNode1 ;
  FocusNode ?focusNode2 ;
  FocusNode ?focusNode3 ;
  FocusNode ?focusNode4 ;
  FocusNode ?focusNode5 ;

  setFirstFocus(BuildContext context){
    if(focusNode1 == null){
      focusNode1 = FocusNode();
      focusNode = FocusNode();
      focusNode2 = FocusNode();
      focusNode3 = FocusNode();
      focusNode4 = FocusNode();
      focusNode5 = FocusNode();
      FocusScope.of(context).requestFocus(focusNode);
    }
  }

  changeFocus(BuildContext context,FocusNode? node,{bool isPrv = false}){
    if(node != null){
      FocusScope.of(context).requestFocus(node);
      setState(() {});
    }else if(isPrv){
      FocusScope.of(context).previousFocus();
      setState(() {

      });
    }else{
      FocusScope.of(context).nextFocus();

      setState(() {

      });
    }
  }

  Widget searchBox() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(
          color: primaryColor,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Shortcuts(
        shortcuts:<ShortcutActivator, Intent> {
          LogicalKeySet(LogicalKeyboardKey.arrowLeft):LeftButtonIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowRight):RightButtonIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown):DownButtonIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowUp):UpButtonIntent(),
          LogicalKeySet(LogicalKeyboardKey.select):EnterButtonIntent(),
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Actions(
              actions: <Type, Action<Intent>>{
                RightButtonIntent:CallbackAction<RightButtonIntent>(onInvoke:(intent)=> changeFocus(context,focusNode1)),
                LeftButtonIntent:CallbackAction<LeftButtonIntent>(onInvoke:(intent)=> changeFocus(context,focusNode3)),
                // UButtonIntent:CallbackAction<LeftButtonIntent>(onInvoke:(intent)=> changeFocus(context,focusNode3)),
                // DownButtonIntent:CallbackAction<DownButtonIntent>(onInvoke:(intent)=> changeFocus(context,lstFocusNode?[0])),
              },
              child: FocusBase(
                // borderRadius: BorderRadius.circular(5),
                onPressed: () {
                  Navigator.pop(context);
                },
                focusNodeNew: focusNode,
                focusColor: Colors.grey.withOpacity(0.2),
                onFocus: (isFocused) {},
                child: Container(
                  width: 50,
                  height: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: MyImage(
                    width: 16,
                    height: 16,
                    imagePath: "back.png",
                    color: black,
                  ),
                ),
              ),
            ),
            Actions(
              actions: <Type, Action<Intent>>{
                RightButtonIntent:CallbackAction<RightButtonIntent>(onInvoke:(intent)=> changeFocus(context,focusNode3)),
                LeftButtonIntent:CallbackAction<LeftButtonIntent>(onInvoke:(intent)=> changeFocus(context,focusNode)),
                // DownButtonIntent:CallbackAction<DownButtonIntent>(onInvoke:(intent)=> changeFocus(context,lstFocusNode?[0])),
              },
              child: Expanded(
                child: FocusBase(
                  onPressed: () {
                    // Navigator.pop(context);

                  },
                  focusColor: Colors.grey.withOpacity(0.2),
                  onFocus: (isFocused) {},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: TextField(
                      onChanged: (value) async {
                        if (value.isNotEmpty) {
                          await searchProvider.setLoading(true);
                          await searchProvider.getSearchVideo(value.toString());
                        }
                      },
                      textInputAction: TextInputAction.done,
                      obscureText: false,
                      focusNode: focusNode1,
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      style: const TextStyle(
                        color: black,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: transparentColor,
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
              ),
            ),
            Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                if (searchController.text.toString().isNotEmpty) {
                  return Actions(
                    actions: <Type, Action<Intent>>{
                      RightButtonIntent:CallbackAction<RightButtonIntent>(onInvoke:(intent)=> changeFocus(context,null))
                    },
                    child: FocusBase(
                      // borderRadius: BorderRadius.circular(5),
                      onPressed: () async {
                        debugPrint("Click on Clear!");
                        searchController.clear();
                        await searchProvider.clearProvider();
                        await searchProvider.notifyProvider();
                        focusNode1?.requestFocus();
                        setState(() {});
                      },
                      focusColor: Colors.grey.withOpacity(0.2),
                      onFocus: (isFocused) {},
                      focusNodeNew: focusNode2,
                      child: Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.center,
                        child: MyImage(
                          imagePath: "ic_close.png",
                          color: black,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                } else if(int.parse(Constant.androidAPILevel) > 30) {
                  return Actions(
                    actions: <Type, Action<Intent>>{
                      RightButtonIntent:CallbackAction<RightButtonIntent>(onInvoke:(intent)=> changeFocus(context,null)),
                      // DownButtonIntent:CallbackAction<DownButtonIntent>(onInvoke:(intent)=> changeFocus(context,lstFocusNode?[0])),
                    },
                    child: FocusBase(
                      // borderRadius: BorderRadius.circular(5),
                      onPressed: () async {
                        debugPrint("Click on Microphone!");
                        _startListening();
                      },
                      focusColor: Colors.grey.withOpacity(0.2),
                      focusNodeNew: focusNode3,
                      onFocus: (isFocused) {},
                      child: _isListening
                          ? AvatarGlow(
                              glowColor: primaryLight,
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
                                    color: black,
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
                                color: black,
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                  );
                }else{
                  return Actions(
                    actions: <Type, Action<Intent>>{
                      RightButtonIntent:CallbackAction<RightButtonIntent>(onInvoke:(intent)=> changeFocus(context,null))
                    },
                    child: FocusBase(
                      // borderRadius: BorderRadius.circular(5),
                      onPressed: () async {
                        debugPrint("Click on Clear!");
                        searchController.clear();
                        await searchProvider.clearProvider();
                        await searchProvider.notifyProvider();
                        focusNode1?.requestFocus();
                        setState(() {});
                      },
                      focusColor: Colors.grey.withOpacity(0.2),
                      onFocus: (isFocused) {},
                      focusNodeNew: focusNode2,
                      child: Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.center,
                        child: MyImage(
                          imagePath: "ic_close.png",
                          color: black,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoUI() {
    if (searchProvider.loading) {
      return _shimmerSearch();
    } else {
      if (searchProvider.searchModel.status == 200) {
        if (searchProvider.searchModel.video != null) {
          return Expanded(
            child: AlignedGridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              itemCount: (searchProvider.searchModel.video?.length ?? 0),
              padding: const EdgeInsets.only(left: 20, right: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int position) {
                return Material(
                  type: MaterialType.transparency,
                  child: FocusBase(
                    // borderRadius: BorderRadius.circular(4),
                    onPressed: () {
                      log("Clicked on position ==> $position");
                      Utils.openDetails(
                        context: context,
                        videoId:
                            searchProvider.searchModel.video?[position].id ?? 0,
                        upcomingType: 0,
                        videoType: searchProvider
                                .searchModel.video?[position].videoType ??
                            0,
                        typeId: searchProvider
                                .searchModel.video?[position].typeId ??
                            0,
                      );
                    },
                    onFocus: (sta ) {  },
                    focusColor: Colors.grey.withOpacity(0.2),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: Dimens.heightLand,
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: MyNetworkImage(
                          imageUrl: searchProvider
                                  .searchModel.video?[position].landscape
                                  .toString() ??
                              "",
                          fit: BoxFit.cover,
                          imgHeight: MediaQuery.of(context).size.height,
                          imgWidth: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const NoData(title: "", subTitle: "");
        }
      } else {
        return const SizedBox.shrink();
      }
    }
  }

  Widget _buildShowUI() {
    if (searchProvider.loading) {
      return _shimmerSearch();
    } else {
      if (searchProvider.searchModel.status == 200) {
        if (searchProvider.searchModel.tvshow != null) {
          return Expanded(
            child: AlignedGridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              itemCount: (searchProvider.searchModel.tvshow?.length ?? 0),
              padding: const EdgeInsets.only(left: 20, right: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int position) {
                return Material(
                  type: MaterialType.transparency,
                  child: FocusBase(
                    onPressed: () {
                      log("Clicked on position ==> $position");
                      Utils.openDetails(
                        context: context,
                        videoId:
                            searchProvider.searchModel.tvshow?[position].id ??
                                0,
                        upcomingType: 0,
                        videoType: searchProvider
                                .searchModel.tvshow?[position].videoType ??
                            0,
                        typeId: searchProvider
                                .searchModel.tvshow?[position].typeId ??
                            0,
                      );
                    },
                    onFocus: (sta ) {  },
                    focusColor: Colors.grey.withOpacity(0.2),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: Dimens.heightLand,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: MyNetworkImage(
                          imageUrl: searchProvider.searchModel.tvshow
                                  ?.elementAt(position)
                                  .landscape
                                  .toString() ??
                              "",
                          fit: BoxFit.cover,
                          imgHeight: MediaQuery.of(context).size.height,
                          imgWidth: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const NoData(title: "", subTitle: "");
        }
      } else {
        return const SizedBox.shrink();
      }
    }
  }

  Widget _shimmerSearch() {
    return Expanded(
      child: ShimmerUtils.normalVerticalGrid(
          context, Dimens.heightLand, Dimens.widthLand, 2, kIsWeb ? 40 : 20),
    );
  }
}
