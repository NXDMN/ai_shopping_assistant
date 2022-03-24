import 'package:ai_shopping_assistant/screens/home/view_model/home_model.dart';
import 'package:ai_shopping_assistant/screens/search/view/search_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:ai_shopping_assistant/constants.dart';

class CategoriesTab extends StatefulWidget {
  final HomeModel model;

  CategoriesTab({
    required this.model,
  });

  @override
  _CategoriesTabState createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  HomeModel get _model => widget.model;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _model.categoriesMap.entries.toList().length,
      separatorBuilder: (context, index) => const MyDivider(),
      itemBuilder: (context, index) {
        MapEntry<String, String> category =
            _model.categoriesMap.entries.toList()[index];
        return Container(
          height: 100.0,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(category.key),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('$imagePath${category.value}'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                SearchResultsScreen.id,
                arguments: SearchResultsScreenArguments(
                    searchKeyword: category.key, isCategory: true),
              );
            },
          ),
        );
      },
    );
  }
}
