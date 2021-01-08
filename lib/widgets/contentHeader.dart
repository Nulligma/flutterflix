import 'package:flutter/material.dart';
import 'package:flutterflix/data/data.dart';
import 'package:flutterflix/helpers/uiHelpers.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/screens/contentDetailScreen.dart';
import 'package:flutterflix/widgets/contentDescription.dart';
import 'package:flutterflix/widgets/customVideoPlayer.dart';
import 'package:flutterflix/widgets/responsive.dart';
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

  Widget get headerMobile {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: widget.type == ContentHeaderType.Previews
              ? double.infinity
              : 500.0,
          child: widget.type == ContentHeaderType.Previews
              ? widget.videoPlayer
              : Image(
                  image: AssetImage(widget.content.imageUrl),
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
        ),
        Container(
          height: widget.type == ContentHeaderType.Previews
              ? double.infinity
              : 501.0,
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
                            createRoute(ContentDetails(content: widget.content),
                                Offset(0.0, 1.0), Offset.zero)),
                      ),
                    ],
                  ))
      ],
    );
  }

  Widget get headerDesktop {
    return Stack(children: [
      Align(
        alignment: Alignment.centerRight,
        child: Container(
          height: widget.type == ContentHeaderType.Previews
              ? double.infinity
              : 500.0,
          width: 1200.0,
          child: widget.type == ContentHeaderType.Previews
              ? widget.videoPlayer
              : Image(
                  image: AssetImage(widget.content.imageUrlLandscape),
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
        ),
      ),
      Container(
        height:
            widget.type == ContentHeaderType.Previews ? double.infinity : 501.0,
        width: MediaQuery.of(context).size.width - 200.0,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.black,
          Colors.black87,
          Colors.black38,
          Colors.transparent
        ], stops: [
          0.4,
          0.6,
          0.8,
          1
        ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
      ),
      Positioned(
          left: 60.0,
          right: 60.0,
          top: 100.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.type == ContentHeaderType.Details
                  ? Container()
                  : SizedBox(
                      width: 250.0,
                      child: Image.asset(widget.content.titleImageUrl),
                    ),
              const SizedBox(height: 15.0),
              Container(
                width: 500.0,
                child: Text(
                  widget.content.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2.0, 4.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                ),
              ),
              widget.type == ContentHeaderType.Details
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15.0),
                        Container(
                          width: 250.0,
                          child: contentRatings,
                        ),
                        Container(
                          width: 500.0,
                          child: ContentDescription(
                            content: widget.content,
                            setState: setState,
                            noDescription: true,
                          ),
                        )
                      ],
                    )
                  : Container(),
              const SizedBox(height: 50.0),
              Row(
                children: [
                  _PlayButton(),
                  const SizedBox(width: 16.0),
                  widget.type == ContentHeaderType.Details
                      ? Container()
                      : FlatButton.icon(
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
                          onPressed: () => Navigator.push(
                              context,
                              createRoute(
                                  ContentDetails(content: widget.content),
                                  Offset(0.0, 1.0),
                                  Offset.zero)),
                          color: Colors.white,
                          icon: const Icon(Icons.info_outline, size: 30.0),
                          label: const Text(
                            'More Info',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                  const SizedBox(width: 20.0),
                ],
              ),
            ],
          )),
    ]);
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}h ${parts[1].padLeft(2, '0')}m';
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: headerMobile,
      desktop: headerDesktop,
    );
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
