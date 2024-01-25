import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_meedu_videoplayer/meedu_player.dart';
// import 'package:flutter_meedu_media_kit/meedu_player.dart';

/*class PlayerMeedu extends StatefulWidget {
  const PlayerMeedu({Key? key}) : super(key: key);

  @override
  State<PlayerMeedu> createState() =>
      _PlayerMeeduState();
}

class _PlayerMeeduState extends State<PlayerMeedu> {
  late MeeduPlayerController _controller;
  late final player = Player();

  final ValueNotifier<bool> _subtitlesEnabled = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _controller = MeeduPlayerController(
        controlsStyle: ControlsStyle.primary,
        enabledControls: const EnabledControls(doubleTapToSeek: false),

    );
    _setDataSource();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _setDataSource() async {
    await _controller.setDataSource(
      DataSource(
        source: 'http://103.174.247.25/Hollywood%20Movie/Avatar%20The%20Way%20of%20Water%20%282022%291080p.mkv',
        type: DataSourceType.network,
        // closedCaptionFile: _loadCaptions(),
      ),
      autoplay: true,
    );
    // _controller.videoController?.
    // _controller.onClosedCaptionEnabled(true);
    // _player=_controller.
   *//* print("Audio track>>>"+(_controller.videoPlayerController?.state.track.audio.toString()??""));
    print("Tracks are>>>"+(_controller.videoPlayerController?.state.tracks?.audio.toString()??""));
    _controller.videoPlayerController?.setAudioTrack(AudioTrack("2", null, null));
    print("Audio Tracks are>>>"+(_controller.videoPlayerController?.state.tracks?.audio.toString()??""));
    print("Video Tracks are>>>"+(_controller.videoPlayerController?.state.tracks?.video.toString()??""));
    print("Subtitle Tracks are>>>"+(_controller.videoPlayerController?.state.tracks?.subtitle.toString()??""));
    _controller.videoPlayerController?.stream.tracks.listen((event) {
      // List<VideoTrack> videos = event.video;
      // List<AudioTrack> audios = event.audio;
      // List<SubtitleTrack> subtitles = event.subtitle;
      print("Audio Tracks are>>>"+(_controller.videoPlayerController?.state.tracks?.audio.toString()??""));
      print("Video Tracks are>>>"+(_controller.videoPlayerController?.state.tracks?.video.toString()??""));
      print("Subtitle Tracks are>>>"+(_controller.videoPlayerController?.state.tracks?.subtitle.toString()??""));
    });*//*

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: MeeduVideoPlayer(
          controller: _controller,
          // bottomRight: (ctx, controller, responsive) {
          //   // creates a responsive fontSize using the size of video container
          //   final double fontSize = responsive.ip(3);
          //
          //   return CupertinoButton(
          //     padding: const EdgeInsets.all(5),
          //     minSize: 25,
          //     child: ValueListenableBuilder(
          //       valueListenable: _subtitlesEnabled,
          //       builder: (BuildContext context, bool enabled, _) {
          //         return Text(
          //           "CC",
          //           style: TextStyle(
          //             fontSize: fontSize > 18 ? 18 : fontSize,
          //             color: Colors.white.withOpacity(
          //               enabled ? 1 : 0.4,
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //     onPressed: () {
          //       _subtitlesEnabled.value = !_subtitlesEnabled.value;
          //       _controller.onClosedCaptionEnabled(_subtitlesEnabled.value);
          //     },
          //   );
          // },
        ),
      ),
    );
  }
}*/
