import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final Function onVideoEnded;

  const CustomVideoPlayer({Key key, this.videoUrl, this.onVideoEnded})
      : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController _controller;
  ChewieController _chewie;

  @override
  void initState() {
    _initControllers(widget.videoUrl);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewie?.dispose();
    super.dispose();
  }

  Future<void> _initControllers(String url) async {
    _controller = VideoPlayerController.network(url);
    await _controller.initialize();
    _chewie = ChewieController(
      aspectRatio: 9 / 16,
      videoPlayerController: _controller,
      showControls: false,
      autoPlay: true,
    );
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration)
        widget.onVideoEnded();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _chewie != null && _chewie.videoPlayerController.value.initialized
          ? Chewie(
              controller: _chewie,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Loading'),
              ],
            ),
    );
  }
}
