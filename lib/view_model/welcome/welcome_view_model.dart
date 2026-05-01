import 'package:flutter/material.dart';

class WelcomeViewModel extends ChangeNotifier {
  bool _isAnimated = false;

  bool get isAnimated => _isAnimated;

  void triggerAnimation() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _isAnimated = true;
      notifyListeners();
    });
  }
}