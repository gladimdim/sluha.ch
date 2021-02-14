import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var DEEP_COLOR = Colors.red[900];

var MEDIUM_COLOR = Colors.deepPurple[600];
var LIGHT_COLOR = Colors.deepPurple[400];
var BG_COLOR = DEEP_COLOR;

ThemeData getDarkTheme() {
  return ThemeData(
    primaryColor: LIGHT_COLOR,
    accentColor: MEDIUM_COLOR,
    backgroundColor: LIGHT_COLOR,
    buttonColor: DEEP_COLOR,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
      headline6: TextStyle(color: Colors.white),
    ),
    iconTheme: IconThemeData(
      color: DEEP_COLOR,
      size: 44,
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
            return Colors.black;
          } else if (states.contains(MaterialState.pressed)) {
            return Colors.white;
          }
          return Colors.white;
        }),
      ),
    ),
  );
}
