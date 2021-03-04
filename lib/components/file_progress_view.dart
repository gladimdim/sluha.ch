import 'package:audiobooks_app/models/player.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class FileProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Player.instance.progressChanges,
        builder: (context, data) {
          if (data.hasData) {
            Tuple2<Duration, Duration> tuple = data.data;
            return Text(
                "${durationToString(tuple.item1)}/${durationToString(tuple.item2)}",
            textAlign: TextAlign.end,);
          } else {
            return Container();
          }
        });
  }

  String durationToString(Duration duration) {
    var mins = duration.inMinutes;
    var secs = duration.inSeconds.remainder(60);
    var sSeconds = secs < 10 ? "0$secs" : secs.toString();
    return "$mins:$sSeconds";
  }
}
