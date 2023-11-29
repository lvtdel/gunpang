import 'package:flutter/material.dart';

class Bullet extends StatelessWidget {
  const Bullet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: 10, height: 10 ,decoration: BoxDecoration(color: Colors.red),);
  }
}
