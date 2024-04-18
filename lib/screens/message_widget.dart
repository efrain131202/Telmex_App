import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Animation<double> animation;

  const MessageWidget({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: const Text(
        'No se han importado datos',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
