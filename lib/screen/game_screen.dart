import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gunpang/component/bullet.dart';
import 'package:gunpang/component/person_avatar.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final FocusNode _focusNode = FocusNode();
  late Size _size;
  final double _step = 8;
  Offset _avatarOffset = Offset(800, 100);
  Offset _bulletOffset = Offset(800, 100);
  bool _isShooting = false;
  int _alpha = 65;
  double v0 = 15;

  bool _areOffsetsEqual(Offset offset1, Offset offset2) {
    double _epsilon = 1;

    return (offset1.dx - offset2.dx).abs() < _epsilon &&
        (offset1.dy - offset2.dy).abs() < _epsilon;
  }

  _setAvatarOffset(double dx, double dy) {
    setState(() {
      double newDx;
      double newDy;

      double maxDx = _size.width - 25;
      double maxDy = _size.height - 5;
      double minDx = 5;
      double minDy = 5;

      newDx = _clampValue(minDx, maxDx, dx);
      newDy = _clampValue(minDy, maxDy, dy);

      _avatarOffset = Offset(newDx, newDy);
      _bulletOffset = Offset(newDx, newDy);
    });
  }

  double _clampValue(double min, double max, double value) {
    if (value > max) return max;
    if (value < min) return min;
    return value;
  }

  _onKeyBoardEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (!_isShooting) {
        switch (event.logicalKey) {
          case LogicalKeyboardKey.arrowRight:
            {
              double dx = _avatarOffset.dx + _step;
              double dy = _avatarOffset.dy;
              _setAvatarOffset(dx, dy);

              debugPrint('Arrow pressed');
            }
            break;
          case LogicalKeyboardKey.arrowLeft:
            {
              double dx = _avatarOffset.dx - _step;
              double dy = _avatarOffset.dy;
              _setAvatarOffset(dx, dy);

              debugPrint('Arrow pressed');
            }
            break;
          case LogicalKeyboardKey.arrowUp:
            {
              setState(() {
                _alpha = _clampValue(10, 90, _alpha + 1).round();
              });
            }
            break;
          case LogicalKeyboardKey.arrowUp:
            {
              setState(() {
                _alpha = _clampValue(10, 90, _alpha - 1).round();
              });
            }
            break;
        }
      }

      if (event.logicalKey == LogicalKeyboardKey.space) {
        _shoot();
      }
    }
  }

  Future _shoot() async {
    Duration duration = const Duration(milliseconds: 100);
    double t = 0;
    double k = 2.5;

    _bulletOffset = Offset(_avatarOffset.dx, _avatarOffset.dy);

    Timer timer = Timer.periodic(duration, (timer) {
      t += k * duration.inMilliseconds / 1000;
      print('Đã trôi qua $t giây.');

      double dx = _bulletOffset.dx + v0 * cos(_alpha) * t;
      double dy = _bulletOffset.dy + v0 * sin(_alpha) * t - 9.8 * t * t / 2;

      setState(() {
        _bulletOffset = Offset(dx, dy);
      });

      if (t > 5) {
        _bulletOffset = Offset(_avatarOffset.dx, _avatarOffset.dy);
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = context.size;
      // print('Width: ${size?.width}, Height: ${size?.height}');
      _size = size!;
    });

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _onKeyBoardEvent,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.grey),
          ),
          Positioned(
              bottom: 5,
              left: 5,
              right: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    11,
                    (index) => SizedBox(
                            // height: 100,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              // Container(height: 10, width: 10,),
                              // Container(height: 10, width: 10, color: Colors.red,),
                              Text(
                                '$index',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black54),
                              )
                            ]))),
              )),
          AnimatedPositioned(
              bottom: _avatarOffset.dy,
              left: _avatarOffset.dx,
              duration: const Duration(milliseconds: 200),
              child: PersonAvatar()),
          AnimatedPositioned(
              bottom: _bulletOffset.dy,
              left: _bulletOffset.dx,
              duration: const Duration(milliseconds: 200),
              child: _areOffsetsEqual(_avatarOffset, _bulletOffset)
                  ? Container()
                  : Bullet()),
          Positioned(
              bottom: 30,
              left: 5,
              child: Text(
                _alpha.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ))
        ],
      ),
    );
  }
}
