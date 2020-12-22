import 'package:flutter/material.dart';
import 'package:flutterflix/data/data.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/models/episodeModel.dart';
import 'package:flutterflix/widgets/widgets.dart';

class ContentDetails extends StatefulWidget {
  final Content content;

  const ContentDetails({Key key, this.content}) : super(key: key);

  @override
  _ContentDetailsState createState() => _ContentDetailsState();
}

class _ContentDetailsState extends State<ContentDetails> {
  ScrollController _scrollController;
  double _scrollOffset = 0.0;
  String currentSeason;
  bool isaMovie;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });

    if (widget.content.seasons != null)
      currentSeason = widget.content.seasons[0];

    isaMovie = widget.content.episodes == null;

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void changeCurrentSeason(String newSeason) {
    setState(() {
      currentSeason = newSeason;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    List<Episode> seasonEpisodes;

    if (!isaMovie) {
      seasonEpisodes = widget.content.episodes
          .where((Episode e) => e.season == currentSeason)
          .toList();
    }

    void changeState() {
      setState(() {});
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 50.0),
          child: CustomAppBar(
              scrollOffset: _scrollOffset, type: CustomAppBarType.content)),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
              child: ContentHeader(
                  content: widget.content, type: ContentHeaderType.Details)),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
                child: _ContentDescription(
              content: widget.content,
              currentSeason: currentSeason,
              changeCurrentSeason: changeCurrentSeason,
              setState: setState,
            )),
          ),
          SliverPadding(
              padding: const EdgeInsets.only(top: 5.0),
              sliver: isaMovie
                  ? SliverToBoxAdapter(
                      child: Container(),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _EpisodeList(
                          index: index,
                          seasonEpisodes: seasonEpisodes,
                        ),
                        childCount: seasonEpisodes.length,
                      ),
                    )),
        ],
      ),
    );
  }
}

class _ContentDescription extends StatelessWidget {
  final Content content;
  final String currentSeason;
  final Function changeCurrentSeason;
  final Function setState;

  const _ContentDescription(
      {Key key,
      this.content,
      this.currentSeason,
      this.changeCurrentSeason,
      this.setState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              child: Text(
                content.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Container(
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.3),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Starring: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: content.cast.join(', ')),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              children: <Widget>[
                FlatButton(
                  textColor: Colors.white70,
                  onPressed: () => print('My List'),
                  child: Container(
                    height: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        if (myList.contains(content))
                          myList.remove(content);
                        else
                          myList.add(content);

                        setState(() {});
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            myList.contains(content) ? Icons.check : Icons.add,
                            size: 32.0,
                          ),
                          Text(
                            'My List',
                            style: TextStyle(fontSize: 10.0),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                FlatButton(
                  textColor: Colors.white70,
                  onPressed: () => print('Rate'),
                  child: Container(
                    height: 50.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.thumb_up,
                          size: 24.0,
                        ),
                        Text(
                          'Rate',
                          style: TextStyle(fontSize: 10.0),
                        )
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  textColor: Colors.white70,
                  onPressed: () => print('Share'),
                  child: Container(
                    height: 50.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.share,
                          size: 20.0,
                        ),
                        Text(
                          'Share',
                          style: TextStyle(fontSize: 10.0),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          content.seasons == null
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Container(
                    child: Text(
                      'EPISODES',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
          content.seasons == null
              ? Container()
              : DropdownButton<String>(
                  value: currentSeason,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (String newValue) =>
                      {changeCurrentSeason(newValue)},
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
        ],
      ),
    );
  }
}

class _EpisodeList extends StatelessWidget {
  final int index;
  final List<Episode> seasonEpisodes;

  const _EpisodeList({Key key, this.index, this.seasonEpisodes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 8.0),
                width: 150.0,
                height: 90.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(seasonEpisodes[index].image),
                  ),
                ),
                child: Center(
                  child: Container(
                    height: 32.0,
                    width: 32.0,
                    child: OutlineButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () => print('play'),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    child: Text(
                      '${seasonEpisodes[index].number}. ${seasonEpisodes[index].name}',
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
}
