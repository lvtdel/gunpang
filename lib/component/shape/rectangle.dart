import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'line.dart';

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.color, this.strokeWidth);

  Color color;
  double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double width = size.width;
    final double height = size.height;

    final List<Offset> vertices = [
      Offset(centerX - width / 2, centerY - height / 2), // Góc trái trên
      Offset(centerX + width / 2, centerY - height / 2), // Góc phải trên
      Offset(centerX + width / 2, centerY + height / 2), // Góc phải dưới
      Offset(centerX - width / 2, centerY + height / 2), // Góc trái dưới
    ];

    drawRectangle(canvas, vertices, paint);
  }

  void drawRectangle(Canvas canvas, List<Offset> vertices, Paint paint) {
    assert(vertices.length == 4);

    drawLine(canvas, vertices[0], vertices[1], paint);
    drawLine(canvas, vertices[1], vertices[2], paint);
    drawLine(canvas, vertices[2], vertices[3], paint);
    drawLine(canvas, vertices[3], vertices[0], paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}
