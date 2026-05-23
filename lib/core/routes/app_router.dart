import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_routes.dart';
import 'package:blood_bank/features/auth/screens/login_screen.dart';
import 'package:blood_bank/features/auth/screens/signup_screen.dart';
import 'package:blood_bank/features/blood/screens/nearby_blood_banks_screen.dart';
import 'package:blood_bank/features/blood/screens/select_blood_group_screen.dart';
import 'package:blood_bank/features/emergency/screens/emergency_screen.dart';
import 'package:blood_bank/features/home/screens/home_screen.dart';
import 'package:blood_bank/features/onboarding/screens/onboarding_screen.dart';
import 'package:blood_bank/features/profile/screens/profile_screen.dart';
import 'package:blood_bank/features/splash/screens/splash_screen.dart';
import 'package:blood_bank/features/welcome/screens/welcome_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.onboarding: (_) => const OnboardingScreen(),
    AppRoutes.welcome: (_) => const WelcomeScreen(),
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.signup: (_) => const SignupScreen(),
    AppRoutes.home: (_) => const HomeScreen(),
    AppRoutes.profile: (_) => const ProfileScreen(),
    AppRoutes.selectBloodGroup: (_) => const SelectBloodGroupScreen(),
    AppRoutes.nearbyBanks: (_) => const NearbyBloodBanksScreen(),
    AppRoutes.emergency: (_) => EmergencyScreen(onBackToHome: () {}),
  };
}
