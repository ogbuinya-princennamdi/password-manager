import 'package:flutter/material.dart';
class scaleTransition extends PageRouteBuilder {
  final Widget page;
  scaleTransition({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var scaleAnimation = animation.drive(tween);

      return ScaleTransition(scale: scaleAnimation, child: child);
    },
  );
}