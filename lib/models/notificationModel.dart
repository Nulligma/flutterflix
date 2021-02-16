import 'package:flutterflix/models/contentModel.dart';

class NotificationData {
  String id;
  String title;
  String contentId;

  Map<String, dynamic> variableMap;

  NotificationData(this.id, this.title, this.contentId) {
    variableMap = {
      "id": this.id,
      "title": this.title,
      "contentId": this.contentId
    };
  }

  NotificationData.fromMap(Map<String, dynamic> newMap) {
    this.id = newMap["id"];
    this.title = newMap["title"];
    this.contentId = newMap["contentId"];
  }
}
