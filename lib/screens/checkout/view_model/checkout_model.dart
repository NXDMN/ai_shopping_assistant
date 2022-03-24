import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/model/favouriteProduct.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:ai_shopping_assistant/model/purchaseHistory.dart';
import 'package:ai_shopping_assistant/services/paymentService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:document_analysis/document_analysis.dart';

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
      Map<String, dynamic> data = doc.data()!;
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

  Future<bool> makePayment(PaymentOptions paymentOptions) async {
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
        merchantCountryCode: 'MYS',
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

      _changeLoading();
      await _updatePreferences();
      await _clearCart();
      _changeLoading();

      return true;
    } on StripeException catch (e) {
      _errorMessage = e.error.localizedMessage ?? 'Error occured';
      return false;
    }
  }

  Future<void> _clearCart() async {
    _cartProductList.clear();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .collection('cart')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (DocumentSnapshot doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Future<void> _updatePreferences() async {
    Set<String> ids = {};
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .collection('purchaseHistory')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        List<CartProduct> products = PurchaseHistory.fromJson(data).products;
        for (CartProduct product in products) {
          ids.add(product.id);
        }
      });
    });
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .collection('favourite')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        ids.add(FavouriteProduct.fromJson(data).id);
      });
    });

    List<int> keywordPosition = [];

    List<String> docList = [];

    for (int i = 0; i < ids.length; i++) {
      String id = ids.elementAt(i);
      for (CartProduct product in _cartProductList) {
        if (product.id == id) {
          keywordPosition.add(i);
        }
      }
      await FirebaseFirestore.instance
          .collection('product')
          .doc(id)
          .get()
          .then((doc) {
        Map<String, dynamic> data = doc.data()!;
        docList.add(Product.fromJson(data).description);
      });
    }

    docList = docList.map((doc) {
      doc = doc.toLowerCase();
      doc = doc.replaceAll(RegExp(r'[^\w\s]+'), '');
      doc = doc.replaceAll(RegExp(r'[^\D]+'), '');
      doc = doc.replaceAll("\n", '');
      List<String> tokens = doc.split(" ");
      tokens.removeWhere(
          (token) => token.length < 3 || stopwords.contains(token));
      return tokens.join(" ");
    }).toList();

    List<Map<String, double>> tfIdfProb =
        tfIdfProbability(documentTokenizer(docList));

    Set<String> preferences = {};
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .get()
        .then((doc) {
      Map<String, dynamic> data = doc.data()!;
      preferences.addAll(List.castFrom<dynamic, String>(data['preferences']));
    });

    for (int i = 0; i < tfIdfProb.length; i++) {
      if (keywordPosition.contains(i)) {
        Map<String, double> doc = tfIdfProb[i];
        List<String> sortedKeys = doc.keys.toList();
        sortedKeys.sort((a, b) => doc[a]!.compareTo(doc[b]!));
        preferences.addAll(sortedKeys.reversed.take(3));
      }
    }

    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .update({'preferences': preferences.toList()});
  }
}
