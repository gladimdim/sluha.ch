import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var deepColor = Colors.deepPurple;

var mediumColor = Colors.deepPurple[200];
var lightColor = Colors.deepPurple[100];
var bgColor = deepColor;

ThemeData getWhiteTheme() {
  return ThemeData(
    primaryColor: lightColor,
    accentColor: mediumColor,
    backgroundColor: lightColor,
    buttonColor: deepColor,
    sliderTheme: SliderThemeData(
      valueIndicatorColor: Colors.white,
      // progress line to the right
      inactiveTrackColor: deepColor,
      // progress line to the left
      activeTrackColor: Colors.red,
      // wave color when dragging
      overlayColor: deepColor,
      // button
      thumbColor: mediumColor,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black),
      headline6: GoogleFonts.roboto(color: Colors.black),
      headline4: GoogleFonts.tenorSans(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),
    iconTheme: IconThemeData(
      color: deepColor,
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
              return mediumColor;
            }
            return lightColor; // Defer to the widget's default.
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
  );
}
