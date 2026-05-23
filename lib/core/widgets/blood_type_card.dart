import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';

class BloodTypeCard extends StatelessWidget {
  final String type;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const BloodTypeCard({
    super.key,
    required this.type,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 145,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  isSelected ? AppAssets.blood_dropIcon : AppAssets.vectorIcon,
                  width: 38,
                  height: 53.04,
                  fit: BoxFit.contain,
                ),

                Positioned(
                  top: 0,
                  right: -4,
                  child: Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF464A57),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Text(
                      type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            /// Text
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 11, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}
