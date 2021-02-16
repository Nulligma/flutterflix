import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflix/assets.dart';
import 'package:flutterflix/database/clouddata.dart';
import 'package:flutterflix/database/firestoreFields.dart';
import 'package:flutterflix/screens/navScren.dart';

enum AppState {
  loading,
  databaseSetupPending,
  uploadingDatabase,
  databaseSetuped,
  databaseDownloading,
  ready
}

class AppManager extends StatefulWidget {
  @override
  _AppManagerState createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> {
  AppState appState;
  String scaffoldHeading;
  String scaffoldSubheading;
  String scaffoldButtonText;

  @override
  void initState() {
    super.initState();
    appState = AppState.loading;
    FirebaseFirestore.instance
        .collection(FirestoreFields.APPDATA_COLLECTION)
        .get()
        .then((val) {
      setState(() {
        if (val.docs.length == 0)
          appState = AppState.databaseSetupPending;
        else
          appState = AppState.databaseDownloading;
      });
    });
  }

  void checkAppState() {
    switch (appState) {
      case AppState.loading:
        scaffoldHeading = "Loading..";
        scaffoldButtonText = null;
        scaffoldSubheading = null;
        break;
      case AppState.databaseSetupPending:
        scaffoldHeading = "Database is not configured";
        scaffoldButtonText = "Upload sample database";
        scaffoldSubheading = null;
        break;
      case AppState.uploadingDatabase:
        scaffoldHeading = "Uploading data to database";
        scaffoldButtonText = null;
        scaffoldSubheading = null;

        Cloud.uploadSampleData().then((_) {
          setState(() {
            appState = AppState.databaseSetuped;
          });
        });
        break;
      case AppState.databaseSetuped:
        scaffoldHeading = "Database is now configured";
        scaffoldButtonText = null;
        scaffoldSubheading = "Please restart the app";
        break;
      case AppState.databaseDownloading:
        scaffoldHeading = "Loading data from database";
        scaffoldButtonText = null;
        scaffoldSubheading = null;
        Cloud.getDataFromCloud().then((_) {
          setState(() {
            appState = AppState.ready;
          });
        });
        break;
      case AppState.ready:
        // TODO: Handle this case.
        break;
    }
  }

  Widget scaffold(String heading, {String buttonText, String subheading}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
              image: NetworkImage(Assets.login_background),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Image.network(
            Assets.netflixLogo1,
            fit: BoxFit.contain,
            height: 50,
          ),
        ),
        body: Center(
          child: Container(
            color: Colors.black.withOpacity(0.75),
            width: 500,
            height: 700,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: buttonText != null || subheading != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            heading,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            height: 50.0,
                            child: buttonText != null
                                ? FlatButton(
                                    color: Colors.red[800],
                                    child: Text(
                                      buttonText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        appState = AppState.uploadingDatabase;
                                      });
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      subheading,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            child: const CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              heading,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          )
                        ],
                      )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    checkAppState();
    if (appState == AppState.ready) {
      return NavScreen();
    } else {
      return scaffold(scaffoldHeading,
          buttonText: scaffoldButtonText, subheading: scaffoldSubheading);
    }
  }
}
