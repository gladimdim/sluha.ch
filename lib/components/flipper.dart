import 'dart:math';

import 'package:flutter/material.dart';

class Flipper extends StatefulWidget {
  final WidgetBuilder frontBuilder;
  final WidgetBuilder backBuilder;

  const Flipper(
      {Key? key, required this.frontBuilder, required this.backBuilder})
      : super(key: key);

  @override
  _FlipperState createState() => _FlipperState();
}

class _FlipperState extends State<Flipper> with SingleTickerProviderStateMixin {
  bool _showFrontSide = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller.addStatusListener(_updateStatus);
    _controller.addListener(() {
      print(_controller.value);
    });
  }

  void flip() {
    if (_showFrontSide) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      setState(() {
        _showFrontSide = !_showFrontSide;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final isAnimationFirstHalf = _controller.value.abs() < 0.5;
            final child = isAnimationFirstHalf
                ? widget.frontBuilder(context)
                : widget.backBuilder(context);
            final rotationValue = _controller.value * pi;
            final rotationAngle =
                _controller.value > 0.5 ? pi - rotationValue : rotationValue;
            return Transform(
              transform: Matrix4.rotationY(rotationAngle),
              alignment: Alignment.center,
              child: child,
            );
          }),
      onTap: flip,
    );
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_updateStatus);
    _controller.dispose();
    super.dispose();
  }
}
