import 'package:flutter/material.dart';
import 'package:flutterflix/database/clouddata.dart';
import 'package:flutterflix/helpers/logicHelpers.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/widgets/contentGrid.dart';
import 'package:flutterflix/widgets/notificationBox.dart';
import 'package:flutterflix/widgets/widgets.dart';

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
  Content feature;
  List<Content> modifiedMyList;
  List<Content> modifiedPreviews;
  List<Content> modifiedOriginals;
  List<Content> modifiedTrending;

  bool showingNotification;

  OverlayEntry _overlayEntry;

  final double appBarSize = 50.0;

  String genre;
  String searchString;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });

    if (widget.type == HomeScreenType.tvshows ||
        widget.type == HomeScreenType.movies) {
      String category = widget.category;

      if (category == ContentCategory.MOVIES)
        feature = Cloud.featureMovie;
      else if (category == ContentCategory.TV_SHOW) feature = Cloud.featureTv;

      modifiedPreviews =
          Cloud.previews.where((el) => el.category == category).toList();
      modifiedOriginals =
          Cloud.originals.where((el) => el.category == category).toList();
      modifiedTrending =
          Cloud.trending.where((el) => el.category == category).toList();

      modifiedMyList =
          Cloud.myList.where((el) => el.category == category).toList();
    } else if (widget.type == HomeScreenType.none) {
      feature = Cloud.featureHome;
      modifiedMyList = Cloud.myList;
      modifiedPreviews = Cloud.previews;
      modifiedOriginals = Cloud.originals;
      modifiedTrending = Cloud.trending;
    } else if (widget.type == HomeScreenType.mylist) {
      modifiedMyList = Cloud.myList;
    }

    genre = Cloud.genres[0];
    searchString = "";

    showingNotification = false;

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  OverlayEntry get _createOverlayEntry {
    return OverlayEntry(builder: (context) {
      return Positioned(
        right: 20.0,
        top: appBarSize + 10.0,
        width: NotificationBox.width,
        child: NotificationBox(
            notifications: Cloud.notificationList,
            hideNotification: removeNotification),
      );
    });
  }

  void showNotification() {
    if (showingNotification)
      _overlayEntry.remove();
    else {
      _overlayEntry = _createOverlayEntry;

      Overlay.of(context).insert(_overlayEntry);
    }

    setState(() {
      showingNotification = !showingNotification;
    });
  }

  void removeNotification() {
    if (!showingNotification) return;

    _overlayEntry.remove();

    setState(() {
      showingNotification = false;
    });
  }

  void changeGenre(String newGenre) {
    if (newGenre == Cloud.genres[0]) {
      return;
    }

    setState(() {
      genre = newGenre;
      modifiedMyList = Cloud.allContent
          .where((el) =>
              el.category == widget.category && el.genres.contains(genre))
          .toList();
    });
  }

  void onSearch(String newSearchString) {
    setState(() {
      searchString = newSearchString;

      modifiedMyList = Cloud.allContent
          .where((content) => searchFilter(content, newSearchString))
          .toList();
    });
  }

  List<Widget> get multiList {
    return [
      SliverToBoxAdapter(
          child: ContentHeader(content: feature, type: ContentHeaderType.Home)),
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
      SliverFillRemaining(
        child: ContentGrid(
          contents: modifiedMyList,
        ),
      )
    ];
  }

  bool get showGrid {
    if (widget.type == HomeScreenType.mylist || searchString.isNotEmpty)
      return true;
    else if (widget.type == HomeScreenType.movies ||
        widget.type == HomeScreenType.tvshows) {
      if (genre != Cloud.genres[0]) return true;
    }

    return false;
  }

  Future<bool> willPop() async {
    if (searchString != null && searchString.isNotEmpty) {
      FocusScope.of(context).unfocus();
      setState(() {
        searchString = '';
        modifiedMyList = [];
      });
      return false;
    }

    if (Navigator.canPop(context)) Navigator.of(context).pop();

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: Size(screenSize.width, appBarSize),
            child: Listener(
              onPointerUp: (_) => removeNotification(),
              child: CustomAppBar(
                scrollOffset: _scrollOffset,
                appBarType: widget.type == HomeScreenType.none
                    ? CustomAppBarType.home
                    : CustomAppBarType.custom_home,
                category: widget.category,
                onGenreChange: changeGenre,
                onSearchChange: onSearch,
                showNotification: showNotification,
                genre: genre,
              ),
            )),
        body: Listener(
          onPointerUp: (_) => removeNotification(),
          child: CustomScrollView(
              controller: _scrollController,
              slivers: showGrid ? singleGrid : multiList),
        ),
      ),
    );
  }
}
