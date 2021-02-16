import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflix/database/firestoreFields.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/models/episodeModel.dart';
import 'package:flutterflix/models/notificationModel.dart';
import 'package:flutterflix/models/trailerModel.dart';
import 'package:flutterflix/sampleData/localdata.dart' as LocalData;
import 'package:flutterflix/screens/homeScreen.dart';

class Cloud {
  static List genres;
  static List<Content> previews;
  static List<Content> topSearches;
  static List<Content> originals;
  static List<Content> trending;

  static List myListContentIds;
  static List<Content> myList;

  static List<NotificationData> notificationList;

  static Content featureHome;
  static Content featureTv;
  static Content featureMovie;

  static List<Content> allContent;

  static Future<void> updateMyList(Content content, bool add) async {
    String contentId = content.id;
    if (add) {
      myListContentIds.add(contentId);
      myList.add(content);
    } else {
      myListContentIds.remove(contentId);
      myList.remove(content);
    }

    Map<String, dynamic> newListOfIds = {
      FirestoreFields.USER_LIST: myListContentIds
    };

    await FirebaseFirestore.instance
        .collection(FirestoreFields.USERS_COLLECTION)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update(newListOfIds);

    return;
  }

  static Future<void> updateNotification() async {
    Map<String, dynamic> notificationMap = {};

    notificationList.forEach((NotificationData nd) {
      notificationMap[nd.id] = [nd.contentId, nd.title];
    });

    DocumentReference notificationDocument = FirebaseFirestore.instance
        .collection(FirestoreFields.APPDATA_COLLECTION)
        .doc(FirestoreFields.APPDATA_NOTIFICATIONS);

    await notificationDocument.set(notificationMap);

    return;
  }

  static Future<void> uploadContent(Content content) async {
    DocumentReference contentDocument = FirebaseFirestore.instance
        .collection(FirestoreFields.CONTENT_COLLECTION)
        .doc(content.id);

    await contentDocument.set(content.variableMap);

    CollectionReference episodeCollection =
        contentDocument.collection(FirestoreFields.EPISODE_COLLECTION);

    if (content.category == ContentCategory.TV_SHOW) {
      int episodeIndex = 1;
      for (Episode e in content.episodes) {
        await episodeCollection.doc("ep${episodeIndex++}").set(e.variableMap);
      }
    }

    CollectionReference trailerCollection =
        contentDocument.collection(FirestoreFields.TRAILER_COLLECTION);

    int trailerIndex = 1;
    for (Trailer t in content.trailers) {
      await trailerCollection
          .doc("trailer${trailerIndex++}")
          .set(t.variableMap);
    }
  }

  static Future<void> deleteContent(Content content) async {
    if (previews.contains(content)) previews.remove(content);
    if (topSearches.contains(content)) topSearches.remove(content);
    if (originals.contains(content)) originals.remove(content);
    if (trending.contains(content)) trending.remove(content);

    allContent.remove(content);

    await FirebaseFirestore.instance
        .collection(FirestoreFields.CONTENT_COLLECTION)
        .doc(content.id)
        .delete();

    return;
  }

  static Future<void> getTrailers(Content content) async {
    QuerySnapshot contentsTrailersRef = await FirebaseFirestore.instance
        .collection(FirestoreFields.CONTENT_COLLECTION)
        .doc(content.id)
        .collection(FirestoreFields.TRAILER_COLLECTION)
        .get();

    contentsTrailersRef.docs.forEach((doc) {
      Trailer trailer = Trailer.fromMap(doc.data());
      content.trailers.add(trailer);
    });

    return;
  }

  static Future<void> getEpisodes(Content content) async {
    QuerySnapshot contentsEpisodesRef = await FirebaseFirestore.instance
        .collection(FirestoreFields.CONTENT_COLLECTION)
        .doc(content.id)
        .collection(FirestoreFields.EPISODE_COLLECTION)
        .get();

    contentsEpisodesRef.docs.forEach((doc) {
      Episode episode = Episode.fromMap(doc.data());
      content.episodes.add(episode);

      if (!content.seasons.contains(episode.seasonName))
        content.seasons.add(episode.seasonName);
    });

    return;
  }

  static Future<void> getDataFromCloud() async {
    List previewsContentIds;
    List topSearchesContentIds;
    List originalsContentIds;
    List trendingContentIds;

    String featureHomeId;
    String featureTvId;
    String featureMovieId;

    DocumentSnapshot lists = await FirebaseFirestore.instance
        .collection(FirestoreFields.APPDATA_COLLECTION)
        .doc(FirestoreFields.APPDATA_LISTS)
        .get();

    Map<String, dynamic> listData = lists.data();

    genres = listData[FirestoreFields.APPDATA_LISTS_GENRES];
    previewsContentIds = listData[FirestoreFields.APPDATA_LISTS_PREVIEWS];
    topSearchesContentIds = listData[FirestoreFields.APPDATA_LISTS_TOPSEARCHES];
    originalsContentIds = listData[FirestoreFields.APPDATA_LISTS_ORIGINALS];
    trendingContentIds = listData[FirestoreFields.APPDATA_LISTS_TRENDING];

    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection(FirestoreFields.USERS_COLLECTION)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    myListContentIds = userData[FirestoreFields.USER_LIST];

    DocumentSnapshot features = await FirebaseFirestore.instance
        .collection(FirestoreFields.APPDATA_COLLECTION)
        .doc(FirestoreFields.APPDATA_FEATURES)
        .get();

    Map<String, dynamic> featureData = features.data();

    featureHomeId = featureData[FirestoreFields.APPDATA_FEATURES_HOME];
    featureTvId = featureData[FirestoreFields.APPDATA_FEATURES_TV];
    featureMovieId = featureData[FirestoreFields.APPDATA_FEATURES_MOVIE];

    QuerySnapshot contentsRef = await FirebaseFirestore.instance
        .collection(FirestoreFields.CONTENT_COLLECTION)
        .get();

    allContent = [];
    previews = [];
    topSearches = [];
    originals = [];
    trending = [];
    myList = [];
    contentsRef.docs.forEach((doc) {
      Content content = Content.fromMap(doc.id, doc.data());

      allContent.add(content);

      if (content.id == featureHomeId) featureHome = content;
      if (content.id == featureTvId) featureTv = content;
      if (content.id == featureMovieId) featureMovie = content;

      previewsContentIds.forEach((val) {
        if (val == content.id) previews.add(content);
      });
      topSearchesContentIds.forEach((val) {
        if (val == content.id) topSearches.add(content);
      });
      originalsContentIds.forEach((val) {
        if (val == content.id) originals.add(content);
      });
      trendingContentIds.forEach((val) {
        if (val == content.id) trending.add(content);
      });
      myListContentIds.forEach((val) {
        if (val == content.id) myList.add(content);
      });
    });

    DocumentSnapshot notificaionsSnap = await FirebaseFirestore.instance
        .collection(FirestoreFields.APPDATA_COLLECTION)
        .doc(FirestoreFields.APPDATA_NOTIFICATIONS)
        .get();

    Map<String, dynamic> notificaionsData = notificaionsSnap.data();

    notificationList = [];
    notificaionsData.forEach((key, value) {
      NotificationData notification = NotificationData(key, value[1], value[0]);
      notificationList.add(notification);
    });

    return;
  }

  static Future<void> uploadSampleData() async {
    Map<String, dynamic> features = {
      FirestoreFields.APPDATA_FEATURES_HOME: LocalData.featureHome.id,
      FirestoreFields.APPDATA_FEATURES_MOVIE: LocalData.featureMovie.id,
      FirestoreFields.APPDATA_FEATURES_TV: LocalData.featureTV.id
    };

    await FirebaseFirestore.instance
        .collection(FirestoreFields.APPDATA_COLLECTION)
        .doc(FirestoreFields.APPDATA_FEATURES)
        .set(features);

    List originalsIds = LocalData.originals.map((c) => c.id).toList();
    List previewsIds = LocalData.previews.map((c) => c.id).toList();
    List topSearchesIds = LocalData.topSearches.map((c) => c.id).toList();
    List trendingIds = LocalData.trending.map((c) => c.id).toList();

    Map<String, dynamic> lists = {
      FirestoreFields.APPDATA_LISTS_GENRES: LocalData.genres,
      FirestoreFields.APPDATA_LISTS_ORIGINALS: originalsIds,
      FirestoreFields.APPDATA_LISTS_PREVIEWS: previewsIds,
      FirestoreFields.APPDATA_LISTS_TOPSEARCHES: topSearchesIds,
      FirestoreFields.APPDATA_LISTS_TRENDING: trendingIds
    };

    await FirebaseFirestore.instance
        .collection(FirestoreFields.APPDATA_COLLECTION)
        .doc(FirestoreFields.APPDATA_LISTS)
        .set(lists);

    notificationList = [
      LocalData.notification1,
      LocalData.notification2,
      LocalData.notification3,
      LocalData.notification4
    ];

    await updateNotification();

    for (Content c in LocalData.allContent) {
      await uploadContent(c);
    }

    return;
  }
}
