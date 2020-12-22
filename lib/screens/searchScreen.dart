import 'package:flutter/material.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/widgets/contentGrid.dart';
import 'package:flutterflix/widgets/customAppBar.dart';
import 'package:flutterflix/data/data.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String heading;
  List<Content> contents;

  @override
  void initState() {
    heading = "Top Searches";
    contents = topSearches;
    super.initState();
  }

  bool searchFilter(Content content, String searchString) {
    searchString = searchString.toLowerCase();

    if (content.name.toLowerCase().contains(searchString))
      return true;
    else if (content.description.toLowerCase().contains(searchString))
      return true;
    else if (content.category.toLowerCase().contains(searchString))
      return true;
    else if (content.genres
        .any((element) => element.toLowerCase().contains(searchString)))
      return true;
    else if (content.cast
        .any((element) => element.toLowerCase().contains(searchString)))
      return true;

    return false;
  }

  void onSearchChange(String newSearch) {
    contents = [];
    setState(() {
      if (newSearch.isEmpty) {
        heading = "Top Searches";
        contents = topSearches;
      } else {
        heading = "Movies & TV Shows";
        contents = allContent
            .where((content) => searchFilter(content, newSearch))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 50.0),
          child: CustomAppBar(
            scrollOffset: 350.0,
            type: CustomAppBarType.search,
            onChange: onSearchChange,
          )),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 70.0,
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                heading,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ContentGrid(contents: contents)
        ],
      ),
    );
  }
}
