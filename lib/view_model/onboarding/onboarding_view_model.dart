import 'package:flutter/material.dart';
import 'package:graduation_project/data/models/onboarding_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  int _currentPage = 0;
  final PageController pageController = PageController();

  int get currentPage => _currentPage;

 
  final List<OnboardingModel> onboardingPages = OnboardingModel.pages;

  bool get isLastPage => _currentPage == onboardingPages.length - 1;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}