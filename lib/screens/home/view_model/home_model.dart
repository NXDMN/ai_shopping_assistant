import 'package:ai_shopping_assistant/model/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeModel extends ChangeNotifier {
  bool _isLoading = false;
  List<Product> _productList = [];
  Map<String, String> categoriesMap = {
    'Health & Beauty': 'Health & Beauty.png',
    'Baby & Toys': 'Baby & Toys.jpg',
    'Home & Living': 'Home & Living.png',
    'Shoes': 'Shoes.png',
    'Home Appliances': 'Home Appliances.jpg',
    'Mobile & Accessories': 'Mobile & Accessories.jpg',
    'Women Clothes': 'Women Clothes.jpeg',
    'Men Clothes': 'Men Clothes.jpg',
    'Watches': 'Watches.jpg',
    'Bags & Wallets': 'Bags & Wallets.jpg',
  };

  bool get isLoading => _isLoading;
  List<Product> get productList => _productList.take(10).toList();

  HomeModel() {
    _init();
  }

  void _changeLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> _init() async {
    _changeLoading();
    await _getProducts();
    _changeLoading();
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
  }
}
