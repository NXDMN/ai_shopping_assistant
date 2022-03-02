import 'package:ai_shopping_assistant/screens/cart/view/cart_screen.dart';
import 'package:ai_shopping_assistant/screens/search/view/search_screen.dart';
import 'package:flutter/material.dart';

class MyMainSliverAppBar extends StatelessWidget {
  final String? searchKeyword;

  MyMainSliverAppBar({this.searchKeyword});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0.0,
      pinned: true,
      floating: true,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: TextFormField(
          readOnly: true,
          onTap: () {
            Navigator.pushNamed(context, SearchScreen.id);
          },
          decoration: InputDecoration(
            hintText: searchKeyword ?? 'Search',
            hintStyle: const TextStyle(
              color: Colors.black,
            ),
            suffixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.only(top: 15.0, left: 10.0),
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.0),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.shopping_cart,
          ),
          onPressed: () {
            Navigator.pushNamed(context, CartScreen.id);
          },
        ),
      ],
    );
  }
}
