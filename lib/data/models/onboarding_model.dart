import 'package:blood_bank/core/constants/app_assets.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String iconAsset;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.iconAsset,
  });


  static List<OnboardingModel> get pages => [
    OnboardingModel(
      title: 'Find Donators',
      description:
          'Usually this process takes hours and days, but once you log in you are able to find donors immediately.',
      iconAsset: AppAssets.onboardingFindDonors,
    ),
    OnboardingModel(
      title: 'Testing',
      description:
          'Your Blood Type Should Be Compatible With The Receiver\'s Type.',
      iconAsset: AppAssets.onboardingTesting,
    ),
    OnboardingModel(
      title: 'Donated',
      description: 'Donate your blood and save a life.',
      iconAsset: AppAssets.onboardingDonated,
    ),
  ];
}
