import 'package:flutter/material.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/screens/contentDetailScreen.dart';

class ContentGrid extends StatelessWidget {
  final List<Content> contents;

  const ContentGrid({Key key, @required this.contents}) : super(key: key);

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
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.65,
      ),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        Content content = contents[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context, _createRoute(ContentDetails(content: content)));
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(content.poster),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }, childCount: contents.length),
    );
  }
}
