import 'package:flutter/material.dart';

const rgbColor = Color.fromRGBO(
    118, 116, 208, 1); // Create a Color object with the RGB values

final primary = MaterialColor(
  0xFF3330D4, // Convert the RGB color to the equivalent primary color value
  <int, Color>{
    // Create a map of shades for the MaterialColor
    50: rgbColor.withOpacity(0.1),
    100: rgbColor.withOpacity(0.2),
    200: rgbColor.withOpacity(0.3),
    300: rgbColor.withOpacity(0.4),
    400: rgbColor.withOpacity(0.5),
    500: rgbColor.withOpacity(0.6),
    600: rgbColor.withOpacity(0.7),
    700: rgbColor.withOpacity(0.8),
    800: rgbColor.withOpacity(0.9),
    900: rgbColor.withOpacity(1.0),
  },
);

const rgbColor2 = Color.fromRGBO(
    125, 122, 228, 1.0); // Create a Color object with the RGB values
const rgbColor3 = Color.fromRGBO(237, 163, 254, 1);
final primary2 = MaterialColor(
  0xFF7D7AE4, // Convert the RGB color to the equivalent primary color value
  <int, Color>{
    // Create a map of shades for the MaterialColor
    50: rgbColor.withOpacity(0.1),
    100: rgbColor.withOpacity(0.2),
    200: rgbColor.withOpacity(0.3),
    300: rgbColor.withOpacity(0.4),
    400: rgbColor.withOpacity(0.5),
    500: rgbColor.withOpacity(0.6),
    600: rgbColor.withOpacity(0.7),
    700: rgbColor.withOpacity(0.8),
    800: rgbColor.withOpacity(0.9),
    900: rgbColor.withOpacity(1.0),
  },
);
var gradient = LinearGradient(
  colors: [primary, primary2],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);
const decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    ));
