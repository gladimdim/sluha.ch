import 'package:audiobooks_app/themes/dark_theme.dart';
import 'package:audiobooks_app/themes/white_theme.dart';
import 'package:audiobooks_app/main_view.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
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
      home: MainView(),
    );
  }
}
