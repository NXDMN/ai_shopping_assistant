import 'package:flutter/material.dart';

///imagePath
const String imagePath = 'assets/images/';

///Stripe keys
const String stripePublicKey =
    'pk_test_51KWm77G02R6mZpwj1vqQxKxqRbaudON8Ma99O78BJ2OMwh8sRGQSz4eOt3CIEryfx6wQJF5xUGsoOTNFnkfXkzPW00kk8rAPuD';
const String stripeSecretKey =
    'sk_test_51KWm77G02R6mZpwjcwukr5nQWFKlGYMf5APOjJe0ejUTZyOnkxEUo97sJS6BKfXD93Qz3SQVOqmc56g34zmqZlSx00ug4rbyUJ';

///RegExp
final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

final RegExp ageRegex = RegExp(r'^[0-9]+$');

final RegExp phoneRegex = RegExp(r'^[0-9]+$');

final RegExp priceRegex = RegExp(r'^\d+\.?\d{0,2}');

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
  static const shadow = Color(0xff757575);
}

///InputDecoration
class MyInputDecoration {
  static const rounded = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
}
