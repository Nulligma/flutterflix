import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflix/screens/screens.dart';
import 'package:flutterflix/screens/searchScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: NavScreen());
  }
}
