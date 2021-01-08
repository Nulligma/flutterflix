import 'package:flutter/material.dart';
import 'package:flutterflix/helpers/logicHelpers.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/widgets/contentGrid.dart';
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
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
          ),
        ],
        backgroundColor: Colors.black.withOpacity(0.85),
      ),
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 75.0, 0.0, 35.0),
                child: Text(
                  heading,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ContentGrid(
                contents: contents,
                scrollLock: true,
              )
            ],
          )),
    );
  }
}
