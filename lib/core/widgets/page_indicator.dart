import 'package:flutter/material.dart';
import 'package:graduation_project/core/constants/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int total;
  final int current;

  const PageIndicator({
    super.key,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final safeCurrent = current.clamp(0, total - 1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == safeCurrent;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}