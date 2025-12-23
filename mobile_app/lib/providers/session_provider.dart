import 'package:flutter/material.dart';

import '../models/user_session.dart';

class SessionProvider with ChangeNotifier {
  UserSession? _currentUser;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  UserSession? get currentUser => _currentUser;

  void login(UserSession user) {
    _currentUser = user;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
