
import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';


class AppLabel extends StatelessWidget {
  final String text;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;

  const AppLabel(
    this.text, {
    super.key,
    this.color,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? AppColors.black,
      ),
    );
  }
}
