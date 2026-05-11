import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class NearbyBankCard extends StatelessWidget {
  final String hospitalName;
  final String address;
  final String phone;

  const NearbyBankCard({
    super.key,
    required this.hospitalName,
    required this.address,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hospitalName, style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),

          Row(
            children: [
              Image.asset(AppAssets.locatedIcon, width: 20, height: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(address, style: AppTextStyles.cardDetails)),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Image.asset(AppAssets.phoneIcon, width: 20, height: 20),
              const SizedBox(width: 10),
              Text(phone, style: AppTextStyles.cardDetails),
            ],
          ),
        ],
      ),
    );
  }
}
