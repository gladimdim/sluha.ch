import 'package:audiobooks_app/main_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

var DEEP_COLOR = Colors.deepPurple[500];

var MEDIUM_COLOR = Colors.deepPurple[400];
var LIGHT_COLOR = Colors.deepPurple[300];
var BG_COLOR = DEEP_COLOR;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // color: Colors.grey,
      title: 'Слухач',
      theme: ThemeData(
        // brightness: Brightness.dark,
        // primarySwatch: Colors.deepPurple,
        primaryColor: BG_COLOR,
        accentColor: LIGHT_COLOR,
        backgroundColor: LIGHT_COLOR,
        // cardTheme: CardTheme(color: MEDIUM_COLOR),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.resolveWith((states) {
              return GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              );
            }),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) return DEEP_COLOR;
                if (states.contains(MaterialState.focused) ||
                    states.contains(MaterialState.pressed)) return LIGHT_COLOR;
                return LIGHT_COLOR; // Defer to the widget's default.
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.green[300];
              } else if (states.contains(MaterialState.pressed)) {
                return Colors.blue[500];
              }
              return Colors.black;
            }),
          ),
        ),
      ),
      home: MainView(),
    );
  }
}

