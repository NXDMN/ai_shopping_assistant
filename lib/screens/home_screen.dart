import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/screens/categories_tab.dart';
import 'package:ai_shopping_assistant/screens/for_you_tab.dart';
import 'package:ai_shopping_assistant/screens/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:ai_shopping_assistant/widgets/myTextFormField.dart';
import 'package:ai_shopping_assistant/widgets/myTabBar.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  bool homeSelected = true;
  bool cartSelected = false;
  bool favouriteSelected = false;
  bool historySelected = false;
  bool preferencesSelected = false;

  Widget _buildDrawer() {
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
            leading: Icon(Icons.home),
            title: Text(
              'Home',
              style: MyTextStyle.medium,
            ),
            selected: homeSelected,
            onTap: () {
              setState(() {
                homeSelected = true;
                cartSelected = false;
                favouriteSelected = false;
                historySelected = false;
                preferencesSelected = false;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text(
              'Shopping Cart',
              style: MyTextStyle.medium,
            ),
            selected: cartSelected,
            onTap: () {
              setState(() {
                homeSelected = false;
                cartSelected = true;
                favouriteSelected = false;
                historySelected = false;
                preferencesSelected = false;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              'Favourite',
              style: MyTextStyle.medium,
            ),
            selected: favouriteSelected,
            onTap: () {
              setState(() {
                homeSelected = false;
                cartSelected = false;
                favouriteSelected = true;
                historySelected = false;
                preferencesSelected = false;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text(
              'Purchase History',
              style: MyTextStyle.medium,
            ),
            selected: historySelected,
            onTap: () {
              setState(() {
                homeSelected = false;
                cartSelected = false;
                favouriteSelected = false;
                historySelected = true;
                preferencesSelected = false;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.label),
            title: Text(
              'Preferences',
              style: MyTextStyle.medium,
            ),
            selected: preferencesSelected,
            onTap: () {
              setState(() {
                homeSelected = false;
                cartSelected = false;
                favouriteSelected = false;
                historySelected = false;
                preferencesSelected = true;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: MyTextStyle.medium,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.only(top: 15.0, left: 10.0),
                      border: UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
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
                    onPressed: () {},
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
              )
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: const [
              HomeTab(),
              CategoriesTab(),
              ForYouTab(),
            ],
          ),
        ),
      ),
    );
  }
}
