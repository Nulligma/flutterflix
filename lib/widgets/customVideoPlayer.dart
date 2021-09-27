// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

enum PlayerType { preview, content }

class CustomVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final Function? onVideoEnded;
  final PlayerType type;

  const CustomVideoPlayer(
      {Key? key, required this.type, required this.videoUrl, this.onVideoEnded})
      : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? _controller;
  ChewieController? _chewie;

  @override
  void initState() {
    super.initState();
    _initControllers(widget.videoUrl!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewie?.dispose();
    super.dispose();
  }

  Future<void> _initControllers(String url) async {
    _controller = VideoPlayerController.network(url);
    await _controller!.initialize();

    switch (widget.type) {
      case PlayerType.preview:
        //You can only autoplay videos on web if the volume is first muted.
        _controller!.setVolume(0.0);
        _chewie = ChewieController(
          videoPlayerController: _controller!,
          aspectRatio: _controller!.value.aspectRatio,
          showControls: false,
          autoPlay: true,
        );
        break;
      case PlayerType.content:
        _chewie = ChewieController(
          videoPlayerController: _controller!,
          aspectRatio: _controller!.value.aspectRatio,
        );
        break;
    }

    // TODO: remove this comment for web version of the app

    /*_chewie!.addListener(() {
      if (_chewie!.isFullScreen)
        document.documentElement!.requestFullscreen();
      else
        document.exitFullscreen();
    });*/

    if (widget.onVideoEnded != null)
      _controller!.addListener(() {
        if (_controller!.value.position == _controller!.value.duration)
          widget.onVideoEnded!();
      });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          _chewie != null && _chewie!.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: _chewie!,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Loading',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
    );
  }
}
