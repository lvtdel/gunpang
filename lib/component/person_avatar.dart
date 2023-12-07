import 'package:flutter/material.dart';
import 'package:gunpang/component/shape/rectangle.dart';
import 'package:gunpang/component/shape/triangle.dart';

class PersonAvatar extends StatelessWidget {
  const PersonAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 20, width: 20,
    child: CustomPaint(
      painter: RectanglePainter(Colors.blue, 2)
    ),);
  }
}
