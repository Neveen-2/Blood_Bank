import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';
import 'package:blood_bank/data/models/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.55,
            height: size.width * 0.55,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppColors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                data.iconAsset,
                width: size.width * 0.35,
                height: size.width * 0.35,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 48),

          Text(
            data.title,
            style: AppTextStyles.heading1.copyWith(fontSize: 26),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            data.description,
            style: AppTextStyles.bodyWhite.copyWith(
              // ignore: deprecated_member_use
              color: AppColors.white.withOpacity(0.85),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}