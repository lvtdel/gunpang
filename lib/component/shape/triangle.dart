import 'dart:ui';

import 'package:flutter/material.dart';

import 'line.dart';

class TrianglePainter extends CustomPainter {
  TrianglePainter(this.color, this.strokeWidth);


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
    final double sideLength = size.width;

    final List<Offset> vertices = [
      Offset(centerX, centerY - sideLength / 2), // Đỉnh trên
      Offset(centerX - sideLength / 2, centerY + sideLength / 2), // Đỉnh trái dưới
      Offset(centerX + sideLength / 2, centerY + sideLength / 2), // Đỉnh phải dưới
    ];

    drawTriangle(canvas, vertices, paint);
  }

  void drawTriangle(Canvas canvas, List<Offset> vertices, Paint paint) {
    assert(vertices.length == 3);

    drawLine(canvas, vertices[0], vertices[1], paint);
    drawLine(canvas, vertices[1], vertices[2], paint);
    drawLine(canvas, vertices[2], vertices[0], paint);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}

