import 'package:flutter/material.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/screens/contentDetailScreen.dart';
import 'package:flutterflix/helpers/uiHelpers.dart';
import 'package:flutterflix/widgets/responsive.dart';

class ContentGrid extends StatelessWidget {
  final List<Content> contents;
  final bool scrollLock;

  const ContentGrid({Key key, @required this.contents, this.scrollLock = false})
      : super(key: key);

  int gridCrossAxisCount(BuildContext context) {
    if (Responsive.isMobile(context)) return 3;
    if (Responsive.isTablet(context)) return 6;
    if (Responsive.isDesktop(context))
      return 9;
    else
      return 3;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: scrollLock
            ? NeverScrollableScrollPhysics()
            : AlwaysScrollableScrollPhysics(),
        shrinkWrap: scrollLock,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridCrossAxisCount(context),
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.65,
        ),
        itemCount: contents.length,
        itemBuilder: (BuildContext context, int index) {
          Content content = contents[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  createRoute(ContentDetails(content: content),
                      Offset(0.0, 1.0), Offset.zero));
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
        });
  }
}
