import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_assets.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_routes.dart';
import 'package:blood_bank/core/widgets/onboarding_page.dart';
import 'package:blood_bank/core/widgets/outline_button.dart';
import 'package:blood_bank/core/widgets/page_indicator.dart';
import 'package:blood_bank/core/widgets/primary_button.dart';
import '../models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingModel> _slides = const [
    OnboardingModel(
      title: 'Find donors instantly',
      description: 'Connect with nearby blood donors using an easy interface.',
      iconAsset: AppAssets.onboardingFindDonors,
    ),
    OnboardingModel(
      title: 'Track donation requests',
      description: 'Stay updated with real-time emergency and donation alerts.',
      iconAsset: AppAssets.onboardingTesting,
    ),
    OnboardingModel(
      title: 'Save more lives',
      description:
          'Donate blood, manage your profile, and support your community.',
      iconAsset: AppAssets.onboardingDonated,
    ),
  ];

  bool get _isLastPage => _currentPage == _slides.length - 1;

  void _nextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  void _goToWelcome() {
    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _slides[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 40),
              child: Column(
                children: [
                  PageIndicator(total: _slides.length, current: _currentPage),
                  const SizedBox(height: 28),
                  _isLastPage
                      ? PrimaryButton(text: 'Done', onPressed: _goToWelcome)
                      : Row(
                          children: [
                            Expanded(
                              child: AppOutlineButton(
                                text: 'Skip',
                                onPressed: _goToWelcome,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: PrimaryButton(
                                text: 'Next',
                                onPressed: _nextPage,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
