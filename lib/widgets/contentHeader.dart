import 'package:flutter/material.dart';
import 'package:flutterflix/data/data.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/screens/contentDetailScreen.dart';
import 'package:flutterflix/widgets/customVideoPlayer.dart';
import 'package:flutterflix/widgets/verticalIconButton.dart';

enum ContentHeaderType { Home, Details, Previews }

class ContentHeader extends StatefulWidget {
  final Content content;
  final ContentHeaderType type;
  final CustomVideoPlayer videoPlayer;

  const ContentHeader(
      {Key key, @required this.content, @required this.type, this.videoPlayer})
      : super(key: key);

  @override
  _ContentHeaderState createState() => _ContentHeaderState();
}

class _ContentHeaderState extends State<ContentHeader> {
  Widget get contentRatings {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '${widget.content.percentMatch}% Match',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color.fromRGBO(0, 255, 0, 0.8),
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        Text(
          widget.content.year.toString(),
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.6),
            fontWeight: FontWeight.w400,
            fontSize: 12.0,
          ),
        ),
        Text(
          '${widget.content.rating} +',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.6),
            fontWeight: FontWeight.w400,
            fontSize: 12.0,
          ),
        ),
        Text(
          durationToString(widget.content.duration),
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.6),
            fontWeight: FontWeight.w400,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget get header {
    return Container(
      height:
          widget.type == ContentHeaderType.Previews ? double.infinity : 500.0,
      child: widget.type == ContentHeaderType.Previews
          ? widget.videoPlayer
          : Image(
              image: AssetImage(widget.content.imageUrl),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}h ${parts[1].padLeft(2, '0')}m';
  }

  Route _createRoute(Widget newPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => newPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      header,
      Container(
        height:
            widget.type == ContentHeaderType.Previews ? double.infinity : 501.0,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter)),
      ),
      Positioned(
        bottom: 110.0,
        child: SizedBox(
            width: 250.0,
            child: widget.type == ContentHeaderType.Details
                ? contentRatings
                : Image.asset(widget.content.titleImageUrl)),
      ),
      Positioned(
          left: 0,
          right: 0,
          bottom: 40.0,
          child: widget.type == ContentHeaderType.Details
              ? _PlayButton()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    VerticalIconButton(
                      icon: myList.contains(widget.content)
                          ? Icons.check
                          : Icons.add,
                      title: 'List',
                      onTap: () {
                        if (myList.contains(widget.content))
                          myList.remove(widget.content);
                        else
                          myList.add(widget.content);

                        setState(() {});
                      },
                    ),
                    _PlayButton(),
                    VerticalIconButton(
                      icon: Icons.info_outline,
                      title: 'Info',
                      onTap: () => Navigator.push(
                          context,
                          _createRoute(
                              ContentDetails(content: widget.content))),
                    ),
                  ],
                ))
    ]);
  }
}

class _PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
        padding: const EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
        onPressed: () => print('Play'),
        color: Colors.white,
        icon: const Icon(Icons.play_arrow, size: 30.0),
        label: const Text(
          'Play',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ));
  }
}
