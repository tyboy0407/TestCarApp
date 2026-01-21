import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  // 模擬登入功能
  Future<bool> login(String username, String password) async {
    // 模擬網路延遲
    await Future.delayed(const Duration(seconds: 1));

    // 這裡可以加入真實的後端驗證邏輯
    // 目前只要帳號密碼不為空即可登入
    if (username.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _username = username;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    _username = null;
    notifyListeners();
  }
}
