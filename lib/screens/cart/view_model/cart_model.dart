import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartModel extends ChangeNotifier {
  bool _isLoading = false;
  late User _loggedInUser;

  List<CartProduct> _cartProductList = [];

  bool get isLoading => _isLoading;
  List<CartProduct> get cartProductList => _cartProductList;

  CartModel() {
    _init();
  }

  void _changeLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> _init() async {
    _changeLoading();
    _getCurrentUser();
    await _getCartProducts();
    _changeLoading();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loggedInUser = user;
    }
  }

  Future<void> _getCartProducts() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .collection('cart')
        .get()
        .then((QuerySnapshot querySnapshot) {
      _cartProductList = querySnapshot.docs.map((document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return CartProduct.fromJson(data);
      }).toList();
    });
  }

  void changeProductQuantity(CartProduct cartProduct, bool add) async {
    _changeLoading();
    add ? cartProduct.quantity++ : cartProduct.quantity--;
    if (cartProduct.quantity == 0) {
      _cartProductList.remove(cartProduct);
      await FirebaseFirestore.instance
          .collection('user')
          .doc(_loggedInUser.uid)
          .collection('cart')
          .doc(cartProduct.id)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(_loggedInUser.uid)
          .collection('cart')
          .doc(cartProduct.id)
          .update({'quantity': cartProduct.quantity});
    }
    _changeLoading();
    notifyListeners();
  }

  double calculateSubtotal() {
    return _cartProductList.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.quantity * element.price));
  }

  Future<void> removeFromCart(CartProduct cartProduct) async {
    _changeLoading();
    _cartProductList.remove(cartProduct);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .collection('cart')
        .doc(cartProduct.id)
        .delete();
    _changeLoading();
    notifyListeners();
  }
}
