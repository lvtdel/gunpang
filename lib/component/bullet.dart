import 'package:flutter/material.dart';

class Bullet extends StatelessWidget {
  const Bullet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    );
  }
}
