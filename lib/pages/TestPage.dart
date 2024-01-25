import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:path_provider/path_provider.dart';

typedef OnStopRecordingCallback = void Function(String);

/*
class TestPageController extends StatefulWidget {
  // final VlcPlayerController? controller;
  final bool showControls;
  final OnStopRecordingCallback? onStopRecording;

  const TestPageController({
    Key? key,
    // required this.controller,
    this.showControls = true,
    this.onStopRecording,
  }) : super(key: key);

  @override
  TestPageControllerState createState() => TestPageControllerState();
}

class TestPageControllerState extends State<TestPageController>
    with AutomaticKeepAliveClientMixin {
  static const _playerControlsBgColor = Colors.black87;
  static const _numberPositionOffset = 8.0;
  static const _recordingPositionOffset = 10.0;
  static const _positionedBottomSpace = 7.0;
  static const _positionedRightSpace = 3.0;
  static const _overlayWidth = 100.0;
  static const _elevation = 4.0;
  static const _aspectRatio = 16 / 9;

  final double initSnapshotRightPosition = 10;
  final double initSnapshotBottomPosition = 10;

  // late VlcPlayerController _controller;

  //
  OverlayEntry? _overlayEntry;

  //
  double sliderValue = 0.0;
  double volumeValue = 50;
  String position = '';
  String duration = '';
  int numberOfCaptions = 0;
  int numberOfAudioTracks = 0;
  bool validPosition = true;

  double recordingTextOpacity = 0;
  DateTime lastRecordingShowTime = DateTime.now();
  bool isRecording = false;

  //
  List<double> playbackSpeeds = [0.5, 1.0, 2.0];
  List<BoxFit> boxFit = [
    BoxFit.fill,
    BoxFit.none,
    BoxFit.contain,
    BoxFit.cover,
  ];
  int playbackSpeedIndex = 1;
  int boxFitIndex = 2;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  void listener() {
    if (!mounted) return;
    //
  }

  Timer? t;

  double videoWidth(VlcPlayerController? controller) {
    double width = controller != null
        ? controller.value.size.width != 0
            ? controller.value.size.width
            : 640
        : 640;
    return width;
    // if (width < max) {
    //   return max;
    // } else {
    //   return width;
    // }
  }

  double videoHeight(VlcPlayerController? controller) {
    double height = controller != null
        ? controller.value.size.height != 0
            ? controller.value.size.height
            : 480
        : 480;
    return height;
    // if (height < max) {
    //   return max;
    // } else {
    //   return height;
    // }
  }

  bool? hasFocus1 = true;
  bool? hasFocus2 = false;
  bool? hasFocus3 = false;
  bool? hasFocus4 = false;
  bool? hasFocus5 = false;
  bool? hasFocus6 = false;
  bool? hasFocus7 = false;

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();
  FocusNode f6 = FocusNode();
  FocusNode f7 = FocusNode();

  @override
  void initState() {
    super.initState();
    // _controller = widget.controller!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // t = Timer(
    //   const Duration(seconds: 10),
    //   () => setState(() => t = null),
    // );
    return RawKeyboardListener(
      focusNode: FocusNode(
        skipTraversal: false,
      ),
      onKey: (key) async {
        print("Key is called");
        setState(() {
          t?.cancel();
          t = Timer(
            const Duration(seconds: 2),
            () => setState(() => t = null),
          );
        });
      },
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ColoredBox(
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    */
/*Center(
                      child: VlcPlayer(
                        controller: _controller,
                        aspectRatio: _aspectRatio,
                        placeholder:
                            const Center(child: CircularProgressIndicator()),
                      ),
                    ),*//*

                    */
/*Positioned(
                      top: _recordingPositionOffset,
                      left: _recordingPositionOffset,
                      child: AnimatedOpacity(
                        opacity: recordingTextOpacity,
                        duration: const Duration(seconds: 1),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: const [
                            Icon(Icons.circle, color: Colors.red),
                            SizedBox(width: 5),
                            Text(
                              'REC',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),*//*

                    */
/*Builder(builder: (context) {
                      return AnimatedOpacity(
                          opacity: t != null ? 1 : 0.0,
                          duration: const Duration(seconds: 1),
                          child: ControlsOverlay(controller: _controller));
                    }),*//*

                    Builder(builder: (context) {
                      return AnimatedOpacity(
                        opacity: t != null ? 1 : 0.0,
                        duration: const Duration(seconds: 1),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Visibility(
                            visible: widget.showControls,
                            child: Container(
                              height: 70,
                              width: double.infinity,
                              color: _playerControlsBgColor,
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    children: [
                                      SizedBox(
                                        width: 350,
                                      ),
                                      InkWell(
                                        focusNode: f1,
                                        onFocusChange: (c) {
                                          hasFocus1 = c;
                                          print("Has focus 1: " + c.toString());
                                          setState(() {});
                                        },
                                        autofocus: true,
                                        focusColor: Colors.blue,
                                        splashColor: Colors.blue,
                                        // radius: 16,

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            padding: EdgeInsets.all(7.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: ((hasFocus1 ?? false)
                                                    ? Colors.blue
                                                    : Colors.transparent),
                                                // Border color when focused
                                                width: 2.0, // Border width
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        // color: Colors.white,
                                        onTap: () async {
                                          print("Callled back");
                                          // await _controller
                                          //     .stopRendererScanning();
                                          // await _controller.dispose();
                                          // Navigator.pop(context);
                                        },
                                      ),
                                      Stack(
                                        children: [
                                          InkWell(
                                            focusNode: f2,
                                            onFocusChange: (c) {
                                              hasFocus2 = c;
                                              setState(() {});
                                              print("Has focus 2: " +
                                                  c.toString());
                                            },

                                            focusColor: Colors.blue,
                                            splashColor: Colors.blue,
                                            // radius: 16,
                                            // tooltip: 'Get Subtitle Tracks',
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: ((hasFocus2 ?? false)
                                                      ? Colors.blue
                                                      : Colors.transparent),
                                                  // Border color when focused
                                                  width: 2.0, // Border width
                                                ),
                                              ),
                                              child: Icon(Icons.closed_caption,
                                                  color: Colors.white),
                                            ),
                                            // color: Colors.white,
                                            onTap: _getSubtitleTracks,
                                          ),
                                          Positioned(
                                            top: _numberPositionOffset,
                                            right: _numberPositionOffset,
                                            child: IgnorePointer(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(1),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 1,
                                                  horizontal: 2,
                                                ),
                                                child: Text(
                                                  '$numberOfCaptions',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          InkWell(
                                            focusNode: f3,
                                            onFocusChange: (c) {
                                              hasFocus3 = c;
                                              setState(() {});
                                              print("Has focus 3: " +
                                                  c.toString());
                                            },
                                            focusColor: Colors.blue,
                                            splashColor: Colors.blue,
                                            radius: 16,
                                            // tooltip: 'Get Audio Tracks',
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: ((hasFocus3 ?? false)
                                                      ? Colors.blue
                                                      : Colors.transparent),
                                                  // Border color when focused
                                                  width: 2.0, // Border width
                                                ),
                                              ),
                                              child: Icon(Icons.audiotrack,
                                                  color: Colors.white),
                                            ),
                                            // color: Colors.white,
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Select Audio'),
                                                    content: SizedBox(
                                                      width: double.maxFinite,
                                                      height: 250,
                                                      child: ListView.builder(
                                                        itemCount: 2,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ListTile(
                                                            title: Text(
                                                              'Disable',
                                                            ),
                                                            onTap: () {},
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    actions: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Cancel"),
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          Positioned(
                                            top: _numberPositionOffset,
                                            right: _numberPositionOffset,
                                            child: IgnorePointer(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(1),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 1,
                                                  horizontal: 2,
                                                ),
                                                child: Text(
                                                  '$numberOfAudioTracks',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          InkWell(
                                            focusNode: f4,
                                            onFocusChange: (c) {
                                              hasFocus4 = c;
                                              setState(() {});
                                              print("Has focus 4: " +
                                                  c.toString());
                                            },
                                            splashColor: Colors.blue,
                                            radius: 16,
                                            focusColor: Colors.blue,
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: ((hasFocus4 ?? false)
                                                      ? Colors.blue
                                                      : Colors.transparent),
                                                  // Border color when focused
                                                  width: 2.0, // Border width
                                                ),
                                              ),
                                              child: Icon(Icons.timer,
                                                  color: Colors.white),
                                            ),
                                            // color: Colors.white,
                                            onTap: _cyclePlaybackSpeed,
                                          ),
                                          Positioned(
                                            bottom: _positionedBottomSpace,
                                            right: _positionedRightSpace,
                                            child: IgnorePointer(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(1),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 1,
                                                  horizontal: 2,
                                                ),
                                                child: Text(
                                                  '${playbackSpeeds.elementAt(playbackSpeedIndex)}x',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      */
/* IconButton(
                                        tooltip: 'Get Snapshot',
                                        icon: const Icon(Icons.camera),
                                        color: Colors.white,
                                        onPressed: _createCameraImage,
                                      ),*//*

                                      */
/*IconButton(
                                        color: Colors.white,
                                        icon: _controller.value.isRecording
                                            ? const Icon(
                                                Icons.videocam_off_outlined)
                                            : const Icon(Icons.videocam_outlined),
                                        onPressed: _toggleRecording,
                                      ),*//*

                                      */
/*FocusTraversalOrder(
                                        order: NumericFocusOrder(5.0),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          radius: 16,
                                          child: const Icon(Icons.cast,
                                              color: Colors.white),
                                          // color: Colors.white,
                                          onTap: _getRendererDevices,
                                        ),
                                      ),
                                      FocusTraversalOrder(
                                        order: NumericFocusOrder(6.0),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          radius: 16,
                                          // tooltip: 'Reload',
                                          child: const Icon(Icons.sync,
                                              color: Colors.white),
                                          // color: Colors.white,
                                          onTap: () async {},
                                        ),
                                      )*//*

                                    ],
                                  ),
                                  */
/* Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Size: ${_controller.value.size?.width?.toInt() ?? 0}'
                                          'x${_controller.value.size?.height?.toInt() ?? 0}',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 10),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Status: ${_controller.value.playingState.toString().split('.')[1]}',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),*//*

                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    Builder(builder: (context) {
                      return AnimatedOpacity(
                        opacity: t != null ? 1 : 0.0,
                        duration: const Duration(seconds: 1),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Visibility(
                            visible: widget.showControls,
                            child: SizedBox(
                              height: 70,
                              child: ColoredBox(
                                color: _playerControlsBgColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.blue,
                                      radius: 16,
                                      focusNode: f5,
                                      focusColor: Colors.blue,
                                      onFocusChange: (c) {
                                        hasFocus5 = c;
                                        setState(() {});
                                        print("Has focus 5: " + c.toString());
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ((hasFocus5 ?? false)
                                                ? Colors.blue
                                                : Colors.transparent),
                                            // Border color when focused
                                            width: 2.0, // Border width
                                          ),
                                        ),
                                        child: Icon(Icons.replay_10,
                                            color: Colors.white),
                                      ),
                                      onTap: _togglePlaying,
                                    ),
                                    InkWell(
                                      splashColor: Colors.blue,
                                      radius: 16,
                                      focusNode: f6,
                                      focusColor: Colors.blue,
                                      onFocusChange: (c) {
                                        hasFocus6 = c;
                                        setState(() {});
                                        print("Has focus 5: " + c.toString());
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ((hasFocus6 ?? false)
                                                ? Colors.blue
                                                : Colors.transparent),
                                            // Border color when focused
                                            width: 2.0, // Border width
                                          ),
                                        ),
                                        child: Icon(Icons.play_circle_outline,
                                            color: Colors.white),
                                      ),
                                      onTap: _togglePlaying,
                                    ),
                                    InkWell(
                                      splashColor: Colors.blue,
                                      radius: 16,
                                      focusNode: f7,
                                      focusColor: Colors.blue,
                                      onFocusChange: (c) {
                                        hasFocus7 = c;
                                        setState(() {});
                                        print("Has focus 5: " + c.toString());
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ((hasFocus7 ?? false)
                                                ? Colors.blue
                                                : Colors.transparent),
                                            // Border color when focused
                                            width: 2.0, // Border width
                                          ),
                                        ),
                                        child: Icon(Icons.forward_10,
                                            color: Colors.white),
                                      ),
                                      onTap: _togglePlaying,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            position,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Expanded(
                                            child: Slider(
                                               focusNode: FocusNode(
                                                  skipTraversal: false
                                              ),
                                              activeColor: Colors.redAccent,
                                              inactiveColor: Colors.white70,
                                              value: sliderValue,
                                              min: 0.0,
                                              max: 1,
                                              onChanged: validPosition
                                                  ? _onSliderPositionChanged
                                                  : null,
                                            ),
                                          ),
                                          Text(
                                            duration,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                     InkWell(
                                      child: const Icon(Icons.fullscreen),
                                      // color: Colors.white,
                                      // ignore: no-empty-block
                                      onTap: () {
                                        _updateBoxFit();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cyclePlaybackSpeed() async {
    playbackSpeedIndex++;
    if (playbackSpeedIndex >= playbackSpeeds.length) {
      playbackSpeedIndex = 0;
    }

    */
/*return _controller
        .setPlaybackSpeed(playbackSpeeds.elementAt(playbackSpeedIndex));*//*

  }

  Future<void> _updateBoxFit() async {
    boxFitIndex++;
    print("Index is>>>" + boxFitIndex.toString());
    if (boxFitIndex >= boxFit.length) {
      boxFitIndex = 0;
    }

    setState(() {});
  }

  void _setSoundVolume(double value) {
    setState(() {
      volumeValue = value;
    });
    // _controller.setVolume(volumeValue.toInt());
  }

  Future<void> _togglePlaying() async {}

  Future<void> _toggleRecording() async {}

  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    //convert to Milliseconds since VLC requires MS to set time
    // _controller.setTime(sliderValue.toInt() * Duration.millisecondsPerSecond);
  }

  Future<void> _getSubtitleTracks() async {
    print("Callled subtitle");
  }

  Future<void> _getAudioTracks() async {
    print("Callled audio");
  }

  Future<void> _getRendererDevices() async {
    print("Callled render");
  }

  OverlayEntry _createSnapshotThumbnail(Uint8List snapshot) {
    double right = initSnapshotRightPosition;
    double bottom = initSnapshotBottomPosition;

    return OverlayEntry(
      builder: (context) => Positioned(
        right: right,
        bottom: bottom,
        width: _overlayWidth,
        child: Material(
          elevation: _elevation,
          child: GestureDetector(
            onTap: () async {
              _overlayEntry?.remove();
              _overlayEntry = null;
              await showDialog<void>(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: Image.memory(snapshot),
                  );
                },
              );
            },
            onVerticalDragUpdate: (dragUpdateDetails) {
              bottom -= dragUpdateDetails.delta.dy;
              _overlayEntry?.markNeedsBuild();
            },
            onHorizontalDragUpdate: (dragUpdateDetails) {
              right -= dragUpdateDetails.delta.dx;
              _overlayEntry?.markNeedsBuild();
            },
            onHorizontalDragEnd: (dragEndDetails) {
              if ((initSnapshotRightPosition - right).abs() >= _overlayWidth) {
                _overlayEntry?.remove();
                _overlayEntry = null;
              } else {
                right = initSnapshotRightPosition;
                _overlayEntry?.markNeedsBuild();
              }
            },
            onVerticalDragEnd: (dragEndDetails) {
              if ((initSnapshotBottomPosition - bottom).abs() >=
                  _overlayWidth) {
                _overlayEntry?.remove();
                _overlayEntry = null;
              } else {
                bottom = initSnapshotBottomPosition;
                _overlayEntry?.markNeedsBuild();
              }
            },
            child: Image.memory(snapshot),
          ),
        ),
      ),
    );
  }
}
*/
