import 'package:flutter/material.dart';
import 'package:flutterflix/data/data.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/widgets/customVideoPlayer.dart';
import 'package:flutterflix/widgets/widgets.dart';

class PreviewScreen extends StatefulWidget {
  final int startingContent;

  const PreviewScreen({Key key, @required this.startingContent})
      : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  PageController _pageController;
  int _index;

  @override
  void initState() {
    _pageController = PageController(
        initialPage: widget.startingContent, viewportFraction: 1);
    _index = widget.startingContent;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      _index = index;
    });
  }

  void videoEnded() {
    if (_index + 1 == previews.length)
      Navigator.of(context).pop();
    else
      _pageController.jumpToPage(_index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      PageView.builder(
        itemCount: previews.length,
        controller: _pageController,
        onPageChanged: onPageChanged,
        itemBuilder: (_, i) {
          Content previewContent = previews[i];

          return ContentHeader(
            content: previewContent,
            type: ContentHeaderType.Previews,
            videoPlayer: CustomVideoPlayer(
              videoUrl: previewContent.previewVideo,
              onVideoEnded: videoEnded,
            ),
          );
        },
      ),
      PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 50.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 30.0),
          child: IconButton(
            alignment: Alignment.centerRight,
            color: Colors.white,
            icon: Icon(Icons.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    ]));
  }
}
