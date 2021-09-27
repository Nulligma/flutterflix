import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflix/appManager.dart';
import 'package:flutterflix/assets.dart';
import 'package:flutterflix/screens/loginScreen.dart';
import 'package:flutterflix/widgets/responsive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool showSplash = true;

  @override
  void initState() {
    super.initState();
  }

  void afterSplash() {
    setState(() {
      showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: showSplash
            ? _AppSplashScreen(splashDone: afterSplash)
            : StreamBuilder(
                stream: FirebaseAuth.instance.idTokenChanges(),
                builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Error: ${snapshot.error}'),
                        )
                      ],
                    );
                  } else if (!snapshot.hasData)
                    return LoginScreen();
                  else if (snapshot.hasData) return AppManager();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: const CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Waiting for connection...'),
                      )
                    ],
                  );
                },
              ));
  }
}

class _AppSplashScreen extends StatelessWidget {
  final VoidCallback splashDone;

  _AppSplashScreen({required this.splashDone}) {
    createTImer();
  }

  void createTImer() async {
    await Future.delayed(Duration(seconds: 3));
    splashDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          alignment: Alignment.center,
          child: CachedNetworkImage(
            width: 200,
            imageUrl: Assets.netflixLogo1,
          )),
    );
  }
}
