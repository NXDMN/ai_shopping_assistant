import 'dart:convert';

import 'package:ai_shopping_assistant/screens/cart/view/cart_screen.dart';
import 'package:ai_shopping_assistant/screens/home/view/categories_tab.dart';
import 'package:ai_shopping_assistant/screens/home/view/for_you_tab.dart';
import 'package:ai_shopping_assistant/screens/home/view/home_tab.dart';
import 'package:ai_shopping_assistant/screens/home/view_model/home_model.dart';
import 'package:ai_shopping_assistant/screens/search/view/search_screen.dart';
import 'package:ai_shopping_assistant/services/firebaseDynamicLinkService.dart';
import 'package:ai_shopping_assistant/widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:ai_shopping_assistant/widgets/myTabBar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    FirebaseDynamicLinkService.initDynamicLink(context);
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (context) => HomeModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: MyDrawer(
          homeSelected: true,
        ),
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
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
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        suffixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.only(top: 15.0, left: 10.0),
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
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
                  bottom: ColoredTabBar(
                    color: Colors.white,
                    tabBar: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          text: 'Home',
                        ),
                        Tab(
                          text: 'Categories',
                        ),
                        Tab(
                          text: 'For You',
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Consumer<HomeModel>(
              builder: (context, model, child) {
                return model.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          HomeTab(model: model),
                          CategoriesTab(model: model),
                          ForYouTab(model: model),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
