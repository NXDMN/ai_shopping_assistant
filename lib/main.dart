import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/screens/cart/view/cart_screen.dart';
import 'package:ai_shopping_assistant/screens/checkout/view/checkout_screen.dart';
import 'package:ai_shopping_assistant/screens/favourite/view/favourite_screen.dart';
import 'package:ai_shopping_assistant/screens/purchase_history/view/purchase_history_details.screen.dart';
import 'package:ai_shopping_assistant/screens/purchase_history/view/purchase_history_screen.dart';
import 'package:ai_shopping_assistant/screens/home/view/home_screen.dart';
import 'package:ai_shopping_assistant/screens/home/view_model/home_model.dart';
import 'package:ai_shopping_assistant/screens/login/view_model/login_model.dart';
import 'package:ai_shopping_assistant/screens/preferences/view/preferences_screen.dart';
import 'package:ai_shopping_assistant/screens/product_details/view/product_details_screen.dart';
import 'package:ai_shopping_assistant/screens/register/view_model/register_model.dart';
import 'package:ai_shopping_assistant/screens/search/view/search_results_screen.dart';
import 'package:ai_shopping_assistant/screens/search/view/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_shopping_assistant/screens/register/view/register_screen.dart';
import 'package:ai_shopping_assistant/screens/login/view/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublicKey;

  await Firebase.initializeApp();
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginModel>(create: (_) => LoginModel()),
        ChangeNotifierProvider<RegisterModel>(create: (_) => RegisterModel()),
      ],
      child: MaterialApp(
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
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case LoginScreen.id:
              return MaterialPageRoute(
                  builder: (context) => const LoginScreen());
            case RegisterScreen.id:
              return MaterialPageRoute(
                  builder: (context) => const RegisterScreen());
            case HomeScreen.id:
              return MaterialPageRoute(
                  builder: (context) => const HomeScreen());
            case ProductDetailsScreen.id:
              final args = settings.arguments as ProductDetailsScreenArguments;
              return MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                  args: args,
                ),
              );
            case CartScreen.id:
              return MaterialPageRoute(
                  builder: (context) => const CartScreen());
            case CheckoutScreen.id:
              return MaterialPageRoute(
                  builder: (context) => const CheckoutScreen());
            case SearchScreen.id:
              return MaterialPageRoute(
                  builder: (context) => const SearchScreen());
            case SearchResultsScreen.id:
              final args = settings.arguments as SearchResultsScreenArguments;
              return MaterialPageRoute(
                builder: (context) => SearchResultsScreen(
                  args: args,
                ),
              );
            case FavouriteScreen.id:
              return MaterialPageRoute(
                  builder: (context) => const FavouriteScreen());
            case PurchaseHistoryScreen.id:
              return MaterialPageRoute(
                  builder: (context) => const PurchaseHistoryScreen());
            case PurchaseHistoryDetailsScreen.id:
              final args =
                  settings.arguments as PurchaseHistoryDetailsScreenArguments;
              return MaterialPageRoute(
                builder: (context) => PurchaseHistoryDetailsScreen(
                  args: args,
                ),
              );
            case PreferencesScreen.id:
              return MaterialPageRoute(
                builder: (context) => const PreferencesScreen(),
              );
            default:
          }
        },
      ),
    ),
  );
}
