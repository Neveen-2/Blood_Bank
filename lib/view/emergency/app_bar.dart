import 'package:flutter/material.dart';
import 'package:graduation_project/core/constants/app_colors.dart';

class EmergencyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  final String title;

  const EmergencyAppBar({
    super.key,
    required this.onBack,
    this.title = 'Emergency Request',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.black,
          size: 20,
        ),
        onPressed: onBack,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}