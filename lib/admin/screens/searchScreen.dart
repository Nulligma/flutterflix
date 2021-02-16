import 'package:flutter/material.dart';
import 'package:flutterflix/admin/widgets/simpleList.dart';
import 'package:flutterflix/database/clouddata.dart';
import 'package:flutterflix/helpers/logicHelpers.dart';
import 'package:flutterflix/models/contentModel.dart';

class SearchScreen extends StatefulWidget {
  final Function onEdit;
  final Function onDelete;

  const SearchScreen({Key key, this.onEdit, this.onDelete}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String heading;
  List<Content> contents;

  @override
  void initState() {
    heading = "Top Searches";
    contents = Cloud.topSearches;
    super.initState();
  }

  void onSearchChange(String newSearch) {
    contents = [];
    setState(() {
      if (newSearch.isEmpty) {
        heading = "Top Searches";
        contents = Cloud.topSearches;
      } else {
        heading = "Movies & TV Shows";
        contents = Cloud.allContent
            .where((content) => searchFilter(content, newSearch))
            .toList();
      }
    });
  }

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: TextField(
              onChanged: onSearchChange,
              style: const TextStyle(fontSize: 16.0),
              decoration: InputDecoration(
                fillColor: Colors.white70,
                filled: true,
                icon: Icon(
                  Icons.search,
                ),
                hintText: 'Search name, cast, genre, details',
                hintStyle: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              autofocus: false,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              heading,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: SimpleList(
            contents: contents,
            onEdit: widget.onEdit,
            onDelete: widget.onDelete,
            leadingTexts: contents.map((c) => c.id).toList(),
            titles: contents.map((c) => c.name).toList(),
          ),
        )
      ],
    );
  }
}
