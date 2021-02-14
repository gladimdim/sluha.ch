import 'package:audiobooks_app/themes/dark_theme.dart';
import 'package:audiobooks_app/themes/white_theme.dart';
import 'package:audiobooks_app/main_view.dart';
import 'package:flutter/material.dart';

void main() {
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
