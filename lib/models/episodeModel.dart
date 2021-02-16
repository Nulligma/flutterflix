class Episode {
  int number;
  String name;
  String seasonName;
  String imageUrl;
  String videoUrl;
  String summary;
  int duration;

  Map<String, dynamic> variableMap;

  Episode(
      {this.number,
      this.name,
      this.seasonName,
      this.imageUrl,
      this.videoUrl =
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
      this.summary,
      this.duration}) {
    variableMap = {
      "number": number,
      "name": name,
      "seasonName": seasonName,
      "imageUrl": imageUrl,
      "videoUrl": videoUrl,
      "summary": summary,
      "duration": duration
    };
  }

  Episode.fromMap(Map<String, dynamic> newMap) {
    this.number = newMap["number"];
    this.name = newMap["name"];
    this.seasonName = newMap["seasonName"];
    this.imageUrl = newMap["imageUrl"];
    this.videoUrl = newMap["videoUrl"];
    this.summary = newMap["summary"];
    this.duration = newMap["duration"];

    this.variableMap = newMap;
  }
}
