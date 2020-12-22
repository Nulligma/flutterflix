import 'package:flutter/material.dart';
import 'package:flutterflix/models/episodeModel.dart';
import 'package:meta/meta.dart';

class Content {
  final String name;
  final String imageUrl;
  final String poster;
  final String titleImageUrl;
  final String videoUrl;
  final String previewVideo;
  final String description;
  final Color color;
  final int percentMatch;
  final int year;
  final int rating;
  final int duration;
  final String category;

  final List<String> genres;
  final List<String> cast;
  final List<Episode> episodes;
  final List<String> seasons;

  const Content(
      {@required this.name,
      @required this.imageUrl,
      @required this.poster,
      @required this.titleImageUrl,
      @required this.videoUrl,
      @required this.previewVideo,
      @required this.description,
      @required this.color,
      @required this.percentMatch,
      @required this.year,
      @required this.rating,
      @required this.duration,
      @required this.genres,
      @required this.cast,
      @required this.category,
      this.episodes,
      this.seasons});
}
