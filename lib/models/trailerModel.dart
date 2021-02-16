class Trailer {
  String imageUrl;
  String name;
  String videoUrl;

  Map<String, dynamic> variableMap;

  Trailer(this.imageUrl, this.name, this.videoUrl) {
    variableMap = {
      "name": this.name,
      "imageUrl": this.imageUrl,
      "videoUrl": this.videoUrl,
    };
  }

  Trailer.fromMap(Map<String, dynamic> newMap) {
    this.name = newMap["name"];
    this.imageUrl = newMap["imageUrl"];
    this.videoUrl = newMap["videoUrl"];

    this.variableMap = newMap;
  }
}
