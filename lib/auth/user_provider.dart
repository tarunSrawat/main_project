import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  User? user;

  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }
}
