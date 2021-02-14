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
