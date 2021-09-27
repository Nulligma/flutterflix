import 'package:flutter/material.dart';
import 'package:flutterflix/helpers/logicHelpers.dart';
import 'package:flutterflix/models/episodeModel.dart';
import 'package:flutterflix/models/trailerModel.dart';
import 'package:flutterflix/screens/homeScreen.dart';

class Content {
  String? id;
  String? name;
  String? imageUrl;
  String? imageUrlLandscape;
  String? poster;
  String? titleImageUrl;
  String? videoUrl;
  String? previewVideo;
  String? description;
  Color? color;
  int? percentMatch;
  int? year;
  int? rating;
  int? duration;
  String? category;

  List<String>? genres;
  List<String>? cast;
  List<Episode>? episodes;
  List<String>? seasons;
  List<Trailer>? trailers;

  late Map<String, dynamic> variableMap;

  Content(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.imageUrlLandscape,
      required this.poster,
      required this.titleImageUrl,
      required this.videoUrl,
      required this.previewVideo,
      required this.description,
      required this.color,
      required this.percentMatch,
      required this.year,
      required this.rating,
      required this.duration,
      required this.genres,
      required this.cast,
      required this.category,
      required this.trailers,
      this.episodes,
      this.seasons}) {
    variableMap = {
      "name": this.name,
      "imageUrl": this.imageUrl,
      "imageUrlLandscape": this.imageUrlLandscape,
      "poster": this.poster,
      "titleImageUrl": this.titleImageUrl,
      "videoUrl": this.videoUrl,
      "previewVideo": this.previewVideo,
      "description": this.description,
      "color": this.color.toString(),
      "percentMatch": this.percentMatch,
      "year": this.year,
      "rating": this.rating,
      "duration": this.duration,
      "genres": this.genres,
      "cast": this.cast,
      "category": this.category,
    };
  }

  Content.fromMap(id, Map<String, dynamic> data) {
    this.id = id;
    this.name = data["name"];
    this.imageUrl = data["imageUrl"];
    this.imageUrlLandscape = data["imageUrlLandscape"];
    this.poster = data["poster"];
    this.titleImageUrl = data["titleImageUrl"];
    this.videoUrl = data["videoUrl"];
    this.previewVideo = data["previewVideo"];
    this.description = data["description"];
    this.color = Color(getColorInt_fromString(data["color"]));
    this.percentMatch = data["percentMatch"];
    this.year = data["year"];
    this.rating = data["rating"];
    this.duration = data["duration"];
    this.category = data["category"];

    this.variableMap = data;

    this.genres = List<String>.from(data["genres"]);
    this.cast = List<String>.from(data["cast"]);

    trailers = [];
    if (this.category == ContentCategory.TV_SHOW) {
      episodes = [];
      seasons = [];
    }
  }

  Content.blank(this.category) {
    color = Colors.white;
    genres = [];
    cast = [];
    trailers = [];

    variableMap = {
      "name": this.name,
      "imageUrl": this.imageUrl,
      "imageUrlLandscape": this.imageUrlLandscape,
      "poster": this.poster,
      "titleImageUrl": this.titleImageUrl,
      "videoUrl": this.videoUrl,
      "previewVideo": this.previewVideo,
      "description": this.description,
      "color": this.color.toString(),
      "percentMatch": this.percentMatch,
      "year": this.year,
      "rating": this.rating,
      "duration": this.duration,
      "genres": this.genres,
      "cast": this.cast,
      "category": this.category,
    };

    if (this.category == ContentCategory.TV_SHOW) {
      episodes = [];
      seasons = [];
    }
  }
}
