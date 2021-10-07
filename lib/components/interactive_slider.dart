import 'dart:async';

import 'package:audiobooks_app/components/file_progress_view.dart';
import 'package:audiobooks_app/models/player.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class InteractiveSlider extends StatefulWidget {
  final Player player;

  const InteractiveSlider({Key? key, required this.player}) : super(key: key);

  @override
  _InteractiveSliderState createState() => _InteractiveSliderState();
}

class _InteractiveSliderState extends State<InteractiveSlider> {
  double value = 0;
  late StreamSubscription sub;
  Duration position = Duration.zero;
  Duration total = Duration.zero;

  @override
  void initState() {
    super.initState();
    sub = widget.player.progressChanges.listen((event) {
      setState(() {
        value = event.item1.inSeconds.toDouble();
      });
    });
  }

  @override
  void didUpdateWidget(InteractiveSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var player = widget.player;
    return Stack(
      children: [
        StreamBuilder<Tuple2<Duration, Duration>>(
          stream: player.progressChanges,
          builder: (context, snapshot) {
            Tuple2<Duration, Duration> durations = snapshot.data ?? Tuple2(Duration.zero, Duration.zero);
            return Slider(
              min: 0,
              max: durations.item2.inSeconds.toDouble(),
              value: durations.item1.inSeconds.toDouble(),
              label: "Duration",
              onChangeStart: processChangeStart,
              onChanged: processChange,
              onChangeEnd: processChangeEnd,
            );
          },
        ),
        Positioned.fill(
          top: 35,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FileProgressView(
              key: ValueKey(widget.player.book?.title),
            ),
          ),
        ),
      ],
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
