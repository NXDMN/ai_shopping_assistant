import 'package:ai_shopping_assistant/model/favouriteProduct.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FavouriteModel extends ChangeNotifier {
  bool _isLoading = false;
  late User _loggedInUser;

  List<FavouriteProduct> _favouriteProductList = [];
  List<Product> _recommendedProductList = [];

  bool get isLoading => _isLoading;
  List<FavouriteProduct> get favouriteProductList => _favouriteProductList;
  List<Product> get recommendedProductList => _recommendedProductList;

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
    await _getRecommendationProducts();
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

  Future<void> _getRecommendationProducts() async {
    List<String> productsId = await _getPredictions();

    for (int i = 0; i < productsId.length; i++) {
      await FirebaseFirestore.instance
          .collection('product')
          .doc(productsId[i])
          .get()
          .then((doc) {
        Map<String, dynamic> data = doc.data()!;
        _recommendedProductList.add(Product.fromJson(data));
      });
    }
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
