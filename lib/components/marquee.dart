import 'dart:async';

import 'package:flutter/material.dart';

class Marquee extends StatefulWidget {
  final String text;
  final Function(BuildContext, String text) builder;
  final bool play;

  const Marquee(
      {Key? key, required this.text, required this.builder, this.play = true})
      : super(key: key);

  @override
  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> {
  Timer? _timer;
  late String _text;

  @override
  void initState() {
    super.initState();
    _text = widget.text + " | ";
    if (widget.play) {
     startTimer();
    }
  }

  @override
  void didUpdateWidget(Marquee oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play) {
      startTimer();
    } else {
      stopTimer();
      _text = widget.text;
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 120), (timer) {
      setState(() {
        var tail = _text.substring(1);
        var first = _text.substring(0, 1);
        _text = tail + first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _text);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
