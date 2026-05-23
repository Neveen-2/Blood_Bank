import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';

class AppErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const AppErrorBox({super.key, required this.message, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.primary, fontSize: 13),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(
                Icons.close,
                color: AppColors.primary,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}
