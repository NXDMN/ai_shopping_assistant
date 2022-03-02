import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/model/purchaseHistory.dart';
import 'package:ai_shopping_assistant/services/paymentService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';

class PurchaseHistoryModel extends ChangeNotifier {
  bool _isLoading = false;
  late User _loggedInUser;

  late String _address;
  late double _subtotal;
  final double _deliveryFee = 10.00;
  late double _total;
  List<PurchaseHistory> _purchaseHistoryList = [];

  bool get isLoading => _isLoading;
  String get address => _address;
  double get subtotal => _subtotal;
  double get deliveryFee => _deliveryFee;
  double get total => _total;
  List<PurchaseHistory> get purchaseHistoryList => _purchaseHistoryList;

  PurchaseHistoryModel() {
    _init();
  }

  void _changeLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> _init() async {
    _changeLoading();
    _getCurrentUser();
    await _getPurchaseHistory();
    _changeLoading();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loggedInUser = user;
    }
  }

  Future<void> _getPurchaseHistory() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .collection('purchaseHistory')
        .get()
        .then((QuerySnapshot querySnapshot) {
      _purchaseHistoryList = querySnapshot.docs.map((document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return PurchaseHistory.fromJson(data);
      }).toList();
    });
  }

  double calculateSubtotal(List<CartProduct> products) {
    return products.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.quantity * element.price));
  }
}
