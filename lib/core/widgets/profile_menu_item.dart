import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final bool isRed;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.isRed = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(icon, width: 22),

      title: Text(
        title,
        style: TextStyle(
          color: isRed ? const Color(0xFFBF4D44) : Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
