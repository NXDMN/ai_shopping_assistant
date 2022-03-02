import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/model/favouriteProduct.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailsModel extends ChangeNotifier {
  bool _isLoading = false;
  late User _loggedInUser;
  late Product _product;
  bool _isFavourite = false;
  List<Product> _productList = [];

  bool get isLoading => _isLoading;
  bool get isFavourite => _isFavourite;
  List<Product> get productList => _productList.take(10).toList();

  ProductDetailsModel(Product product) {
    _product = product;
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
    await _checkIsFavourite();
    _changeLoading();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loggedInUser = user;
    }
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

  Future<void> _checkIsFavourite() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .collection('favourite')
        .doc(_product.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        _isFavourite = true;
      } else {
        _isFavourite = false;
      }
    });
  }

  Future<void> updateFavourite() async {
    _changeLoading();
    _isFavourite = !_isFavourite;

    if (_isFavourite) {
      FavouriteProduct favouriteProduct = FavouriteProduct(
          id: _product.id,
          name: _product.name,
          image: _product.images[0],
          price: _product.price,
          notification: false);

      await FirebaseFirestore.instance
          .collection('user')
          .doc(_loggedInUser.uid)
          .collection('favourite')
          .doc(_product.id)
          .set(favouriteProduct.toJson());
    } else {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(_loggedInUser.uid)
          .collection('favourite')
          .doc(_product.id)
          .delete();
    }
    _changeLoading();
    notifyListeners();
  }

  Future<void> addToCart(CartProduct cartProduct) async {
    _changeLoading();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .collection('cart')
        .doc(cartProduct.id)
        .get()
        .then((doc) async {
      if (doc.exists) {
        int newQty = doc.data()?['quantity'] + cartProduct.quantity;
        await FirebaseFirestore.instance
            .collection('user')
            .doc(_loggedInUser.uid)
            .collection('cart')
            .doc(cartProduct.id)
            .update({'quantity': newQty});
      } else {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(_loggedInUser.uid)
            .collection('cart')
            .doc(cartProduct.id)
            .set(cartProduct.toJson());
      }
    });
    _changeLoading();
  }
}
