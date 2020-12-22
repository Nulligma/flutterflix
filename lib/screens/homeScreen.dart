import 'package:flutter/material.dart';
import 'package:flutterflix/data/data.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/widgets/contentGrid.dart';
import 'package:flutterflix/widgets/widgets.dart';
import 'dart:math';

enum HomeScreenType {
  none,
  movies,
  tvshows,
  mylist,
}

class ContentCategory {
  static const String TV_SHOW = "TV Shows";
  static const String MOVIES = "Movies";
}

class HomeScreen extends StatefulWidget {
  final HomeScreenType type;
  final String category;

  const HomeScreen({Key key, this.type, this.category}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController;
  double _scrollOffset = 0.0;
  int randomFeatureIndex;
  List<Content> modifiedFeatures;
  List<Content> modifiedMyList;
  List<Content> modifiedPreviews;
  List<Content> modifiedOriginals;
  List<Content> modifiedTrending;

  String genre;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });

    if (widget.type != HomeScreenType.none &&
        widget.type != HomeScreenType.mylist) {
      String category = widget.category;

      modifiedFeatures =
          feature.where((el) => el.category == category).toList();
      modifiedPreviews =
          previews.where((el) => el.category == category).toList();
      modifiedOriginals =
          originals.where((el) => el.category == category).toList();
      modifiedTrending =
          trending.where((el) => el.category == category).toList();
      modifiedMyList = myList.where((el) => el.category == category).toList();
    } else {
      modifiedFeatures = feature;
      modifiedMyList = myList;
      modifiedPreviews = previews;
      modifiedOriginals = originals;
      modifiedTrending = trending;
    }

    randomFeatureIndex = Random().nextInt(modifiedFeatures.length);
    genre = genres[0];

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void changeGenre(String newGenre) {
    if (newGenre == genres[0]) {
      return;
    }

    setState(() {
      genre = newGenre;
      modifiedMyList = allContent
          .where((el) =>
              el.category == widget.category && el.genres.contains(genre))
          .toList();
    });
  }

  List<Widget> get multiList {
    return [
      SliverToBoxAdapter(
          child: ContentHeader(
              content: modifiedFeatures[randomFeatureIndex],
              type: ContentHeaderType.Home)),
      SliverPadding(
        padding: const EdgeInsets.only(top: 20.0),
        sliver: SliverToBoxAdapter(
          child: ContentList(
            title: 'My List',
            contentList: modifiedMyList,
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(top: 20.0),
        sliver: SliverToBoxAdapter(
          child: Previews(
            title: 'Previews',
            contentList: modifiedPreviews,
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(top: 20.0),
        sliver: SliverToBoxAdapter(
          child: ContentList(
            title: 'Netflix Originals',
            contentList: modifiedOriginals,
            isOriginals: true,
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(top: 20.0),
        sliver: SliverToBoxAdapter(
          child: ContentList(
            title: 'Trending',
            contentList: modifiedTrending,
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 20.0,
        ),
      )
    ];
  }

  List<Widget> get singleGrid {
    return [
      SliverToBoxAdapter(
        child: SizedBox(
          height: 75.0,
        ),
      ),
      ContentGrid(contents: modifiedMyList),
    ];
  }

  bool get showGrid {
    if (widget.type == HomeScreenType.mylist)
      return true;
    else if (widget.type == HomeScreenType.movies ||
        widget.type == HomeScreenType.tvshows) {
      if (genre != genres[0]) return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 50.0),
          child: CustomAppBar(
            scrollOffset: _scrollOffset,
            type: widget.type == HomeScreenType.none
                ? CustomAppBarType.home
                : CustomAppBarType.custom_home,
            category: widget.category,
            onChange: changeGenre,
            genre: genre,
          )),
      body: CustomScrollView(
          controller: _scrollController,
          slivers: showGrid ? singleGrid : multiList),
    );
  }
}
