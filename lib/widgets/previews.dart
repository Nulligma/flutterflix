import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterflix/helpers/uiHelpers.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/screens/previewScreen.dart';

class Previews extends StatelessWidget {
  final String title;
  final List<Content>? contentList;

  const Previews({Key? key, required this.title, required this.contentList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          height: 165.0,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 8.0,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: contentList!.length,
            itemBuilder: (BuildContext context, int index) {
              final Content content = contentList![index];

              return InkWell(
                onTap: () => Navigator.of(context).push(createRoute(
                    PreviewScreen(
                      startingContent: index,
                      previewContents: contentList!,
                    ),
                    Offset(0.0, 1.0),
                    Offset.zero)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl: content.poster!,
                      imageBuilder: (context, imageProvider) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        height: 130.0,
                        width: 130.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: content.color!, width: 2.5),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Container(
                      height: 130.0,
                      width: 130.0,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.black87,
                            Colors.black45,
                            Colors.transparent,
                          ],
                          stops: [0, 0.25, 1],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SizedBox(
                        height: 35.0,
                        child: CachedNetworkImage(
                            imageUrl: content.titleImageUrl!),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
