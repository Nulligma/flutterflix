import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterflix/admin/widgets/compactList.dart';
import 'package:flutterflix/admin/widgets/secondaryForm.dart';
import 'package:flutterflix/database/clouddata.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/screens/screens.dart';
import 'package:flutterflix/widgets/responsive.dart';

class Dashboard extends StatefulWidget {
  final Function onCreateContent;

  const Dashboard({Key key, this.onCreateContent}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Content _homeFeature;
  Content _tvFeature;
  Content _movieFeature;

  @override
  void initState() {
    super.initState();

    _homeFeature = Cloud.featureHome;
    _tvFeature = Cloud.featureTv;
    _movieFeature = Cloud.featureMovie;
  }

  List<StaggeredTile> _staggeredTilesDesktop = const <StaggeredTile>[
    const StaggeredTile.count(4, 1),
    const StaggeredTile.count(3, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(3, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
  ];

  List<StaggeredTile> _staggeredTilesMobile = const <StaggeredTile>[
    const StaggeredTile.count(4, 1),
    const StaggeredTile.count(4, 1),
    const StaggeredTile.count(4, 1),
    const StaggeredTile.count(4, 1),
    const StaggeredTile.count(4, 1),
    const StaggeredTile.count(2, 3),
    const StaggeredTile.count(2, 3),
    const StaggeredTile.count(2, 3),
    const StaggeredTile.count(2, 3),
  ];

  List<Widget> get _tiles {
    return <Widget>[
      _FeaturedTile(
        message: "Featured Home",
        content: _homeFeature,
        onTap: (String newValue) {
          Content target = Cloud.allContent
              .firstWhere((Content content) => content.name == newValue);
          setState(() {
            _homeFeature = target;
          });
        },
      ),
      _FeaturedTile(
        message: "Featured Movie",
        content: _movieFeature,
        category: ContentCategory.MOVIES,
        onTap: (String newValue) {
          Content target = Cloud.allContent
              .firstWhere((Content content) => content.name == newValue);
          setState(() {
            _movieFeature = target;
          });
        },
      ),
      _FlatTile(Colors.indigo, Icons.movie_creation_outlined, "Add new Movie",
          () {
        widget.onCreateContent(Content.blank(ContentCategory.MOVIES));
      }),
      _FeaturedTile(
        message: "Featured TV Show",
        category: ContentCategory.TV_SHOW,
        content: _tvFeature,
        onTap: (String newValue) {
          Content target = Cloud.allContent
              .firstWhere((Content content) => content.name == newValue);
          setState(() {
            _tvFeature = target;
          });
        },
      ),
      _FlatTile(Colors.orange, Icons.tv, "Add new TV show", () {
        widget.onCreateContent(Content.blank(ContentCategory.TV_SHOW));
      }),
      CompactList(
        contentNames: Cloud.trending.map((Content val) => val.name).toList(),
        backColor: Colors.red[800],
        headColor: Colors.red,
        heading: "Trending",
        onDelete: (int index) {
          removeFromCompactList(Cloud.trending, index);
        },
        onAdd: (String val) {
          addToCompactList(Cloud.trending, val);
        },
      ),
      CompactList(
          contentNames: Cloud.originals.map((Content val) => val.name).toList(),
          backColor: Colors.brown[800],
          headColor: Colors.brown,
          heading: "Originals",
          onDelete: (int index) {
            removeFromCompactList(Cloud.originals, index);
          },
          onAdd: (String val) {
            addToCompactList(Cloud.originals, val);
          }),
      CompactList(
          contentNames:
              Cloud.topSearches.map((Content val) => val.name).toList(),
          backColor: Colors.green[800],
          headColor: Colors.green,
          heading: "Top Searches",
          onDelete: (int index) {
            removeFromCompactList(Cloud.topSearches, index);
          },
          onAdd: (String val) {
            addToCompactList(Cloud.topSearches, val);
          }),
      CompactList(
          contentNames: Cloud.previews.map((Content val) => val.name).toList(),
          backColor: Colors.cyan[800],
          headColor: Colors.cyan,
          heading: "Previews",
          onDelete: (int index) {
            removeFromCompactList(Cloud.previews, index);
          },
          onAdd: (String val) {
            addToCompactList(Cloud.previews, val);
          }),
    ];
  }

  void addToCompactList(List list, String newValue) {
    Content target = Cloud.allContent
        .firstWhere((Content content) => content.name == newValue);

    setState(() {
      list.add(target);
    });
  }

  void removeFromCompactList(List list, int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      crossAxisCount: 4,
      staggeredTiles: Responsive.isMobile(context)
          ? _staggeredTilesMobile
          : _staggeredTilesDesktop,
      children: _tiles,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      padding: const EdgeInsets.all(4.0),
    );
  }
}

class _FlatTile extends StatelessWidget {
  const _FlatTile(
      this.backgroundColor, this.iconData, this.message, this.onTap);

  final Color backgroundColor;
  final IconData iconData;
  final String message;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Icon(
              iconData,
              size: 42,
              color: Colors.white,
            ),
            Text(
              message,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class _FeaturedTile extends StatelessWidget {
  final String message;
  final Content content;
  final Function onTap;
  final String category;

  _FeaturedTile(
      {Key key, this.message, this.content, this.onTap, this.category})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Content> contents;
    if (category == ContentCategory.MOVIES ||
        category == ContentCategory.TV_SHOW) {
      contents =
          Cloud.allContent.where((el) => el.category == category).toList();
    } else
      contents = Cloud.allContent;

    return Card(
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              child: SecondaryForm(
                onConfirm: onTap,
                itemList: contents.map((c) => c.name).toList(),
                initValue: content.name,
                title: "Change current feature",
                type: SecondaryFormType.TextList,
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(content.imageUrlLandscape),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(),
                Expanded(
                  flex: 2,
                  child: Image.network(content.titleImageUrl),
                ),
                Spacer(),
                Expanded(
                  flex: 1,
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    /*  Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            height: 500.0,
            width: 1200.0,
            child: Image(
              image: NetworkImage(atla.imageUrlLandscape),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ),
        Container(
          height: 501.0,
          width: MediaQuery.of(context).size.width - 200.0,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.black,
            Colors.black87,
            Colors.black38,
            Colors.transparent
          ], stops: [
            0.2,
            0.4,
            0.6,
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
                SizedBox(
                  width: 250.0,
                  child: Image.network(atla.titleImageUrl),
                ),
                const SizedBox(height: 15.0),
                Container(
                  width: 500.0,
                  child: Text(
                    message,
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
              ],
            )),
      ],
    ); */
  }
}
