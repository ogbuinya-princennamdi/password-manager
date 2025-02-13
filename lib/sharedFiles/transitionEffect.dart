import 'package:flutter/material.dart';
//FadePageRoute
class transitionEffect extends PageRouteBuilder {
  final Widget page;

  transitionEffect({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var opacityAnimation = animation.drive(tween);

      return FadeTransition(opacity: opacityAnimation, child: child);
    },
  );
}
