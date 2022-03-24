import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/model/cartProduct.dart';
import 'package:ai_shopping_assistant/model/favouriteProduct.dart';
import 'package:ai_shopping_assistant/model/product.dart';
import 'package:ai_shopping_assistant/model/purchaseHistory.dart';
import 'package:ai_shopping_assistant/services/firebaseDynamicLinkService.dart';
import 'package:document_analysis/document_analysis.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ProductDetailsModel extends ChangeNotifier {
  bool _isLoading = false;
  late User _loggedInUser;
  late String _productId;
  late Product _product;
  bool _isFavourite = false;
  List<Product> _similarProductList = [];
  List<Product> _recommendedProductList = [];

  bool get isLoading => _isLoading;
  Product get product => _product;
  bool get isFavourite => _isFavourite;
  List<Product> get similarProductList => _similarProductList;
  List<Product> get recommendedProductList => _recommendedProductList;

  ProductDetailsModel(String productId) {
    _productId = productId;
    _init();
  }

  void _changeLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> _init() async {
    _changeLoading();
    _getCurrentUser();
    await _getProduct();
    await _getSimilarProducts();
    await _getRecommendationProducts();
    await _checkIsFavourite();
    _changeLoading();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loggedInUser = user;
    }
  }

  Future<void> _getProduct() async {
    await FirebaseFirestore.instance
        .collection('product')
        .doc(_productId)
        .get()
        .then((doc) {
      Map<String, dynamic> data = doc.data()!;
      _product = Product.fromJson(data);
    });
  }

  Future<void> _getSimilarProducts() async {
    await FirebaseFirestore.instance
        .collection('contentBased')
        .doc(_product.id)
        .get()
        .then((doc) async {
      Map<String, dynamic> data = doc.data()!;
      List<String> productsId =
          data['products'].map((e) => e['id']).toList().cast<String>();

      for (int i = 0; i < productsId.length; i++) {
        await FirebaseFirestore.instance
            .collection('product')
            .doc(productsId[i])
            .get()
            .then((doc) {
          Map<String, dynamic> data = doc.data()!;
          _similarProductList.add(Product.fromJson(data));
        });
      }
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

      await _updatePreferences();
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

      if (_product.id == id) {
        keywordPosition.add(i);
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

  Future<void> shareProduct() async {
    String generatedLink =
        await FirebaseDynamicLinkService.createDynamicLink(_productId);
    Share.share('Check out this amazing product $generatedLink');
  }
}
