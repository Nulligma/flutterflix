import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterflix/assets.dart';
import 'package:flutterflix/database/clouddata.dart';
import 'package:flutterflix/helpers/uiHelpers.dart';
import 'package:flutterflix/screens/homeScreen.dart';
import 'package:flutterflix/screens/profileScreen.dart';
import 'package:flutterflix/widgets/responsive.dart';

enum CustomAppBarType { home, custom_home }

class CustomAppBar extends StatelessWidget {
  final double scrollOffset;
  final CustomAppBarType appBarType;
  final String category;
  final String genre;
  final Function onGenreChange;
  final Function onSearchChange;
  final Function showNotification;

  const CustomAppBar(
      {Key key,
      @required this.scrollOffset,
      @required this.appBarType,
      this.category,
      this.genre,
      this.onGenreChange,
      this.onSearchChange,
      this.showNotification})
      : super(key: key);

  Widget get appBarMobile {
    if (appBarType == CustomAppBarType.home)
      return _CustomAppBarMobile();
    else
      return _CategoryAppBarMobile(
        category: category,
        onGenreChange: onGenreChange,
        genre: genre,
      );
  }

  Widget get appBarDesktop {
    String subHeading;

    if (category == null) {
      if (appBarType == CustomAppBarType.custom_home)
        subHeading = "My List";
      else
        subHeading = "Home";
    } else
      subHeading = category;

    return _CustomAppBarDesktop(
      onSearchChange: onSearchChange,
      category: category,
      onGenreChange: onGenreChange,
      genre: genre,
      subHeading: subHeading,
      showNotification: showNotification,
    );
  }

  double get opacity {
    if (scrollOffset > 350) return 0.85;

    if (scrollOffset < 40)
      return 0.0;
    else if (scrollOffset < 80)
      return 0.1;
    else if (scrollOffset < 120)
      return 0.2;
    else if (scrollOffset < 160)
      return 0.3;
    else if (scrollOffset < 200)
      return 0.4;
    else if (scrollOffset < 240)
      return 0.5;
    else if (scrollOffset < 280)
      return 0.6;
    else if (scrollOffset < 320)
      return 0.7;
    else
      return 0.8;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 24.0,
      ),
      color: Colors.black.withOpacity(opacity),
      child: Responsive(
        mobile: appBarMobile,
        desktop: appBarDesktop,
      ),
    );
  }
}

class _CategoryAppBarMobile extends StatelessWidget {
  final String category;
  final Function onGenreChange;
  final String genre;

  const _CategoryAppBarMobile(
      {Key key, this.category, this.onGenreChange, this.genre})
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
                          onGenreChange(newValue);
                        },
                        items: Cloud.genres.map((value) {
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Image.network(Assets.netflixLogo0),
          const SizedBox(width: 12.0),
          Expanded(
            child: _NavigationButtons(),
          ),
        ],
      ),
    );
  }
}

class _CustomAppBarDesktop extends StatelessWidget {
  final Function onSearchChange;
  final Function onGenreChange;
  final String genre;
  final String category;
  final String subHeading;
  final Function showNotification;

  const _CustomAppBarDesktop(
      {Key key,
      this.onSearchChange,
      this.category,
      this.onGenreChange,
      this.genre,
      this.subHeading,
      this.showNotification})
      : super(key: key);

  Widget get navigations {
    switch (subHeading) {
      case "My List":
        return subHeadingWidget;
      case "Home":
        return _NavigationButtons();
      case ContentCategory.TV_SHOW:
      case ContentCategory.MOVIES:
        return categoryRow;
      default:
        return Container();
    }
  }

  Widget get subHeadingWidget {
    return Text(
      subHeading,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget get categoryRow {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        subHeadingWidget,
        DropdownButton<String>(
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
              onGenreChange(newValue);
            },
            items: Cloud.genres.map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          InkWell(
              child: Image.network(Assets.netflixLogo1),
              onTap: () {
                if (category != null) Navigator.of(context).pop();
              }),
          const SizedBox(width: 12.0),
          Expanded(
            child: navigations,
          ),
          const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextField(
                    onChanged: onSearchChange,
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
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.notifications),
                  iconSize: 28.0,
                  color: Colors.white,
                  onPressed: showNotification,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.account_circle),
                  iconSize: 28.0,
                  color: Colors.white,
                  onPressed: () => Navigator.of(context).push(createRoute(
                      ProfileScreen(), Offset(1.0, 0.0), Offset.zero)),
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
    return TextButton(
      onPressed: onTap,
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

class _NavigationButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _AppBarButton(
          title: ContentCategory.TV_SHOW,
          onTap: () => Navigator.of(context).push(createRoute(
              HomeScreen(
                type: HomeScreenType.tvshows,
                category: ContentCategory.TV_SHOW,
              ),
              Offset(1.0, 0.0),
              Offset.zero)),
        ),
        _AppBarButton(
          title: ContentCategory.MOVIES,
          onTap: () => Navigator.of(context).push(createRoute(
              HomeScreen(
                  type: HomeScreenType.movies,
                  category: ContentCategory.MOVIES),
              Offset(1.0, 0.0),
              Offset.zero)),
        ),
        _AppBarButton(
          title: 'My List',
          onTap: () => Navigator.of(context).push(createRoute(
              HomeScreen(type: HomeScreenType.mylist, category: 'My List'),
              Offset(1.0, 0.0),
              Offset.zero)),
        ),
      ],
    );
  }
}
