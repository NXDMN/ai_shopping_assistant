import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/screens/cart_screen.dart';
import 'package:ai_shopping_assistant/screens/checkout_screen.dart';
import 'package:ai_shopping_assistant/screens/home_screen.dart';
import 'package:ai_shopping_assistant/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:ai_shopping_assistant/screens/register_screen.dart';
import 'package:ai_shopping_assistant/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: MyColors.primary,
              width: 2.0,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: MyColors.primary,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      initialRoute: CheckoutScreen.id,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ProductDetailsScreen.id: (context) => const ProductDetailsScreen(),
        CartScreen.id: (context) => const CartScreen(),
        CheckoutScreen.id: (context) => const CheckoutScreen(),
      },
    ),
  );
}
