import 'package:flutter/material.dart';

///RegExp
final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

final RegExp ageRegex = RegExp(r'^[0-9]+$');

final RegExp phoneRegex = RegExp(r'^[0-9]+$');

///TextStyle
class MyTextStyle {
  static const large = TextStyle(
    fontSize: 24.0,
    color: Colors.black,
  );
  static const largeBold = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const medium = TextStyle(
    fontSize: 18.0,
    color: Colors.black,
  );
  static const mediumBold = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const mediumSmall = TextStyle(
    fontSize: 16.0,
    color: Colors.black,
  );
  static const small = TextStyle(
    fontSize: 14.0,
    color: Colors.black,
  );
}

///Colors
class MyColors {
  static const primary = Color(0xff81D3F8);
}
