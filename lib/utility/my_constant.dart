import 'package:flutter/material.dart';

class MyConstant {
  // field
  static Color textBar = Colors.grey;
  static Color textBody = Colors.black;

  // method
  TextStyle h1Style() => TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: textBody,
      );

  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textBody,
      );

  TextStyle h2QuoteStyle() => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

       TextStyle h3QuoteStyle() => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      );

  TextStyle h2BarStyle() => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textBar,
      );

  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textBody,
      );
}
