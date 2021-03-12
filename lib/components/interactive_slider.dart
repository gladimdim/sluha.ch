import 'dart:async';

import 'package:audiobooks_app/models/player.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class InteractiveSlider extends StatefulWidget {
  final Player player;

  InteractiveSlider({this.player});
  @override
  _InteractiveSliderState createState() => _InteractiveSliderState();
}

class _InteractiveSliderState extends State<InteractiveSlider> {
  double value = 0;
  StreamSubscription sub;
  @override
  void initState() {
    sub = widget.player.progressChanges.listen((event) {
      setState(() {
        value = event.item1.inSeconds.toDouble();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var player = widget.player;
    return StreamBuilder(
      stream: player.progressChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Tuple2<Duration, Duration> durations = snapshot.data;
          return Slider(
            min: 0,
            max: durations.item2.inSeconds.toDouble(),
            value: value,
            label: "Duration",
            onChangeStart: processChangeStart,
            onChanged: processChange,
            onChangeEnd: processChangeEnd,
          );
        } else {
          return Container();
        }
      },
    );
  }

  void processChangeStart(newValue) {
    sub.pause();
    processChange(newValue);
  }

  void processChangeEnd(newValue) {
    sub.resume();
    processChange(newValue);
  }

  void processChange(double newValue) {
    var position = Duration(seconds: newValue.toInt());
    widget.player.seekTo(position);
    setState(() {
      value = newValue;
    });
  }

  void dispose() {
    sub.cancel();
    super.dispose();
  }
}
