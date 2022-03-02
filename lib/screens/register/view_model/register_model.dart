import 'package:ai_shopping_assistant/model/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterModel extends ChangeNotifier {
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  RegisterModel();

  Future<bool> register(
      String name, int age, String phone, String email, String password) async {
    try {
      UserCredential newUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      UserProfile user = UserProfile(
        id: newUser.user!.uid,
        name: name,
        age: age,
        phone: phone,
        email: email,
        password: password,
        preferences: [],
        searchHistory: [],
      );
      _addUser(user);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Error occured';
      return false;
    }
  }

  Future<void> _addUser(UserProfile user) {
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    return users.doc(user.id).set(user.toJson());
  }
}
