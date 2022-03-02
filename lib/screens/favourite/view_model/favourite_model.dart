import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/model/favouriteProduct.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouriteModel extends ChangeNotifier {
  bool _isLoading = false;
  late User _loggedInUser;

  List<FavouriteProduct> _favouriteProductList = [];
  List<Product> _productList = [];

  bool get isLoading => _isLoading;
  List<FavouriteProduct> get favouriteProductList => _favouriteProductList;
  List<Product> get productList => _productList.take(10).toList();

  FavouriteModel() {
    _init();
  }

  void _changeLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> _init() async {
    _changeLoading();
    _getCurrentUser();
    await _getFavouriteProducts();
    await _getProducts();
    _changeLoading();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loggedInUser = user;
    }
  }

  Future<void> _getFavouriteProducts() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .collection('favourite')
        .get()
        .then((QuerySnapshot querySnapshot) {
      _favouriteProductList = querySnapshot.docs.map((document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return FavouriteProduct.fromJson(data);
      }).toList();
    });
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

  Future<void> updateNotification(
      FavouriteProduct favouriteProduct, bool value) async {
    _changeLoading();
    favouriteProduct.notification = value;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .collection('favourite')
        .doc(favouriteProduct.id)
        .update({'notification': value});
    _changeLoading();
    notifyListeners();
  }

  Future<void> removeFromFavourite(FavouriteProduct favouriteProduct) async {
    _changeLoading();
    _favouriteProductList.remove(favouriteProduct);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .collection('favourite')
        .doc(favouriteProduct.id)
        .delete();
    _changeLoading();
    notifyListeners();
  }
}
