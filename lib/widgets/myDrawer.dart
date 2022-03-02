import 'package:ai_shopping_assistant/screens/cart/view/cart_screen.dart';
import 'package:ai_shopping_assistant/screens/favourite/view/favourite_screen.dart';
import 'package:ai_shopping_assistant/screens/purchase_history/view/purchase_history_screen.dart';
import 'package:ai_shopping_assistant/screens/home/view/home_screen.dart';
import 'package:ai_shopping_assistant/screens/login/view/login_screen.dart';
import 'package:ai_shopping_assistant/screens/preferences/view/preferences_screen.dart';
import 'package:flutter/material.dart';
import 'package:ai_shopping_assistant/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  bool homeSelected;
  bool cartSelected;
  bool favouriteSelected;
  bool historySelected;
  bool preferencesSelected;

  MyDrawer({
    this.homeSelected = false,
    this.cartSelected = false,
    this.favouriteSelected = false,
    this.historySelected = false,
    this.preferencesSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.only(top: 16.0),
            child: Image.asset('assets/images/logo.jpg'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Home',
              style: MyTextStyle.medium,
            ),
            selected: homeSelected,
            onTap: () {
              Navigator.pushNamed(context, HomeScreen.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text(
              'Shopping Cart',
              style: MyTextStyle.medium,
            ),
            selected: cartSelected,
            onTap: () {
              Navigator.pushNamed(context, CartScreen.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text(
              'Favourite',
              style: MyTextStyle.medium,
            ),
            selected: favouriteSelected,
            onTap: () {
              Navigator.pushNamed(context, FavouriteScreen.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text(
              'Purchase History',
              style: MyTextStyle.medium,
            ),
            selected: historySelected,
            onTap: () {
              Navigator.pushNamed(context, PurchaseHistoryScreen.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.label),
            title: const Text(
              'Preferences',
              style: MyTextStyle.medium,
            ),
            selected: preferencesSelected,
            onTap: () {
              Navigator.pushNamed(context, PreferencesScreen.id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Logout',
              style: MyTextStyle.medium,
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
