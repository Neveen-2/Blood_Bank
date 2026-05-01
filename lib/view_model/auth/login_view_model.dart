// lib/view_model/auth/login_view_model.dart

import 'package:flutter/material.dart';
import 'package:graduation_project/core/constants/app_enums.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthStatus _status = AuthStatus.idle;
  String _errorMessage = '';
  bool _obscurePassword = true;

  AuthStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _status == AuthStatus.loading;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _errorMessage = 'Please fill all fields';
      _status = AuthStatus.error;
      notifyListeners();
      return;
    }

    _status = AuthStatus.loading;
    notifyListeners();

    // simulate api call
    await Future.delayed(const Duration(seconds: 2));

    _status = AuthStatus.success;
    notifyListeners();
  }

  void resetStatus() {
    _status = AuthStatus.idle;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
