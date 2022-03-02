import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/model/purchaseHistory.dart';
import 'package:ai_shopping_assistant/services/paymentService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';

class CheckoutModel extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';

  late User _loggedInUser;

  late String _address;
  late double _subtotal;
  final double _deliveryFee = 10.00;
  late double _total;
  List<CartProduct> _cartProductList = [];
  Map<String, dynamic>? _paymentIntentData;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get address => _address;
  double get subtotal => _subtotal;
  double get deliveryFee => _deliveryFee;
  double get total => _total;
  List<CartProduct> get cartProductList => _cartProductList;

  CheckoutModel() {
    _init();
  }

  void _changeLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> _init() async {
    _changeLoading();
    _getCurrentUser();
    await _getAddress();
    await _getCartProducts();
    _calculateAll();
    _changeLoading();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loggedInUser = user;
    }
  }

  Future<void> _getAddress() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .get()
        .then((doc) {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      _address = data['address'];
    });
  }

  Future<void> updateAddress(String newAddress) async {
    _changeLoading();
    _address = newAddress;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .update({'address': newAddress});
    _changeLoading();
    notifyListeners();
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

  void _calculateAll() {
    _subtotal = _cartProductList.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.quantity * element.price));
    _total = _subtotal + _deliveryFee;
  }

  Future<bool> makePayment() async {
    try {
      Map<String, dynamic> data = {
        'amount': '${(_total * 100).truncate()}',
        'currency': 'myr',
        'payment_method_types[]': 'card',
      };
      _paymentIntentData = await PaymentService.createPaymentIntent(data);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: _paymentIntentData!['client_secret'],
        applePay: true,
        googlePay: true,
        style: ThemeMode.dark,
        merchantCountryCode: 'MY',
        merchantDisplayName: 'Shopper',
        testEnv: true,
      ));

      await Stripe.instance.presentPaymentSheet();

      String id = _paymentIntentData!['id'];

      PurchaseHistory purchaseHistory = PurchaseHistory(
        id: id,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        address: _address,
        total: (_subtotal + _deliveryFee),
        products: _cartProductList,
      );

      _paymentIntentData = null;

      await FirebaseFirestore.instance
          .collection('user')
          .doc(_loggedInUser.uid)
          .collection('purchaseHistory')
          .doc(id)
          .set(purchaseHistory.toJson());

      return true;
    } on StripeException catch (e) {
      _errorMessage = e.error.localizedMessage ?? 'Error occured';
      return false;
    }
  }
}
