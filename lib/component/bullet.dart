import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gunpang/component/shape/circle.dart';
import 'package:gunpang/component/shape/triangle.dart';

class Bullet extends StatelessWidget {
  const Bullet(
      {super.key,
      double width = 20,
      double height = 20,
      isBulletExplosive = false})
      : _width = width,
        _height = height,
        _isBulletExplosive = isBulletExplosive;

  final double _width;
  final double _height;
  final bool _isBulletExplosive;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _width,
        height: _height,
        // decoration: const BoxDecoration(
        //     color: Colors.red, shape: BoxShape.circle
        // ),
        child: CustomPaint(
          size: Size(_width, _height),
          painter:
          // CirclePainter(Colors.red, 2)
          _isBulletExplosive
              ? TrianglePainter(Colors.yellow, 2)
              : CirclePainter(Colors.red, 2),
          // painter: TrianglePainter()
        ));
  }
}
