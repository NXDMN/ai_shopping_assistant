import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/screens/cart/view/cart_screen.dart';
import 'package:ai_shopping_assistant/screens/search/view/search_results_screen.dart';
import 'package:ai_shopping_assistant/screens/search/view_model/search_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const id = 'search_screen';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchModel _model;
  String searchKeyword = "";
  final TextEditingController _controller = TextEditingController();
  bool showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _model = SearchModel();
    _controller.addListener(() {
      searchKeyword = _controller.text;
      setState(() {
        if (_controller.text == "") {
          showSuggestions = false;
        } else {
          showSuggestions = true;
        }
      });
      _model.filterQuerySuggestions(searchKeyword);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _model,
      child: Consumer<SearchModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    elevation: 0.0,
                    pinned: true,
                    floating: true,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        controller: _controller,
                        onFieldSubmitted: (value) async {
                          await model.addSearchHistory(searchKeyword);
                          Navigator.pushNamed(
                            context,
                            SearchResultsScreen.id,
                            arguments: SearchResultsScreenArguments(
                                searchKeyword: searchKeyword),
                          );
                          _controller.clear();
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          suffixIcon: GestureDetector(
                            child: const Icon(Icons.search),
                            onTap: () async {
                              await model.addSearchHistory(searchKeyword);
                              Navigator.pushNamed(
                                context,
                                SearchResultsScreen.id,
                                arguments: SearchResultsScreenArguments(
                                    searchKeyword: searchKeyword),
                              );
                              _controller.clear();
                            },
                          ),
                          contentPadding:
                              const EdgeInsets.only(top: 15.0, left: 10.0),
                          border: const UnderlineInputBorder(),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
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
                  ),
                ];
              },
              body: model.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : showSuggestions
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: model.filterQuerySuggestionList.length,
                          itemBuilder: (context, index) {
                            String querySuggestion =
                                model.filterQuerySuggestionList[index];
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              dense: true,
                              title: GestureDetector(
                                child: Wrap(
                                  children: [
                                    Text(
                                      querySuggestion,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: MyTextStyle.mediumSmall,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  model.addSearchHistory(querySuggestion);
                                  Navigator.pushNamed(
                                    context,
                                    SearchResultsScreen.id,
                                    arguments: SearchResultsScreenArguments(
                                        searchKeyword: querySuggestion),
                                  );
                                  _controller.clear();
                                },
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: model.searchHistoryList.length,
                          itemBuilder: (context, index) {
                            String searchHistory =
                                model.searchHistoryList[index];
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              dense: true,
                              title: GestureDetector(
                                child: Wrap(
                                  children: [
                                    Text(
                                      searchHistory,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: MyTextStyle.mediumSmall,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    SearchResultsScreen.id,
                                    arguments: SearchResultsScreenArguments(
                                        searchKeyword: searchHistory),
                                  );
                                  _controller.clear();
                                },
                              ),
                              trailing: GestureDetector(
                                child: const Icon(Icons.close),
                                onTap: () {
                                  model.removeSearchHistory(searchHistory);
                                },
                              ),
                            );
                          },
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
