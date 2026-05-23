import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';

class AppSectionTitle extends StatelessWidget {
  final String text;

  const AppSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
    );
  }
}
