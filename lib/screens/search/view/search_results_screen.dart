import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:ai_shopping_assistant/screens/search/view/filter_sheet.dart';
import 'package:ai_shopping_assistant/screens/search/view/search_screen.dart';
import 'package:ai_shopping_assistant/screens/search/view_model/search_results_model.dart';
import 'package:ai_shopping_assistant/widgets/myDrawer.dart';
import 'package:ai_shopping_assistant/widgets/myMainSliverAppBar.dart';
import 'package:ai_shopping_assistant/widgets/myProductCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultsScreenArguments {
  final String searchKeyword;
  final bool isCategory;

  SearchResultsScreenArguments({
    required this.searchKeyword,
    this.isCategory = false,
  });
}

class SearchResultsScreen extends StatefulWidget {
  static const id = 'search_results_screen';
  final SearchResultsScreenArguments args;

  SearchResultsScreen({required this.args});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  String get _searchKeyword => widget.args.searchKeyword;
  bool get _isCategory => widget.args.isCategory;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchResultsModel(_searchKeyword, _isCategory),
      child: Consumer<SearchResultsModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          drawer: MyDrawer(),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                MyMainSliverAppBar(
                  searchKeyword: _searchKeyword,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(
                                Icons.filter_alt,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Filter',
                                style: MyTextStyle.mediumSmall,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) =>
                                      ChangeNotifierProvider.value(
                                    value: model,
                                    child: FilterSheet(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                model.isLoading
                    ? SliverFillViewport(
                        delegate: SliverChildListDelegate([
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      ]))
                    : model.filterProductList.isEmpty
                        ? const SliverFillRemaining(
                            child: Center(
                            child: Text('Product not found'),
                          ))
                        : SliverPadding(
                            padding: const EdgeInsets.all(20.0),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  Product product =
                                      model.filterProductList[index];
                                  return MyProductCard(product: product);
                                },
                                childCount: model.filterProductList.length,
                              ),
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
