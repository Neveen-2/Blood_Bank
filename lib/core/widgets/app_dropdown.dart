import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T> items;
  final Function(T?) onChanged;
  final String hint;
  final String Function(T) itemLabel;

  const AppDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.hint = 'Select',
    required this.itemLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: selectedValue,
          isExpanded: true,
          hint: Text(hint),
          items: items
              .map(
                (e) => DropdownMenuItem<T>(value: e, child: Text(itemLabel(e))),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
