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

      late int newId;

      await FirebaseFirestore.instance
          .collection('user')
          .get()
          .then((querySnapshot) {
        newId = querySnapshot.size + 1;
      });

      UserProfile user = UserProfile(
        id: newId,
        name: name,
        age: age,
        phone: phone,
        email: email,
        password: password,
        preferences: [],
        searchHistory: [],
      );
      _addUser(newUser.user!.uid, user);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Error occured';
      return false;
    }
  }

  Future<void> _addUser(String uid, UserProfile user) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .set(user.toJson());
  }
}
