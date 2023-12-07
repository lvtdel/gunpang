import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gunpang/component/bullet.dart';
import 'package:gunpang/component/ground.dart';
import 'package:gunpang/component/person_avatar.dart';

import '../ultil/Direction.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final FocusNode _focusNode = FocusNode();

  late Size _size;
  final double _step = 8;
  final dyGround = 100.0;
  late Offset _avatarOffset = Offset(1500, dyGround + 5);
  late Offset _bulletOffset = Offset(1500, dyGround + 5);

  Size _bulletSize = Size(20, 20);
  bool _isBulletExplosive = false;

  bool _isShooting = false;
  int _alpha = 65;
  final double _timeCoefficient = 7;
  final Direction _direction = Direction(Direction.right);
  final double vMax = 207;
  double v0old = 0;
  double v0 = 0;
  double vStep = 2;

  // double v0 = 100;

  bool _areOffsetsEqual(Offset offset1, Offset offset2) {
    double _epsilon = 1;

    return (offset1.dx - offset2.dx).abs() < _epsilon &&
        (offset1.dy - offset2.dy).abs() < _epsilon;
  }

  bool _isBulletOutRange(Offset offset) {
    if (offset.dx < 0 || _size.width < offset.dx || offset.dy < 5) {
      return true;
    }
    return false;
  }

  bool _isBulletHitTheGround(Offset offset) {
    if (offset.dy < dyGround) {
      return true;
    }
    return false;
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
              _direction.value = Direction.right;
              print(_direction.value);
            }
            break;
          case LogicalKeyboardKey.arrowLeft:
            {
              double dx = _avatarOffset.dx - _step;
              double dy = _avatarOffset.dy;
              _setAvatarOffset(dx, dy);
              _direction.value = Direction.left;
              print(_direction.value);
            }
            break;
          case LogicalKeyboardKey.arrowUp:
            {
              setState(() {
                _alpha = _clampValue(10, 90, _alpha + 1).round();
              });
            }
            break;
          case LogicalKeyboardKey.arrowDown:
            {
              setState(() {
                _alpha = _clampValue(10, 90, _alpha - 1).round();
              });
            }
            break;
        }

        if (event.logicalKey == LogicalKeyboardKey.space) {
          setState(() {
            v0 = _clampValue(0, vMax, v0 + vStep);
          });
        }

        // if (!_isShooting) {
        //   if (event.logicalKey == LogicalKeyboardKey.space) {
        //     _shoot();
        //   }
        // }
      }
    }

    if (event is RawKeyUpEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.space:
          {
            if (!_isShooting) {
              _shoot();
            }
          }
          break;
      }
    }
  }

  Future _shoot() async {
    // 1000* 1/60 = 16.67
    const int timeRefreshMillisecond = 16;

    Duration duration = const Duration(milliseconds: timeRefreshMillisecond);
    double t = 0;
    int directionValue = _direction.value;

    // _bulletOffset = Offset(_avatarOffset.dx, _avatarOffset.dy);

    _isShooting = true;
    Timer timer = Timer.periodic(duration, (timer) async {
      t += _timeCoefficient * duration.inMilliseconds / 1000;
      print('Đã trôi qua $t giây.');

      double dx =
          _avatarOffset.dx + directionValue * v0 * cos(_alpha * pi / 180) * t;
      double dy =
          _avatarOffset.dy + v0 * sin(_alpha * pi / 180) * t - 9.8 * t * t / 2;

      if (_isBulletOutRange(Offset(dx, dy))) {
        timer.cancel();
        _endShoot();
      } else if (_isBulletHitTheGround(Offset(dx, dy))) {
        timer.cancel();
        await _explosiveBullet();
        _endShoot();

      } else {
        if (dy < _size.height + 100) {
          setState(() {
            _bulletOffset = Offset(dx, dy);
          });
        }
      }
    });
  }

  _explosiveBullet() async {
    setState(() {
      _isBulletExplosive = true;
      _bulletSize = Size(_bulletSize.width * 2, _bulletSize.height * 2);
    });
    await Future.delayed(
      const Duration(seconds: 1),
    );
    setState(() {
      _isBulletExplosive = false;
      _bulletSize = Size(_bulletSize.width / 2, _bulletSize.height / 2);
    });
  }

  _endShoot() {
    setState(() {
      _bulletOffset = Offset(_avatarOffset.dx, _avatarOffset.dy);
      _isShooting = false;
      v0 = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = context.size;
      print('Width: ${size?.width}, Height: ${size?.height}');
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
          Positioned.fill(child:
          CustomPaint(
            painter: GroundPainter(dyGround, Colors.black54, 3),
          )
            // Container(color:Colors.red,)
          ),
          AnimatedPositioned(
              bottom: _avatarOffset.dy,
              left: _avatarOffset.dx,
              duration: const Duration(milliseconds: 200),
              child: PersonAvatar()),
          AnimatedPositioned(
              bottom: _bulletOffset.dy,
              left: _bulletOffset.dx,
              duration: const Duration(milliseconds: 00),
              child: _areOffsetsEqual(_avatarOffset, _bulletOffset)
                  ? Container()
                  : AnimatedContainer(
                      width: _bulletSize.width,
                      height: _bulletSize.height,
                      duration: const Duration(milliseconds: 200),
                      child: Bullet(
                        isBulletExplosive: _isBulletExplosive,
                      ))),
          Positioned(
              bottom: 30,
              left: 5,
              child: Text(
                _alpha.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              )),
          Positioned(
              bottom: 30,
              left: 100,
              right: 100,
              child: Row(
                children: [
                  Expanded(
                      flex: (v0 * 10).round(),
                      child: Container(
                        height: 20,
                        color: Colors.amberAccent,
                      )),
                  Expanded(
                      flex: ((vMax - v0) * 10).round(),
                      child: Container(
                        height: 20,
                        color: Colors.white,
                      ))
                ],
              ))
        ],
      ),
    );
  }
}
