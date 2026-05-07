// lib/view_model/auth/login_view_model.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_enums.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    //authenticate user with Firebase
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      _status = AuthStatus.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMessage = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Wrong password';
      } else if (e.code == 'invalid-email') {
        _errorMessage = 'Invalid email';
      } else {
        _errorMessage = e.message ?? 'Login failed';
      }
      _status = AuthStatus.error;
    } catch (e) {
      _errorMessage = 'Something went wrong';
      _status = AuthStatus.error;
    }

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
