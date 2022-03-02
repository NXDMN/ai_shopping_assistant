import 'package:ai_shopping_assistant/model/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreferencesModel extends ChangeNotifier {
  bool _isLoading = false;
  late User _loggedInUser;
  List<String> _preferencesList = [];

  bool get isLoading => _isLoading;
  List<String> get preferencesList => _preferencesList;

  PreferencesModel() {
    _init();
  }

  void _changeLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> _init() async {
    _changeLoading();
    _getCurrentUser();
    await _getPreferences();
    _changeLoading();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loggedInUser = user;
    }
  }

  Future<void> _getPreferences() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .get()
        .then((doc) {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      UserProfile user = UserProfile.fromJson(data);
      _preferencesList = user.preferences;
    });
  }

  Future<void> addPreferences(String preferences) async {
    _changeLoading();
    _preferencesList.add(preferences);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .update({'preferences': _preferencesList});
    _changeLoading();
    notifyListeners();
  }

  Future<void> removePreferences(String preferences) async {
    _changeLoading();
    _preferencesList.remove(preferences);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(_loggedInUser.uid)
        .update({'preferences': _preferencesList});
    _changeLoading();
    notifyListeners();
  }
}
