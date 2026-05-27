import 'package:blood_bank/features/blood/screens/select_blood_group_screen.dart';
import 'package:blood_bank/features/emergency/screens/location_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_assets.dart';
import 'package:blood_bank/core/constants/app_routes.dart';

class HomeBody extends StatelessWidget {
  final String? urgentBloodType;
  final String? urgentLocation;
  final List<Map<String, dynamic>> nearbyDonors;
  final VoidCallback? onEmergencyTap;

  const HomeBody({
    super.key,
    this.urgentBloodType,
    this.urgentLocation,
    this.nearbyDonors = const [],
    this.onEmergencyTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (urgentBloodType != null &&
              urgentBloodType!.isNotEmpty &&
              urgentLocation != null &&
              urgentLocation!.isNotEmpty)
            _urgentBanner(context),

          if (urgentBloodType != null && urgentBloodType!.isNotEmpty)
            const SizedBox(height: 20),

          _quickActions(context),
          const SizedBox(height: 20),
          _nearbyDonorsSection(context),
        ],
      ),
    );
  }

  Widget _urgentBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'URGENT: $urgentBloodType Needed',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white60, size: 13),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  urgentLocation ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: [
        _actionCard(
          context,
          'Donor',
          AppAssets.donorIcon,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DonorScreen()),
            );
          },
        ),

        _actionCard(
          context,
          'Blood Bank',
          AppAssets.bloodBankIcon,
          onTap: () => Navigator.pushNamed(context, AppRoutes.bloodBanks),
        ),

        _actionCard(
          context,
          'Location',
          AppAssets.locationIcon,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LocationPickerScreen(),
              ),
            );
          },
        ),

        _actionCard(
          context,
          'Emergency',
          AppAssets.emergencyIcon,
          onTap: onEmergencyTap,
        ),
      ],
    );
  }

  Widget _actionCard(
    BuildContext context,
    String title,
    String asset, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(asset, width: 52, height: 52),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nearbyDonorsSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nearby Donors',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.nearbyBanks);
              },
              child: const Text(
                'View All',
                style: TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        nearbyDonors.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No nearby donors found',
                  style: TextStyle(color: AppColors.grey),
                ),
              )
            : Column(children: nearbyDonors.map((d) => _donorCard(d)).toList()),
      ],
    );
  }

  Widget _donorCard(Map<String, dynamic> donor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                donor['blood']!,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donor['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 12,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      donor['distance']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Contact',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
