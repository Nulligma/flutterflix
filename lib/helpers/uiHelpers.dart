import 'package:flutter/material.dart';

Route createRoute(Widget newPage, Offset begin, Offset end) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => newPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end);
      var curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}
