import 'package:flutter/material.dart';
import 'loadingLogo.dart';

class loading extends StatelessWidget {
  const loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 24, 146, 154)),
            strokeWidth: 15.0,
          ),
          LoadingLogo(), // Ensure LoadingLogo fits within SizedBox
        ],
      ),
    );
  }
}
