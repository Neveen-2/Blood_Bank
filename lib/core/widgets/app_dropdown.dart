import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T> items;
  final String hint;
  final Function(T?) onChanged;
  final String Function(T) itemLabel;
  final IconData? icon;

  const AppDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
    this.hint = 'Select',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Icon(icon ?? Icons.keyboard_arrow_down_rounded,
              color: AppColors.grey, size: 20),

          const SizedBox(width: 10),

          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: selectedValue,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),

                hint: Text(
                  hint,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),

                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                ),

                items: items.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(itemLabel(e)),
                  );
                }).toList(),

                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}