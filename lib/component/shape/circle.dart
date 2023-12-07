import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  CirclePainter(this.color, this.strokeWidth);

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
    final double radius = min(size.width / 2, size.height / 2);

    drawMidpointCircle(canvas, centerX, centerY, radius, paint);
    // canvas.drawPoints(PointMode.points, [Offset(centerX, centerY)], paint);
  }

  void drawMidpointCircle(Canvas canvas, double centerX, double centerY,
      double radius, Paint paint) {
    int x = radius.toInt();
    int y = 0;
    int decisionOver2 =
        1 - x; // Decision criterion divided by 2 evaluated at x=r, y=0

    while (y <= x) {
      drawCirclePoints(canvas, centerX, centerY, x, y, paint);
      y++;

      // Mid-point is inside or on the perimeter of the circle
      if (decisionOver2 <= 0) {
        decisionOver2 += 2 * y + 1; // Change in decision criterion for y -> y+1
      } else {
        x--;
        decisionOver2 += 2 * (y - x) + 1; // Change for y -> y+1, x -> x-1
      }
    }
  }

  void drawCirclePoints(Canvas canvas, double centerX, double centerY, int x,
      int y, Paint paint) async {
    canvas.drawPoints(
      PointMode.points,
      [
        Offset(centerX + x, centerY + y),
        Offset(centerX - x, centerY + y),
        Offset(centerX + x, centerY - y),
        Offset(centerX - x, centerY - y),
        Offset(centerX + y, centerY + x),
        Offset(centerX - y, centerY + x),
        Offset(centerX + y, centerY - x),
        Offset(centerX - y, centerY - x)
      ],
      paint,
    );
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}