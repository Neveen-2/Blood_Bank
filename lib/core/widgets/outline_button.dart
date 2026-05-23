import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';

class AppOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final Color? borderColor;
  final Color? textColor;

  const AppOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor ?? AppColors.white, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button.copyWith(
            color: textColor ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}
