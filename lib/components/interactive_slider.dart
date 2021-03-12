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
              value: durations.item1.inSeconds.toDouble(),
              label: "Duration",
              onChanged: (value) {
                var position = Duration(seconds: value.toInt());
                player.seekTo(position);
              },
              onChangeEnd: (value) {
                var position = Duration(seconds: value.toInt());
                player.seekTo(position);
              },
            );
          } else {
            return Container();
          }
        });
  }
}
