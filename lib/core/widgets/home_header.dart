import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi ${userName.isEmpty ? "User" : userName}!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Let's Begin!",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),

            const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}