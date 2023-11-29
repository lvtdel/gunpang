import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Offset _avatarOffset = Offset(0, 100);

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
    });
  }

  double _clampValue(double min, double max, double value) {
    if (value > max) return max;
    if (value < min) return min;
    return value;
  }

  _onKeyBoardEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
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
      }
    }
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
          AnimatedPositioned(
              bottom: _avatarOffset.dy,
              left: _avatarOffset.dx,
              duration: const Duration(milliseconds: 200),
              child: PersonAvatar())
        ],
      ),
    );
  }
}
