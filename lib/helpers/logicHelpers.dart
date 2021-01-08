import 'package:flutterflix/models/contentModel.dart';

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
