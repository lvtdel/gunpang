import 'dart:ui';

import 'package:flutter/material.dart';

void drawLine(Canvas canvas, Offset start, Offset end, Paint paint) {
  int x1 = start.dx.toInt();
  int y1 = start.dy.toInt();
  int x2 = end.dx.toInt();
  int y2 = end.dy.toInt();

  int dx = x2 - x1;
  int dy = y2 - y1;

  int stepX = dx < 0 ? -1 : 1;
  int stepY = dy < 0 ? -1 : 1;

  dx = dx.abs();
  dy = dy.abs();

  canvas.drawPoints(
    PointMode.points,
    [Offset(x1.toDouble(), y1.toDouble())],
    paint,
  );

  if (dx > dy) {
    int p = 2 * dy - dx;

    for (int i = 0; i < dx; i++) {
      x1 += stepX;
      if (p < 0) {
        p += 2 * dy;
      } else {
        y1 += stepY;
        p += 2 * (dy - dx);
      }

      canvas.drawPoints(
        PointMode.points,
        [Offset(x1.toDouble(), y1.toDouble())],
        paint,
      );
    }
  } else {
    int p = 2 * dx - dy;

    for (int i = 0; i < dy; i++) {
      y1 += stepY;
      if (p < 0) {
        p += 2 * dx;
      } else {
        x1 += stepX;
        p += 2 * (dx - dy);
      }

      canvas.drawPoints(
        PointMode.points,
        [Offset(x1.toDouble(), y1.toDouble())],
        paint,
      );
    }
  }
}
