import 'package:audio_service/audio_service.dart';
import 'package:audiobooks_app/models/audioservice.dart';
import 'package:audiobooks_app/models/player.dart';
import 'package:audiobooks_app/themes/dark_theme.dart';
import 'package:audiobooks_app/themes/white_theme.dart';
import 'package:audiobooks_app/main_view.dart';
import 'package:flutter/material.dart';

AudioHandler audioHandler;

void main() async {
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidEnableQueue: true,
    ),
  );

  Player.instance.setHandler(audioHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // color: Colors.grey,
      title: 'Слухач',
      themeMode: ThemeMode.system,
      // themeMode: ThemeMode.dark,
      theme: getWhiteTheme(),
      darkTheme: getDarkTheme(),
      home: MainView(audioHandler: audioHandler),
    );
  }
}
