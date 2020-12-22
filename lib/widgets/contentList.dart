import 'package:flutter/material.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/screens/contentDetailScreen.dart';

class ContentList extends StatelessWidget {
  final String title;
  final List<Content> contentList;
  final bool isOriginals;

  const ContentList(
      {Key key,
      @required this.title,
      @required this.contentList,
      this.isOriginals = false})
      : super(key: key);

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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Container(
        height: isOriginals ? 500.0 : 220.0,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: contentList.length,
          itemBuilder: (BuildContext context, int index) {
            final Content content = contentList[index];
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, _createRoute(ContentDetails(content: content)));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  height: isOriginals ? 400.0 : 200.0,
                  width: isOriginals ? 200.0 : 130.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(content.poster),
                      fit: BoxFit.cover,
                    ),
                  ),
                ));
          },
        ),
      )
    ]);
  }
}
