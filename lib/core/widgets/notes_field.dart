import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';

class NotesField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const NotesField({
    super.key,
    required this.controller,
    this.hint = "Write here...",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
