import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var deepColor = Colors.deepPurple[900];

var mediumColor = Colors.deepPurple[600];
var lightColor = Colors.deepPurple[400];
var bgColor = deepColor;

ThemeData getDarkTheme() {
  return ThemeData(
      primaryColor: lightColor,
      accentColor: mediumColor,
      backgroundColor: deepColor,
      buttonColor: deepColor,
      splashColor: mediumColor,
      sliderTheme: SliderThemeData(
        valueIndicatorColor: Colors.white,
        // progress line to the right
        inactiveTrackColor: Colors.red,
        // progress line to the left
        activeTrackColor: deepColor,
        // wave color when dragging
        overlayColor: deepColor,
        // button
        thumbColor: mediumColor,
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.white),
        headline6: GoogleFonts.roboto(color: Colors.white),
        headline4: GoogleFonts.tenorSans(
          color: Colors.white,
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
                return mediumColor!;
              }
              return lightColor!; // Defer to the widget's default.
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
      appBarTheme: AppBarTheme(
        color: bgColor,
      ));
}
