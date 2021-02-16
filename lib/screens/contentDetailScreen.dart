import 'package:flutter/material.dart';
import 'package:flutterflix/database/clouddata.dart';
import 'package:flutterflix/helpers/uiHelpers.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/models/episodeModel.dart';
import 'package:flutterflix/models/trailerModel.dart';
import 'package:flutterflix/screens/homeScreen.dart';
import 'package:flutterflix/widgets/contentDescription.dart';
import 'package:flutterflix/widgets/contentGrid.dart';
import 'package:flutterflix/widgets/customVideoPlayer.dart';
import 'package:flutterflix/widgets/responsive.dart';
import 'package:flutterflix/widgets/widgets.dart';

class ContentDetails extends StatefulWidget {
  final Content content;

  const ContentDetails({Key key, this.content}) : super(key: key);

  @override
  _ContentDetailsState createState() => _ContentDetailsState();
}

class _ContentDetailsState extends State<ContentDetails>
    with SingleTickerProviderStateMixin {
  String currentSeason;

  List<Tab> contentTabs;
  List<Episode> seasonEpisodes;

  TabController _tabController;
  int selectedIndex = 0;

  bool episodesLoaded;
  bool trailersLoaded;

  @override
  void initState() {
    super.initState();
    episodesLoaded = trailersLoaded = true;

    if (widget.content.category == ContentCategory.TV_SHOW) {
      if (widget.content.episodes.length == 0) {
        episodesLoaded = trailersLoaded = false;
        Cloud.getEpisodes(widget.content).then((_) {
          episodesLoaded = true;
          Cloud.getTrailers(widget.content).then((_) {
            trailersLoaded = true;
            initRest();
            setState(() {});
          });
        });
      } else
        initRest();
    } else if (widget.content.category == ContentCategory.MOVIES) {
      if (widget.content.trailers.length == 0) {
        trailersLoaded = false;
        Cloud.getTrailers(widget.content).then((_) {
          trailersLoaded = true;
          initRest();
          setState(() {});
        });
      } else
        initRest();
    }
  }

  void initRest() {
    if (widget.content.category == ContentCategory.MOVIES) {
      contentTabs = <Tab>[
        Tab(text: 'TRAILERS & MORE'),
        Tab(text: 'MORE LIKE THIS'),
      ];
    } else {
      contentTabs = <Tab>[
        Tab(text: 'EPISODES'),
        Tab(text: 'TRAILERS & MORE'),
        Tab(text: 'MORE LIKE THIS'),
      ];

      currentSeason = widget.content.seasons[0];

      seasonEpisodes = widget.content.episodes
          .where((Episode e) => e.seasonName == currentSeason)
          .toList();
    }

    _tabController = TabController(
        initialIndex: selectedIndex, vsync: this, length: contentTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void changeCurrentSeason(String newSeason) {
    setState(() {
      currentSeason = newSeason;

      seasonEpisodes = widget.content.episodes
          .where((Episode e) => e.seasonName == currentSeason)
          .toList();
    });
  }

  List<Widget> get tabs {
    if (widget.content.category == ContentCategory.MOVIES) {
      return [
        Visibility(
          child: _TrailerList(
            trailers: widget.content.trailers,
          ),
          maintainState: true,
          visible: selectedIndex == 0,
        ),
        Visibility(
          child: ContentGrid(
            contents: Cloud.allContent,
            scrollLock: true,
          ),
          maintainState: true,
          visible: selectedIndex == 1,
        ),
      ];
    } else {
      return [
        Visibility(
          child: _EpisodeList(
              currentSeason: currentSeason,
              changeCurrentSeason: changeCurrentSeason,
              seasonEpisodes: seasonEpisodes,
              content: widget.content),
          maintainState: true,
          visible: selectedIndex == 0,
        ),
        Visibility(
          child: _TrailerList(
            trailers: widget.content.trailers,
          ),
          maintainState: true,
          visible: selectedIndex == 1,
        ),
        Visibility(
          child: ContentGrid(
            contents: Cloud.allContent,
            scrollLock: true,
          ),
          maintainState: true,
          visible: selectedIndex == 2,
        )
      ];
    }
  }

  Widget get contentListForDesktop {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.content.category == ContentCategory.MOVIES
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "EPISODES",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 185.0,
                    child: _EpisodeList(
                        currentSeason: currentSeason,
                        changeCurrentSeason: changeCurrentSeason,
                        seasonEpisodes: seasonEpisodes,
                        content: widget.content),
                  ),
                ],
              ),
        SizedBox(
          height: 30.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "TRAILERS & MORE",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 133.0,
          child: _TrailerList(
            trailers: widget.content.trailers,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        ContentList(
          title: 'MORE LIKE THIS',
          contentList: Cloud.allContent
              .where((Content c) =>
                  c.genres.any((String s) => widget.content.genres.contains(s)))
              .toList(),
        ),
        SizedBox(
          height: 50.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.content.name),
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
      body: episodesLoaded && trailersLoaded
          ? SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  ContentHeader(
                      content: widget.content, type: ContentHeaderType.Details),
                  Responsive(
                    desktop: Container(),
                    mobile: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ContentDescription(
                        content: widget.content,
                        setState: setState,
                        noDescription: false,
                      ),
                    ),
                  ),
                  Responsive(
                    desktop: contentListForDesktop,
                    mobile: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: TabBar(
                            controller: _tabController,
                            tabs: contentTabs,
                            onTap: (int index) {
                              setState(() {
                                selectedIndex = index;
                                _tabController.animateTo(index);
                              });
                            },
                          ),
                        ),
                        IndexedStack(index: selectedIndex, children: tabs)
                      ],
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class _EpisodeList extends StatelessWidget {
  final String currentSeason;
  final Function changeCurrentSeason;
  final List<Episode> seasonEpisodes;
  final Content content;

  const _EpisodeList(
      {Key key,
      @required this.currentSeason,
      @required this.changeCurrentSeason,
      @required this.seasonEpisodes,
      @required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Responsive.isDesktop(context) || Responsive.isTablet(context)
              ? EdgeInsets.symmetric(horizontal: 24.0)
              : EdgeInsets.zero,
          child: DropdownButton<String>(
              value: currentSeason,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              onChanged: (String newValue) => {changeCurrentSeason(newValue)},
              dropdownColor: Color.fromRGBO(0, 0, 0, 0.8),
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.6),
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
              ),
              underline: Container(
                height: 2,
                color: Colors.white60,
              ),
              items: content.seasons.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()),
        ),
        Responsive(
          desktop: Container(
            height: 133.0,
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: seasonEpisodes.length,
                itemBuilder: (BuildContext context, int index) {
                  return _EpisodeTile(
                    index: index,
                    seasonEpisodes: seasonEpisodes,
                  );
                }),
          ),
          mobile: ListView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: seasonEpisodes.length,
              itemBuilder: (BuildContext context, int index) {
                return _EpisodeTile(
                  index: index,
                  seasonEpisodes: seasonEpisodes,
                );
              }),
        ),
      ],
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  final int index;
  final List<Episode> seasonEpisodes;

  const _EpisodeTile({
    Key key,
    this.index,
    this.seasonEpisodes,
  }) : super(key: key);

  Widget episodeForMobile(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    createRoute(
                        Scaffold(
                          appBar: AppBar(
                            title: Text(seasonEpisodes[index].name),
                          ),
                          backgroundColor: Colors.black,
                          body: CustomVideoPlayer(
                              type: PlayerType.content,
                              videoUrl: seasonEpisodes[index].videoUrl),
                        ),
                        Offset(0.0, 1.0),
                        Offset.zero)),
                child: Container(
                  margin: EdgeInsets.only(right: 8.0),
                  width: 150.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(seasonEpisodes[index].imageUrl),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      height: 32.0,
                      width: 32.0,
                      child: OutlineButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        child: Container(
                          height: 32.0,
                          width: 32.0,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    child: Text(
                      '${index + 1}. ${seasonEpisodes[index].name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                    ),
                  ),
                  Text(
                    '${seasonEpisodes[index].duration}m',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color.fromRGBO(255, 255, 255, 0.3),
                    ),
                  )
                ],
              )
            ],
          ),
          Text(
            seasonEpisodes[index].summary,
            //textAlign: TextAlign.left,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.0,
              color: Color.fromRGBO(255, 255, 255, 0.3),
            ),
          )
        ],
      ),
    );
  }

  Widget episodeForDesktop(BuildContext context) {
    double tileWidth = 200.0;
    double tileHeight = 130.0;
    return InkWell(
      onTap: () => Navigator.push(
          context,
          createRoute(
              Scaffold(
                appBar: AppBar(
                  title: Text(seasonEpisodes[index].name),
                ),
                backgroundColor: Colors.black,
                body: CustomVideoPlayer(
                    type: PlayerType.content,
                    videoUrl: seasonEpisodes[index].videoUrl),
              ),
              Offset(0.0, 1.0),
              Offset.zero)),
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Container(
            margin: EdgeInsets.only(right: 15.0),
            width: tileWidth,
            height: tileHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(seasonEpisodes[index].imageUrl),
              ),
            ),
            child: Center(
              child: Container(
                height: 32.0,
                width: 32.0,
                child: OutlineButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                  ),
                  child: Container(
                    height: 32.0,
                    width: 32.0,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: tileWidth,
            height: tileHeight,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)),
          ),
          SizedBox(
            width: tileWidth,
            child: Text(
              '${index + 1}. ${seasonEpisodes[index].name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
                color: Color.fromRGBO(255, 255, 255, 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
        desktop: episodeForDesktop(context), mobile: episodeForMobile(context));
  }
}

class _TrailerList extends StatelessWidget {
  final List<Trailer> trailers;

  const _TrailerList({Key key, this.trailers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
        desktop: Container(
          height: 133.0,
          child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              scrollDirection: Axis.horizontal,
              itemCount: trailers.length,
              itemBuilder: (BuildContext context, int index) {
                Trailer trailer = trailers[index];
                return _TrailerTile(trailer: trailer);
              }),
        ),
        mobile: ListView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: trailers.length,
            itemBuilder: (BuildContext context, int index) {
              Trailer trailer = trailers[index];
              return _TrailerTile(trailer: trailer);
            }));
  }
}

class _TrailerTile extends StatelessWidget {
  final Trailer trailer;

  const _TrailerTile({Key key, this.trailer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: Responsive.isDesktop(context) || Responsive.isTablet(context)
            ? EdgeInsets.only(right: 15.0)
            : EdgeInsets.only(bottom: 24.0),
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              createRoute(
                  Scaffold(
                    appBar: AppBar(
                      title: Text(trailer.name),
                    ),
                    backgroundColor: Colors.black,
                    body: CustomVideoPlayer(
                        type: PlayerType.content, videoUrl: trailer.videoUrl),
                  ),
                  Offset(0.0, 1.0),
                  Offset.zero)),
          child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: <Widget>[
                Container(
                  width: Responsive.isDesktop(context) ||
                          Responsive.isTablet(context)
                      ? 200
                      : double.infinity,
                  height: Responsive.isDesktop(context) ||
                          Responsive.isTablet(context)
                      ? 133
                      : 300.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(trailer.imageUrl),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      height: 32.0,
                      width: 32.0,
                      child: OutlineButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        child: Container(
                          height: 32.0,
                          width: 32.0,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: Responsive.isDesktop(context) ||
                          Responsive.isTablet(context)
                      ? 200
                      : double.infinity,
                  height: Responsive.isDesktop(context) ||
                          Responsive.isTablet(context)
                      ? 133
                      : 300.0,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter)),
                ),
                Text(
                  trailer.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                )
              ]),
        ));
  }
}
