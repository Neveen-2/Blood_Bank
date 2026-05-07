import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/widgets/onboarding_page.dart';
import 'package:blood_bank/core/widgets/outline_button.dart';
import 'package:blood_bank/core/widgets/page_indicator.dart';
import 'package:blood_bank/core/widgets/primary_button.dart';
import 'package:blood_bank/view_model/onboarding/onboarding_view_model.dart';
import 'package:blood_bank/view/welcome/welcome.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingViewModel _viewModel = OnboardingViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _navigateToWelcome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
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
                controller: _viewModel.pageController,
                onPageChanged: _viewModel.onPageChanged,
                itemCount: _viewModel.onboardingPages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: _viewModel.onboardingPages[index],
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 40),
              child: Column(
                children: [
                  PageIndicator(
                    total: _viewModel.onboardingPages.length,
                    current: _viewModel.currentPage,
                  ),
                  const SizedBox(height: 28),

                  _viewModel.isLastPage
                      ? PrimaryButton(
                          text: 'Done',
                          onPressed: _navigateToWelcome,
                          width: double.infinity,
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: AppOutlineButton(
                                text: 'Skip',
                                onPressed: _navigateToWelcome,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: PrimaryButton(
                                text: 'Next',
                                onPressed: _viewModel.nextPage,
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
