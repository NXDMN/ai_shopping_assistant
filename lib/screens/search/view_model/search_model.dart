import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/model/favouriteProduct.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:ai_shopping_assistant/model/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchModel extends ChangeNotifier {
  bool _isLoading = false;
  late User _loggedInUser;
  List<String> _searchHistoryList = [];
  List<String> _querySuggestionList = [];
  List<String> _filterQuerySuggestionList = [];

  bool get isLoading => _isLoading;
  List<String> get searchHistoryList => _searchHistoryList;
  List<String> get filterQuerySuggestionList => _filterQuerySuggestionList;

  SearchModel() {
    _init();
  }

  void _changeLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> _init() async {
    _changeLoading();
    _getCurrentUser();
    await _getQuerySuggestions();
    await _getSearchHistory();
    _changeLoading();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loggedInUser = user;
    }
  }

  Future<void> _getSearchHistory() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .get()
        .then((doc) {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      UserProfile user = UserProfile.fromJson(data);
      _searchHistoryList = user.searchHistory;
    });
  }

  Future<void> addSearchHistory(String searchKeyword) async {
    _changeLoading();
    _searchHistoryList.add(searchKeyword);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .update({'searchHistory': _searchHistoryList});
    _changeLoading();
    notifyListeners();
  }

  Future<void> removeSearchHistory(String searchHistory) async {
    _changeLoading();
    _searchHistoryList.remove(searchHistory);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .update({'searchHistory': _searchHistoryList});
    _changeLoading();
    notifyListeners();
  }

  Future<void> _getQuerySuggestions() async {
    await FirebaseFirestore.instance
        .collection('product')
        .get()
        .then((QuerySnapshot querySnapshot) {
      _querySuggestionList = querySnapshot.docs.map((document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return Product.fromJson(data).name;
      }).toList();
    });
    _filterQuerySuggestionList = _querySuggestionList;
  }

  void filterQuerySuggestions(String query) {
    _filterQuerySuggestionList = _querySuggestionList
        .where((element) => element.contains(query))
        .toList();
    notifyListeners();
  }
}
