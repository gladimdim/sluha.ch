import 'package:audiobooks_app/models/player.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class FileProgressView extends StatefulWidget {
  const FileProgressView({Key? key}): super(key: key);
  
  @override
  State<FileProgressView> createState() => _FileProgressViewState();
}

class _FileProgressViewState extends State<FileProgressView> {
  Duration current = Duration.zero;
  Duration total = Duration.zero;

  @override
  void initState() {
    super.initState();
    Player.instance.progressChanges.listen((event) {
      current = event.item1;
      total = event.item2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Tuple2<Duration, Duration>>(
      stream: Player.instance.progressChanges,
      builder: (context, data) {
        Tuple2<Duration, Duration> tuple = data.data ?? Tuple2(current, total);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${durationToString(tuple.item1)}",
              textAlign: TextAlign.end,
            ),
            Text(
              "${durationToString(tuple.item2)}",
              textAlign: TextAlign.end,
            ),
          ],
        );
      },
    );
  }

  String durationToString(Duration duration) {
    var mins = duration.inMinutes;
    var secs = duration.inSeconds.remainder(60);
    var sSeconds = secs < 10 ? "0$secs" : secs.toString();
    return "$mins:$sSeconds";
  }
}
