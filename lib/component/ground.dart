import 'package:flutter/material.dart';
import 'package:gunpang/component/shape/line.dart';

class GroundPainter extends CustomPainter {
  GroundPainter(this.dyGround, this.color, this.strokeWidth);

  double dyGround;
  Color color;
  double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth;

    double dy = size.height - dyGround;

    drawLine(canvas, Offset(0, dy), Offset(size.width, dy), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}
