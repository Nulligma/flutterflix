class Episode {
  final int number;
  final String season;
  final String image;
  final String summary;
  final String name;
  final int duration;

  Episode(
      {this.number,
      this.season,
      this.image,
      this.summary,
      this.name,
      this.duration});

  /* Episode.fromJson(Map<String, dynamic> parsedJson) {
    RegExp exp = new RegExp(r"<[^>]*>");
    number = parsedJson['number'];
    season = parsedJson['season'];
    image = (parsedJson['image'] ?? {})['medium'];
    summary = parsedJson['summary'] != null
        ? parsedJson['summary'].replaceAll(exp, '')
        : '';
    name = parsedJson['name'];
    duration = parsedJson['airtime'] != null &&
            parsedJson['airtime'].toString().isNotEmpty
        ? int.parse(parsedJson['airtime'].split(':')[0])
        : 0;
  } */
}
