import 'package:ai_shopping_assistant/model/product.dart';
import 'package:ai_shopping_assistant/model/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class SearchResultsModel extends ChangeNotifier {
  bool _isLoading = false;
  late User _loggedInUser;
  late String _searchKeyword;
  late bool _isCategory;
  List<Product> _productList = [];
  List<Product> _filterProductList = [];

  double _minPrice = 0.0;
  double _maxPrice = 9999.99;

  bool get isLoading => _isLoading;
  List<Product> get filterProductList => _filterProductList;

  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;

  SearchResultsModel(String searchKeyword, bool isCategory) {
    _searchKeyword = searchKeyword;
    _isCategory = isCategory;
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

    List<String> productsId = await _getPredictions();

    _productList = _productList
        .where((product) => _isCategory
            ? product.category == _searchKeyword
            : ("${product.name.toLowerCase()} ${product.description.toLowerCase()}")
                .contains(_searchKeyword.toLowerCase()))
        .toList();

    // inversed so the sort in descendings can prioritize productsId
    productsId = productsId.reversed.toList();

    // use descending sort to allow productsId at start
    _productList.sort(
        (a, b) => productsId.indexOf(b.id).compareTo(productsId.indexOf(a.id)));

    _filterProductList = _productList;
  }

  Future<List<String>> _getPredictions() async {
    late int userId;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .get()
        .then((doc) {
      Map<String, dynamic> data = doc.data()!;
      userId = data['id'];
    });

    final interpreter = await Interpreter.fromAsset('model.tflite');
    interpreter.allocateTensors();

    var input0 = [userId];
    var inputs = [input0];
    // print(interpreter.getInputTensors());

    var output0 = List.filled(1 * 10, 0).reshape([1, 10]);
    var output1 = List.filled(1 * 10, 0).reshape([1, 10]);

    var outputs = {0: output0, 1: output1};
    // print(interpreter.getOutputTensors());

    interpreter.runForMultipleInputs(inputs, outputs);
    List<double> data = outputs[1]?[0];
    List<String> ids =
        data.map<String>((e) => e.truncate().toString()).toList();
    interpreter.close();

    return ids;
  }

  void filterResults() {
    _filterProductList = _productList
        .where((product) =>
            product.price >= _minPrice && product.price <= _maxPrice)
        .toList();
    notifyListeners();
  }
}
