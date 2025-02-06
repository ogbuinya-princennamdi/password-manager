import 'package:flutter/material.dart';

class OverlayMessage extends StatelessWidget {
  final String message;

  const OverlayMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 24, 146, 154).withOpacity(0.7),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
