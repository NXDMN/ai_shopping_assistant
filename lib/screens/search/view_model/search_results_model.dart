import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:ai_shopping_assistant/model/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchResultsModel extends ChangeNotifier {
  bool _isLoading = false;
  late User _loggedInUser;
  late String _searchKeyword;
  List<Product> _productList = [];
  List<Product> _filterProductList = [];

  double _minPrice = 0.0;
  double _maxPrice = 9999.99;

  bool get isLoading => _isLoading;
  List<Product> get filterProductList => _filterProductList.take(10).toList();

  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;

  SearchResultsModel(String searchKeyword) {
    _searchKeyword = searchKeyword;
    _init();
  }

  void _changeLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> _init() async {
    _changeLoading();
    _getCurrentUser();
    await _getProducts();
    _changeLoading();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loggedInUser = user;
    }
  }

  void updateMinPrice(double newPrice) {
    _minPrice = newPrice;
  }

  void updateMaxPrice(double newPrice) {
    _maxPrice = newPrice;
  }

  Future<void> _getProducts() async {
    await FirebaseFirestore.instance
        .collection('product')
        .get()
        .then((QuerySnapshot querySnapshot) {
      _productList = querySnapshot.docs.map((document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return Product.fromJson(data);
      }).toList();
    });

    _productList = _productList
        .where((product) => product.name.contains(_searchKeyword))
        .toList();

    _filterProductList = _productList;
  }

  void filterResults() {
    _filterProductList = _productList
        .where((product) =>
            product.price >= _minPrice && product.price <= _maxPrice)
        .toList();
    notifyListeners();
  }
}
