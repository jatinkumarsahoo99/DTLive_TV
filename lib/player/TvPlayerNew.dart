import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyTvScreen extends StatefulWidget {
  final String urlData;

  MyTvScreen({required this.urlData});

  @override
  MyTvScreenState createState() => MyTvScreenState();
}

class MyTvScreenState extends State<MyTvScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    print("data"+widget!.urlData.toString());
    _controller = VideoPlayerController.network(widget?.urlData.toString()??"");
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TV Player"),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              child: VideoPlayer(_controller),
              height: 400,
              width: double.infinity,
            ),
            _ControlsOverlay(controller: _controller),
            VideoProgressIndicator(_controller, allowScrubbing: true),
          ],
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);
  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          color: Colors.black26,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 50),
              reverseDuration: Duration(milliseconds: 200),
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () async {
                      var position = await controller.position;
                      controller
                          .seekTo(Duration(seconds: position!.inSeconds - 5));
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  controller.value.isPlaying
                      ? MaterialButton(
                          child: Icon(
                            Icons.pause,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onPressed: () {
                            controller.value.isPlaying
                                ? controller.pause()
                                : controller.play();
                          },
                        )
                      : MaterialButton(
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onPressed: () {
                            controller.value.isPlaying
                                ? controller.pause()
                                : controller.play();
                          },
                        ),
                  SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      var position = await controller.position;
                      controller
                          .seekTo(Duration(seconds: position!.inSeconds + 5));
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  PopupMenuButton(
                    initialValue: controller.value.playbackSpeed,
                    tooltip: 'Playback speed',
                    color: Colors.white,
                    onSelected: (speed) {
                      controller.setPlaybackSpeed(speed! as double);
                    },
                    itemBuilder: (context) {
                      return [
                        for (final speed in _examplePlaybackRates)
                          PopupMenuItem(
                            value: speed,
                            child: Text(
                              '${speed}x',
                            ),
                          )
                      ];
                    },
                    child: Text(
                      '${controller.value.playbackSpeed}x',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
