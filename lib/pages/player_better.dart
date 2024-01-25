// import 'dart:async';
// import 'dart:developer';
//
// import 'package:better_player/better_player.dart';
// import 'package:dtlive/provider/playerprovider.dart';
// import 'package:dtlive/utils/color.dart';
// import 'package:dtlive/utils/constant.dart';
// import 'package:dtlive/utils/utils.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
//
// class PlayerBetter extends StatefulWidget {
//   final int? videoId, videoType, typeId, otherId, stopTime;
//   final String? playType, videoUrl, vUploadType, videoThumb;
//
//   const PlayerBetter(
//       this.playType,
//       this.videoId,
//       this.videoType,
//       this.typeId,
//       this.otherId,
//       this.videoUrl,
//       this.stopTime,
//       this.vUploadType,
//       this.videoThumb,
//       {Key? key})
//       : super(key: key);
//
//   @override
//   State<PlayerBetter> createState() => _PlayerBetterState();
// }
//
// class _PlayerBetterState extends State<PlayerBetter>
//     with WidgetsBindingObserver {
//   late GlobalKey _betterPlayerKey;
//   late PlayerProvider playerProvider;
//   int? playerCPosition, videoDuration;
//   late BetterPlayerController _betterPlayerController;
//
//   @override
//   void initState() {
//     debugPrint("videoUrl ========> ${widget.videoUrl}");
//     debugPrint("vUploadType ========> ${widget.vUploadType}");
//     playerProvider = Provider.of<PlayerProvider>(context, listen: false);
//     BetterPlayerConfiguration betterPlayerConfiguration =
//         BetterPlayerConfiguration(
//       aspectRatio: 16 / 9,
//       fit: BoxFit.fill,
//       allowedScreenSleep: false,
//       expandToFill: true,
//       autoPlay: true,
//       controlsConfiguration: const BetterPlayerControlsConfiguration(
//         enablePip: true,
//         pipMenuIcon: Icons.picture_in_picture_alt_outlined,
//       ),
//       startAt: Duration(milliseconds: widget.stopTime ?? 0),
//       fullScreenByDefault: true,
//       autoDetectFullscreenDeviceOrientation: true,
//       subtitlesConfiguration: const BetterPlayerSubtitlesConfiguration(
//         backgroundColor: transparentColor,
//         fontColor: Colors.white,
//         outlineColor: Colors.black,
//         fontSize: 12,
//         alignment: Alignment.bottomCenter,
//       ),
//       deviceOrientationsOnFullScreen: [
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight
//       ],
//     );
//
//     _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
//
//     _betterPlayerKey = GlobalKey();
//     _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
//     _betterPlayerController.addEventsListener(listener);
//
//     _setupDataSource();
//
//     super.initState();
//   }
//
//   _setupDataSource() async {
//     debugPrint("sSubTitleUrls Length =======> ${Constant.subtitleUrls.length}");
//     List<BetterPlayerSubtitlesSource> subtitlesList = [];
//
//     if ((widget.playType == "Video" || widget.playType == "Show") &&
//         Constant.subtitleUrls.isNotEmpty) {
//       for (var i = 0; i < Constant.subtitleUrls.length; i++) {
//         BetterPlayerSubtitlesSource bpSubtitlesSource =
//             BetterPlayerSubtitlesSource(
//           type: BetterPlayerSubtitlesSourceType.network,
//           name: Constant.subtitleUrls[i].subtitleLang,
//           urls: [Constant.subtitleUrls[i].subtitleUrl],
//           selectedByDefault: i == 0 ? true : false,
//         );
//         subtitlesList.insert(i, bpSubtitlesSource);
//       }
//     }
//
//     BetterPlayerDataSourceType dataSourceType;
//     if (widget.playType == "Download") {
//       dataSourceType = BetterPlayerDataSourceType.file;
//     } else {
//       dataSourceType = BetterPlayerDataSourceType.network;
//     }
//     BetterPlayerDataSource dataSource = BetterPlayerDataSource(
//       BetterPlayerDataSourceType.network,
//       widget.videoUrl ?? "",
//       liveStream: widget.playType == "Channel" ? true : false,
//       resolutions: (widget.playType == "Video" || widget.playType == "Show")
//           ? Constant.resolutionsUrls.isNotEmpty
//               ? Constant.resolutionsUrls
//               : {}
//           : {},
//       subtitles: (widget.playType == "Video" || widget.playType == "Show")
//           ? subtitlesList.isNotEmpty
//               ? subtitlesList
//               : []
//           : [],videoFormat:BetterPlayerVideoFormat.other,
//       bufferingConfiguration: const BetterPlayerBufferingConfiguration(
//         minBufferMs: 5000,
//         maxBufferMs: 131072,
//         bufferForPlaybackMs: 2500,
//         bufferForPlaybackAfterRebufferMs: 5000,
//       ),
//     );
//     _betterPlayerController.setupDataSource(dataSource);
//
//     if (widget.playType == "Video" || widget.playType != "Show") {
//       /* Add Video view */
//       await playerProvider.addVideoView(widget.videoId.toString(),
//           widget.videoType.toString(), widget.otherId.toString());
//     }
//   }
//
//   @override
//   void dispose() {
//     _betterPlayerController.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//     _betterPlayerController.removeEventsListener(listener);
//     debugPrint("onBack isTV :===> ${Constant.isTV}");
//     SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
//     super.dispose();
//   }
//
//   Future<void> listener(BetterPlayerEvent event) async {
//     if (event.betterPlayerEventType == BetterPlayerEventType.pipStart) {
//       // debugPrint('===================== pipStart =====================');
//     }
//     if (event.betterPlayerEventType == BetterPlayerEventType.pipStop) {
//       // debugPrint('===================== pipStop =====================');
//     }
//     if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
//       // log("Current subtitle line: ${_betterPlayerController.renderedSubtitle}");
//       playerCPosition =
//           (_betterPlayerController.videoPlayerController?.value.position)
//                   ?.inMilliseconds ??
//               0;
//       videoDuration =
//           (_betterPlayerController.videoPlayerController?.value.duration)
//                   ?.inMilliseconds ??
//               0;
//       // log("playerCPosition :===> $playerCPosition");
//       // log("videoDuration :===> $videoDuration");
//     }
//   }
//
//   bool isControlVisble = false;
//
//   @override
//   Widget build(BuildContext context) {
//     log("===> ${widget.videoUrl}");
//     return RawKeyboardListener(
//       onKey: (key){
//         print("Key is called");
//         // print("Audio track is>>"+(_betterPlayerController.betterPlayerAsmsAudioTracks?.length.toString()??""));
//         _betterPlayerController.toggleControlsVisibility(true);
//         Future.delayed(Duration(seconds: 5), () {
//           _betterPlayerController.toggleControlsVisibility(false);
//         });
//         if (key.logicalKey == LogicalKeyboardKey.arrowUp ||
//             key.logicalKey == LogicalKeyboardKey.arrowDown) {
//           // Utils.showSnackbar(context, "info", "enter_tv_code", true);
//           _betterPlayerController.toggleControlsVisibility(true);
//           Future.delayed(Duration(seconds: 5), () {
//             _betterPlayerController.toggleControlsVisibility(false);
//           });
//         } else if (key.logicalKey == LogicalKeyboardKey.arrowRight) {
//           _betterPlayerController.seekTo(Duration(
//               seconds: (_betterPlayerController
//                   .videoPlayerController?.value.position?.inSeconds) ??
//                   0 + 10));
//         } else if (key.logicalKey == LogicalKeyboardKey.arrowLeft) {
//           _betterPlayerController.seekTo(Duration(
//               seconds: (_betterPlayerController
//                   .videoPlayerController?.value.position?.inSeconds) ??
//                   0 - 10));
//         }
//       },
//       focusNode: FocusNode(),
//       autofocus: true,
//       child: WillPopScope(
//         onWillPop: onBackPressed,
//         child: GestureDetector(
//           onTap: (){
//
//           },
//           child: Scaffold(
//             backgroundColor: appBgColor,
//             body: Stack(
//               children: [
//                 Center(
//                   child: AspectRatio(
//                     aspectRatio: 16 / 9,
//                     child: BetterPlayer(
//                       key: _betterPlayerKey,
//                       controller: _betterPlayerController,
//                     ),
//                   ),
//                 ),
//                 if (!kIsWeb)
//                   Positioned(
//                     top: 15,
//                     left: 15,
//                     child: SafeArea(
//                       child: InkWell(
//                         onTap: onBackPressed,
//                         focusColor: gray.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(20),
//                         child: Utils.buildBackBtnDesign(context),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<bool> onBackPressed() async {
//     debugPrint("onBack isTV :===> ${Constant.isTV}");
//     SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
//     log("onBackPressed playerCPosition :===> $playerCPosition");
//     log("onBackPressed videoDuration :===> $videoDuration");
//     log("onBackPressed playType :===> ${widget.playType}");
//
//     if (widget.playType == "Video" || widget.playType == "Show") {
//       if ((playerCPosition ?? 0) > 0 &&
//           (playerCPosition == videoDuration ||
//               (playerCPosition ?? 0) > (videoDuration ?? 0))) {
//         /* Remove From Continue */
//         await playerProvider.removeFromContinue(
//             "${widget.videoId}", "${widget.videoType}");
//         if (!mounted) return Future.value(false);
//         Navigator.pop(context, true);
//         return Future.value(true);
//       } else if ((playerCPosition ?? 0) > 0) {
//         /* Add to Continue */
//         await playerProvider.addToContinue(
//             "${widget.videoId}", "${widget.videoType}", "$playerCPosition");
//         if (!mounted) return Future.value(false);
//         Navigator.pop(context, true);
//         return Future.value(true);
//       } else {
//         if (!mounted) return Future.value(false);
//         Navigator.pop(context, false);
//         return Future.value(true);
//       }
//     } else {
//       if (!mounted) return Future.value(false);
//       Navigator.pop(context, false);
//       return Future.value(true);
//     }
//   }
// }
