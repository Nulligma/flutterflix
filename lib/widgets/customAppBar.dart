import 'package:flutter/material.dart';
import 'package:flutterflix/assets.dart';
import 'package:flutterflix/screens/homeScreen.dart';
import 'package:flutterflix/data/data.dart';

enum CustomAppBarType { home, content, custom_home, search }

class CustomAppBar extends StatelessWidget {
  final double scrollOffset;
  final CustomAppBarType type;
  final String category;
  final String genre;
  final Function onChange;

  const CustomAppBar(
      {Key key,
      @required this.scrollOffset,
      @required this.type,
      this.category,
      this.genre,
      this.onChange})
      : super(key: key);

  Widget get appBar {
    switch (type) {
      case CustomAppBarType.home:
        return _CustomAppBarMobile();
      case CustomAppBarType.custom_home:
        return _CategoryAppBar(
          category: category,
          onChange: onChange,
          genre: genre,
        );
      case CustomAppBarType.content:
        return _ConetentDetailsAppBar();
      case CustomAppBarType.search:
        return _SearchAppBar(
          onChanged: onChange,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 24.0,
      ),
      color: Colors.black
          .withOpacity((scrollOffset / 350).clamp(0, 0.85).toDouble()),
      child: appBar,
    );
  }
}

class _SearchAppBar extends StatelessWidget {
  final Function onChanged;

  const _SearchAppBar({Key key, this.onChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white30,
                filled: true,
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: 'Search name, cast, genre, details',
                hintStyle: const TextStyle(
                  color: Colors.white54,
                  fontSize: 16.0,
                ),
              ),
              autofocus: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConetentDetailsAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IconButton(
        alignment: Alignment.centerRight,
        color: Colors.white,
        icon: Icon(Icons.cancel),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _CategoryAppBar extends StatelessWidget {
  final String category;
  final Function onChange;
  final String genre;

  const _CategoryAppBar({Key key, this.category, this.onChange, this.genre})
      : super(key: key);

  bool get showGenreSelector {
    return (category == ContentCategory.TV_SHOW ||
        category == ContentCategory.MOVIES);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          IconButton(
            iconSize: 16.0,
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                showGenreSelector
                    ? DropdownButton<String>(
                        value: genre,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        dropdownColor: Color.fromRGBO(0, 0, 0, 0.8),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.white,
                        ),
                        onChanged: (String newValue) {
                          onChange(newValue);
                        },
                        items: genres.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList())
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomAppBarMobile extends StatelessWidget {
  Route _createRoute(Widget newPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => newPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
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
    return SafeArea(
      child: Row(
        children: [
          Image.asset(Assets.netflixLogo0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AppBarButton(
                  title: ContentCategory.TV_SHOW,
                  onTap: () =>
                      Navigator.of(context).push(_createRoute(HomeScreen(
                    type: HomeScreenType.tvshows,
                    category: ContentCategory.TV_SHOW,
                  ))),
                ),
                _AppBarButton(
                  title: ContentCategory.MOVIES,
                  onTap: () => Navigator.of(context).push(_createRoute(
                      HomeScreen(
                          type: HomeScreenType.movies,
                          category: ContentCategory.MOVIES))),
                ),
                _AppBarButton(
                  title: 'My List',
                  onTap: () => Navigator.of(context).push(_createRoute(
                      HomeScreen(
                          type: HomeScreenType.mylist, category: 'My List'))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  final String title;
  final Function onTap;

  const _AppBarButton({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
