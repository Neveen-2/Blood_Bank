import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isReady = false;

  bool get isReady => _isReady;

  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 3));
    _isReady = true;
    notifyListeners();
  }
}