// lib/view_model/auth/signup_view_model.dart

import 'package:flutter/material.dart';
import 'package:graduation_project/core/constants/app_enums.dart';

class SignupViewModel extends ChangeNotifier {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  AuthStatus _status = AuthStatus.idle;
  String _errorMessage = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  AuthStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get isLoading => _status == AuthStatus.loading;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  Future<void> signUp() async {
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _errorMessage = 'Please fill all required fields';
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
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    bloodTypeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
