import 'package:audiobooks_app/main_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

var DEEP_COLOR = Colors.deepPurple;

var MEDIUM_COLOR = Colors.deepPurple[200];
var LIGHT_COLOR = Colors.deepPurple[100];
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
        primaryColor: LIGHT_COLOR,
        accentColor: MEDIUM_COLOR,
        backgroundColor: LIGHT_COLOR,
        // cardTheme: CardTheme(color: MEDIUM_COLOR),
        scaffoldBackgroundColor: Colors.white,
        // splashColor: MEDIUM_COLOR,
        iconTheme: IconThemeData(
          color: DEEP_COLOR,
          size: 40,
        ),
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
                if (states.contains(MaterialState.hovered) ||
                    states.contains(MaterialState.focused) ||
                    states.contains(MaterialState.pressed)) {
                  return MEDIUM_COLOR;
                }
                return LIGHT_COLOR; // Defer to the widget's default.
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.white;
              } else if (states.contains(MaterialState.pressed)) {
                return Colors.white;
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
